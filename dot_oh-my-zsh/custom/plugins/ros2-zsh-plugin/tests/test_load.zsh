#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_load.zsh — Basic load and sanity checks
# Run: zsh tests/test_load.zsh
# =============================================================================

set -e
local fail=0
local plugin_dir="${0:A:h:h}"

echo "=== ros2 load test ==="

# 1. Syntax check main file
echo -n "[TEST] Syntax check ros2-zsh-plugin.plugin.zsh ... "
if zsh -n "$plugin_dir/ros2-zsh-plugin.plugin.zsh"; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# 2. Source check in subshell
echo -n "[TEST] Source plugin without OMZ ... "
if (
  ZSH="/tmp/fake-omz"
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"
); then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# 3. Check alias files syntax
echo -n "[TEST] Syntax check all alias files ... "
local alias_err=0
for f in "$plugin_dir"/aliases/*.zsh; do
  zsh -n "$f" || ((alias_err++))
done
if [[ $alias_err -eq 0 ]]; then
  echo "PASS"
else
  echo "FAIL ($alias_err errors)"
  ((fail++))
fi

# 4. Check function files syntax
echo -n "[TEST] Syntax check all function files ... "
local func_err=0
for f in "$plugin_dir"/functions/*.zsh; do
  zsh -n "$f" || ((func_err++))
done
if [[ $func_err -eq 0 ]]; then
  echo "PASS"
else
  echo "FAIL ($func_err errors)"
  ((fail++))
fi

# Summary
echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All tests PASSED"
  exit 0
else
  echo "$fail test(s) FAILED"
  exit 1
fi
