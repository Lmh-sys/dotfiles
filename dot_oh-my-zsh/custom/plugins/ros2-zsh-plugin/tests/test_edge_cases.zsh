#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_edge_cases.zsh — Edge case and error handling tests
# Run: zsh tests/test_edge_cases.zsh
# =============================================================================

set -e
local plugin_dir="${0:A:h:h}"
local fail=0

ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

echo "=== ros2 edge case test ==="

# Test 1: r2echo with empty topic
echo -n "[TEST] r2echo rejects empty topic ... "
if ! r2echo "" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 2: r2hz with empty topic
echo -n "[TEST] r2hz rejects empty topic ... "
if ! r2hz "" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 3: rbag with no topics
echo -n "[TEST] rbag rejects no topics ... "
if ! rbag 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 4: rcd with invalid hint
echo -n "[TEST] rcd rejects invalid directory hint ... "
if ! rcd "/nonexistent/path" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 5: rbuild passes arguments correctly
echo -n "[TEST] rbuild echo mode with args ... "
# We can't actually run colcon, but we test the echo output
local output
output=$(rbuild "pkg1" "pkg2" 2>&1 | head -1)
if [[ "$output" == *"packages-up-to pkg1 pkg2"* ]]; then
  echo "PASS"
else
  echo "FAIL (got: $output)"
  ((fail++))
fi

# Test 6: rsource with explicit non-existent file
echo -n "[TEST] rsource rejects non-existent file ... "
if ! rsource "/tmp/nonexistent_setup.zsh" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 7: Multiple environment variable toggles
echo -n "[TEST] Multiple env toggles work ... "
(
  unalias -a 2>/dev/null || true
  ZSH="/tmp/fake-omz"
  ROS2_ENABLE_BAG=0
  ROS2_ENABLE_LIFECYCLE=1
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"
  local bag_ok=0
  local lifecycle_ok=0
  ! alias rbi >/dev/null 2>&1 && bag_ok=1
  alias rlcl >/dev/null 2>&1 && lifecycle_ok=1
  if [[ $bag_ok -eq 1 && $lifecycle_ok -eq 1 ]]; then
    echo "PASS"
  else
    echo "FAIL"
    ((fail++))
  fi
)

echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All edge case tests PASSED"
  exit 0
else
  echo "$fail edge case test(s) FAILED"
  exit 1
fi
