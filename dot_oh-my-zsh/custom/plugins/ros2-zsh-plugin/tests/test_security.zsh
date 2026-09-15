#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# tests/test_security.zsh — Security-focused tests
# Run: zsh tests/test_security.zsh
# =============================================================================

set +e
local fail=0

local plugin_dir="${0:A:h:h}"

ZSH="/tmp/fake-omz"
source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"

echo "=== ros2 security test ==="

# Test 1: rrun rejects invalid package names
echo -n "[TEST] rrun rejects invalid package name ... "
if ! rrun "pkg;rm -rf /" "node" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 2: rrun rejects invalid executable names
echo -n "[TEST] rrun rejects invalid executable name ... "
if ! rrun "my_pkg" "exe;rm -rf /" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 3: rrun rejects invalid parameter names
echo -n "[TEST] rrun rejects invalid parameter name ... "
if ! rrun "my_pkg" "my_node" "bad;param:=value" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 4: rsource limits directory traversal depth
echo -n "[TEST] rsource depth limit works ... "
# Create a deep directory structure without setup.zsh
local deep_dir="/tmp/ros2_test_deep"
rm -rf "$deep_dir"
mkdir -p "$deep_dir/a/b/c/d/e/f/g/h/i/j/k/l"
cd "$deep_dir/a/b/c/d/e/f/g/h/i/j/k/l"
if ! rsource 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi
cd "$HOME"
rm -rf "$deep_dir"

# Test 5: rsource rejects non-owned files (if run as non-root and sudo works)
echo -n "[TEST] rsource ownership check ... "
if [[ $(id -u) -ne 0 ]]; then
  local test_dir="/tmp/ros2_test_owner"
  rm -rf "$test_dir"
  mkdir -p "$test_dir/install"
  touch "$test_dir/install/setup.zsh"
  sudo chown nobody "$test_dir/install/setup.zsh" 2>/dev/null || true
  cd "$test_dir"
  # Verify sudo/nobody actually changed the owner; otherwise skip in restricted envs
  local file_uid current_uid
  current_uid=$(id -u)
  if command -v stat >/dev/null 2>&1; then
    if stat -c %u /dev/null >/dev/null 2>&1; then
      file_uid=$(stat -c %u "$test_dir/install/setup.zsh" 2>/dev/null)
    else
      file_uid=$(stat -f %u "$test_dir/install/setup.zsh" 2>/dev/null)
    fi
  fi
  if [[ -n "$file_uid" ]] && [[ "$file_uid" != "$current_uid" ]]; then
    if ! rsource 2>/dev/null; then
      echo "PASS"
    else
      echo "FAIL"
      ((fail++))
    fi
  else
    echo "SKIP (could not change file owner for test)"
  fi
  cd "$HOME"
  rm -rf "$test_dir"
else
  echo "SKIP (running as root)"
fi

# Test 6: rkill requires exact match (no fuzzy matching)
echo -n "[TEST] rkill requires exact match ... "
# This test is limited since we can't easily mock ros2 node list
# We test that rkill with empty pattern fails
if ! rkill "" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 7: rbagplay rejects unknown options
echo -n "[TEST] rbagplay rejects unknown options ... "
if ! rbagplay "/tmp/test.bag" --unknown 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 8: rbagplay requires numeric rate
echo -n "[TEST] rbagplay requires numeric rate ... "
if ! rbagplay "/tmp/test.bag" --rate "abc" 2>/dev/null; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

# Test 9: Environment variable toggle works
echo -n "[TEST] ROS2_ENABLE_BAG=0 disables bag aliases ... "
local toggle_result=1
(
  # Start fresh subshell without any prior plugin load
  unalias -a 2>/dev/null || true
  unset ROS2_ENABLE_BAG
  export ROS2_ENABLE_BAG=0
  ZSH="/tmp/fake-omz"
  source "$plugin_dir/ros2-zsh-plugin.plugin.zsh"
  # Check if rbi alias was NOT defined
  if ! alias rbi >/dev/null 2>&1; then
    exit 0
  else
    exit 1
  fi
)
local subshell_exit=$?
if [[ $subshell_exit -eq 0 ]]; then
  toggle_result=0
fi

if [[ $toggle_result -eq 0 ]]; then
  echo "PASS"
else
  echo "FAIL"
  ((fail++))
fi

echo "================================"
if [[ $fail -eq 0 ]]; then
  echo "All security tests PASSED"
  exit 0
else
  echo "$fail security test(s) FAILED"
  exit 1
fi
