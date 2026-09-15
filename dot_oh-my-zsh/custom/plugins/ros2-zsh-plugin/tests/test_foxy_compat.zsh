#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_foxy_compat.zsh — Verify Foxy compatibility mode
# Run: ROS2_DISTRO=foxy zsh tests/test_foxy_compat.zsh
# =============================================================================

set -e
local plugin_dir="${0:A:h:h}"
local fail=0

echo "=== ros2 Foxy compatibility test ==="

# --- Test 1: Foxy mode detection ---
echo "[TEST] Foxy mode auto-detection ... "
export ROS2_DISTRO=foxy
ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

if [[ "$ROS2_DISTRO" == "foxy" ]]; then
  echo "  PASS: ROS2_DISTRO=foxy detected"
else
  echo "  FAIL: expected ROS2_DISTRO=foxy, got '$ROS2_DISTRO'"
  ((fail++))
fi

# --- Test 2: Foxy aliases should NOT exist ---
echo "[TEST] Missing aliases on Foxy ... "
local _missing=(rtbw rtd rifp rifpp rifproto rdoce)
local _missing_err=0
for a in "${_missing[@]}"; do
  if alias "$a" >/dev/null 2>&1; then
    echo "  FAIL: alias $a should NOT exist on Foxy"
    (( _missing_err++ ))
  fi
done
if [[ $_missing_err -eq 0 ]]; then
  echo "  PASS: all missing aliases correctly skipped"
else
  ((fail++))
fi

# --- Test 3: Foxy action alias uses send_goal ---
echo "[TEST] Foxy action alias uses send_goal ... "
local _rac_actual
_rac_actual=$(alias rac 2>/dev/null | sed "s/^rac=//; s/'//g")
if [[ "$_rac_actual" == "ros2 action send_goal" ]]; then
  echo "  PASS: rac -> ros2 action send_goal"
else
  echo "  FAIL: expected 'ros2 action send_goal', got '$_rac_actual'"
  ((fail++))
fi

# --- Test 4: Core aliases still work ---
echo "[TEST] Core aliases present on Foxy ... "
local _core=(rtl rtlt rte rsl rsc rnl rpl rpg)
local _core_err=0
for a in "${_core[@]}"; do
  if ! alias "$a" >/dev/null 2>&1; then
    echo "  FAIL: core alias $a missing on Foxy"
    (( _core_err++ ))
  fi
done
if [[ $_core_err -eq 0 ]]; then
  echo "  PASS: all core aliases present"
else
  ((fail++))
fi

# --- Test 5: Humble mode (default) should have all aliases ---
echo "[TEST] Humble+ mode has all aliases ... "
# Start a fresh subshell to avoid alias pollution
(
  export ROS2_DISTRO=humble
  ZSH="/tmp/fake-omz"
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

  local _all=(rtl rtlt rte rth rti rtt rtfind rtp rtbw rtd \
              rsl rslt rsi rst rsfind rsc \
              rnl rni \
              rpl rpg rps rpd rpdump rpload rpdesc \
              ral ralt rai rat rafind rac \
              rpkgl rpkgp rpkgx rpkgc \
              rifl rifp rifpp rifs rifproto \
              rr rrl rl \
              rbi rbp rbl \
              rdoc rdoce rver \
              cb cbs cbt cbtr cbc cbp cbup)
  local _all_err=0
  for a in "${_all[@]}"; do
    if ! alias "$a" >/dev/null 2>&1; then
      echo "  FAIL: alias $a missing on humble"
      (( _all_err++ ))
    fi
  done
  if [[ $_all_err -eq 0 ]]; then
    echo "  PASS: all aliases present on humble"
  else
    exit 1
  fi
) || ((fail++))

# Summary
echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All Foxy compatibility tests PASSED"
  exit 0
else
  echo "$fail Foxy compatibility test(s) FAILED"
  exit 1
fi
