#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_functions.zsh — Verify function existence
# Run: zsh tests/test_functions.zsh
# =============================================================================

set -e
local plugin_dir="${0:A:h:h}"
local fail=0

ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

echo "=== ros2 function existence test ==="

# Helper
_check_function() {
  local name="$1"
  if typeset -f "$name" >/dev/null 2>&1; then
    echo "  PASS: function $name exists"
  else
    echo "  FAIL: function $name not found"
    ((fail++))
  fi
}

_check_function "rsource"
_check_function "rcd"
_check_function "rbuild"
_check_function "r2echo"
_check_function "r2hz"
_check_function "rrun"
_check_function "rbag"
_check_function "rbagplay"
_check_function "rkill"

echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All function tests PASSED"
  exit 0
else
  echo "$fail function test(s) FAILED"
  exit 1
fi
