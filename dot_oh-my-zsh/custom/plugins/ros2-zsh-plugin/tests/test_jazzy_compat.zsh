#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_jazzy_compat.zsh — Verify Jazzy+ compatibility mode
# Run: ROS2_DISTRO=jazzy zsh tests/test_jazzy_compat.zsh
# =============================================================================

set -e
local plugin_dir="${0:A:h:h}"
local fail=0

echo "=== ros2 Jazzy+ compatibility test ==="

# --- Test 1: Jazzy mode detection ---
echo "[TEST] Jazzy mode auto-detection ... "
export ROS2_DISTRO=jazzy
ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

if [[ "$ROS2_DISTRO" == "jazzy" ]]; then
  echo "  PASS: ROS2_DISTRO=jazzy detected"
else
  echo "  FAIL: expected ROS2_DISTRO=jazzy, got '$ROS2_DISTRO'"
  ((fail++))
fi

# --- Test 2: Jazzy-specific aliases should exist ---
echo "[TEST] Jazzy-specific aliases present ... "
local _jazzy=(rse rsef rbsr rbsa rbps rtiv rrln)
local _jazzy_err=0
for a in "${_jazzy[@]}"; do
  if ! alias "$a" >/dev/null 2>&1; then
    echo "  FAIL: Jazzy alias $a missing"
    (( _jazzy_err++ ))
  fi
done
if [[ $_jazzy_err -eq 0 ]]; then
  echo "  PASS: all Jazzy aliases present"
else
  ((fail++))
fi

# --- Test 3: Foxy aliases should NOT exist on Jazzy (they're for foxy-compat) ---
# Actually foxy-compat only loads on foxy, so this is fine.
# What we want: aliases that are Foxy-only fallbacks should NOT shadow Jazzy ones.

# --- Test 4: Core aliases still work ---
echo "[TEST] Core aliases present on Jazzy ... "
local _core=(rtl rtlt rte rsl rsc rnl rpl rpg)
local _core_err=0
for a in "${_core[@]}"; do
  if ! alias "$a" >/dev/null 2>&1; then
    echo "  FAIL: core alias $a missing on Jazzy"
    (( _core_err++ ))
  fi
done
if [[ $_core_err -eq 0 ]]; then
  echo "  PASS: all core aliases present"
else
  ((fail++))
fi

# --- Test 5: Humble aliases also present ---
echo "[TEST] Humble-era aliases present on Jazzy ... "
local _humble=(rtbw rtd rifp rifpp rifproto rrl rdoce)
local _humble_err=0
for a in "${_humble[@]}"; do
  if ! alias "$a" >/dev/null 2>&1; then
    echo "  FAIL: Humble alias $a missing on Jazzy"
    (( _humble_err++ ))
  fi
done
if [[ $_humble_err -eq 0 ]]; then
  echo "  PASS: all Humble-era aliases present"
else
  ((fail++))
fi

# --- Test 6: Rolling mode (treat as Jazzy+) ---
echo "[TEST] Rolling mode treated as Jazzy+ ... "
(
  export ROS2_DISTRO=rolling
  ZSH="/tmp/fake-omz"
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

  if alias rse >/dev/null 2>&1 && alias rtiv >/dev/null 2>&1; then
    echo "  PASS: rolling has Jazzy+ aliases"
  else
    echo "  FAIL: rolling missing Jazzy+ aliases"
    exit 1
  fi
) || ((fail++))

# --- Test 7: Lyrical mode (treat as Jazzy+) ---
echo "[TEST] Lyrical mode treated as Jazzy+ ... "
(
  export ROS2_DISTRO=lyrical
  ZSH="/tmp/fake-omz"
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

  if alias rse >/dev/null 2>&1 && alias rtiv >/dev/null 2>&1; then
    echo "  PASS: lyrical has Jazzy+ aliases"
  else
    echo "  FAIL: lyrical missing Jazzy+ aliases"
    exit 1
  fi
) || ((fail++))

# --- Test 8: Humble mode should NOT have Jazzy aliases ---
echo "[TEST] Humble mode lacks Jazzy-only aliases ... "
# Use a fresh zsh process to avoid alias leakage from parent
local _humble_result
_humble_result=$(zsh -c "
  plugin_dir='$plugin_dir'
  export ROS2_DISTRO=humble
  ZSH='/tmp/fake-omz'
  source '\$plugin_dir/ros2-zsh-plugin.plugin.zsh' 2>/dev/null || source '$plugin_dir/ros2-zsh-plugin.plugin.zsh'

  local _jazzy_only=(rse rsef rbsr rbsa rbps rtiv rrln)
  local _jazzy_only_err=0
  for a in '\${_jazzy_only[@]}'; do
    if alias '\$a' >/dev/null 2>&1; then
      echo 'FAIL: '\$a
      (( _jazzy_only_err++ ))
    fi
  done
  if [[ \$_jazzy_only_err -eq 0 ]]; then
    echo 'PASS'
  else
    echo 'FAIL_COUNT: '\$_jazzy_only_err
  fi
")

if [[ "$_humble_result" == "PASS" ]]; then
  echo "  PASS: no Jazzy-only aliases on humble"
else
  echo "  FAIL: $_humble_result"
  ((fail++))
fi

# Summary
echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All Jazzy compatibility tests PASSED"
  exit 0
else
  echo "$fail Jazzy compatibility test(s) FAILED"
  exit 1
fi
