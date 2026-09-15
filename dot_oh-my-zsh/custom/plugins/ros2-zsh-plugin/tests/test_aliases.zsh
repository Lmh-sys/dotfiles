#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_aliases.zsh — Verify alias expansion for all modules
# Run: zsh tests/test_aliases.zsh
# =============================================================================

set -e
local plugin_dir="${0:A:h:h}"
local fail=0

# Source plugin in a controlled way
# Clear ROS_DISTRO to test without auto-detection
unset ROS_DISTRO
unset ROS2_DISTRO
ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

echo "=== ros2 alias expansion test ==="

# Helper
_check_alias() {
  local name="$1"
  local expected="$2"
  local actual
  actual=$(alias "$name" 2>/dev/null | sed "s/^${name}=//; s/'//g")
  if [[ "$actual" == "$expected" ]]; then
    echo "  PASS: $name -> $actual"
  else
    echo "  FAIL: $name expected '$expected', got '$actual'"
    ((fail++))
  fi
}

_check_alias_exists() {
  local name="$1"
  if alias "$name" >/dev/null 2>&1; then
    echo "  PASS: $name exists"
  else
    echo "  FAIL: $name not found"
    ((fail++))
  fi
}

# === Topic aliases ===
echo "[GROUP] Topic aliases"
_check_alias "rtl" "ros2 topic list"
_check_alias "rtlt" "ros2 topic list -t"
_check_alias "rte" "ros2 topic echo"
_check_alias "rth" "ros2 topic hz"
_check_alias "rti" "ros2 topic info"
_check_alias "rtt" "ros2 topic type"
_check_alias "rtfind" "ros2 topic find"
_check_alias "rtp" "ros2 topic pub"
# Note: rtbw, rtd are Humble+ only, tested in test_foxy_compat.zsh

# === Service aliases ===
echo "[GROUP] Service aliases"
_check_alias "rsl" "ros2 service list"
_check_alias "rslt" "ros2 service list -t"
_check_alias "rsi" "ros2 service info"
_check_alias "rst" "ros2 service type"
_check_alias "rsfind" "ros2 service find"
_check_alias "rsc" "ros2 service call"

# === Node aliases ===
echo "[GROUP] Node aliases"
_check_alias "rnl" "ros2 node list"
_check_alias "rni" "ros2 node info"

# === Param aliases ===
echo "[GROUP] Param aliases"
_check_alias "rpl" "ros2 param list"
_check_alias "rpg" "ros2 param get"
_check_alias "rps" "ros2 param set"
_check_alias "rpd" "ros2 param delete"
_check_alias "rpdump" "ros2 param dump"
_check_alias "rpload" "ros2 param load"
_check_alias "rpdesc" "ros2 param describe"

# === Action aliases ===
echo "[GROUP] Action aliases"
_check_alias "ral" "ros2 action list"
_check_alias "ralt" "ros2 action list -t"
_check_alias "rai" "ros2 action info"
_check_alias "rat" "ros2 action type"
_check_alias "rafind" "ros2 action find"
_check_alias "rac" "ros2 action call"

# === Package aliases ===
echo "[GROUP] Package aliases"
_check_alias "rpkgl" "ros2 pkg list"
_check_alias "rpkgg" "ros2 pkg get"
_check_alias "rpkgp" "ros2 pkg prefix"
_check_alias "rpkgx" "ros2 pkg xml"
_check_alias "rpkgc" "ros2 pkg create"

# === Interface aliases ===
echo "[GROUP] Interface aliases"
_check_alias "rifl" "ros2 interface list"
_check_alias "rifs" "ros2 interface show"
# Note: rifp, rifpp, rifproto are Humble+ only, tested in test_foxy_compat.zsh

# === Run aliases ===
echo "[GROUP] Run aliases"
_check_alias "rr" "ros2 run"
# Note: rrl is Humble+ only, tested in test_foxy_compat.zsh

# === Launch aliases ===
echo "[GROUP] Launch aliases"
_check_alias "rl" "ros2 launch"

# === Bag aliases ===
echo "[GROUP] Bag aliases"
_check_alias "rbi" "ros2 bag info"
_check_alias "rbp" "ros2 bag play"
_check_alias "rbl" "ros2 bag list"

# Note: lifecycle (rlcl) and daemon (rdstart) are disabled by default (ROS2_ENABLE_LIFECYCLE=0, ROS2_ENABLE_DAEMON=0)

# === Colcon aliases ===
echo "[GROUP] Colcon aliases"
_check_alias "cb" "colcon build"
_check_alias "cbs" "colcon build --symlink-install"
_check_alias "cbt" "colcon test"
_check_alias "cbtr" "colcon test-result"
_check_alias "cbc" "colcon clean"
_check_alias "cbp" "colcon build --packages-select"
_check_alias "cbup" "colcon build --packages-up-to"

# === Utility aliases ===
echo "[GROUP] Utility aliases"
_check_alias "rdoc" "ros2 doctor"
_check_alias "rver" "ros2 --version"
# Note: rdoce is Humble+ only, tested in test_foxy_compat.zsh

# Summary
echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All alias tests PASSED"
  exit 0
else
  echo "$fail alias test(s) FAILED"
  exit 1
fi
