#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# functions/workspace.zsh — workspace helpers
# =============================================================================

# ---------------------------------------------------------------------------
# rsource — Source the current workspace install/setup.zsh
# Usage: rsource [path]
#   If no path given, searches upward for install/setup.zsh
#   Limited to 10 directory levels deep
#   Verifies file ownership before sourcing
# ---------------------------------------------------------------------------
rsource() {
  local target="${1:-}"
  if [[ -z "$target" ]]; then
    local dir="$PWD"
    local depth=0
    local max_depth=10
    while [[ "$dir" != "/" ]] && [[ $depth -lt $max_depth ]]; do
      if [[ -f "$dir/install/setup.zsh" ]]; then
        target="$dir/install/setup.zsh"
        break
      elif [[ -f "$dir/install/setup.bash" ]]; then
        target="$dir/install/setup.bash"
        break
      fi
      dir="${dir:h}"
      ((depth++))
    done

    if [[ $depth -ge $max_depth ]]; then
      echo "[ros2] Search depth limit ($max_depth) reached. Use 'rsource <path>' to specify directly." >&2
      return 1
    fi
  fi

  if [[ -z "$target" ]]; then
    echo "[ros2] No install/setup.zsh found in current or parent directories." >&2
    return 1
  fi

  if [[ ! -f "$target" ]]; then
    echo "[ros2] File not found: $target" >&2
    return 1
  fi

  # Verify file is owned by current user (security check)
  if command -v stat >/dev/null 2>&1; then
    local file_owner
    # Linux uses -c %u, macOS/BSD uses -f %u
    if stat -c %u /dev/null >/dev/null 2>&1; then
      file_owner=$(stat -c %u "$target" 2>/dev/null)
    else
      file_owner=$(stat -f %u "$target" 2>/dev/null)
    fi
    local current_uid
    current_uid=$(id -u)
    if [[ -n "$file_owner" ]] && [[ "$file_owner" != "$current_uid" ]]; then
      echo "[ros2] Security warning: $target is not owned by you (owner UID: $file_owner, your UID: $current_uid)" >&2
      echo "[ros2] Use 'rsource $target' again to force, or investigate the file." >&2
      return 1
    fi
  fi

  echo "[ros2] Sourcing $target ..."
  source "$target"
}

# ---------------------------------------------------------------------------
# rcd — cd into workspace root (searches upward for src/ or install/)
# Usage: rcd [hint]
# ---------------------------------------------------------------------------
rcd() {
  local hint="${1:-}"
  local dir="$PWD"

  # If hint provided, try it first
  if [[ -n "$hint" ]]; then
    if [[ -d "$hint" ]]; then
      cd "$hint"
      return 0
    elif [[ -d "$HOME/$hint" ]]; then
      cd "$HOME/$hint"
      return 0
    fi
    echo "[ros2] Directory not found: $hint" >&2
    return 1
  fi

  # Search upward for typical ROS2 workspace markers
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/src" ]] || [[ -d "$dir/install" ]] || [[ -f "$dir/.colcon" ]]; then
      cd "$dir"
      echo "[ros2] Entered workspace: $dir"
      return 0
    fi
    dir="${dir:h}"
  done

  echo "[ros2] No ROS2 workspace marker found (src/, install/, .colcon)." >&2
  return 1
}

# ---------------------------------------------------------------------------
# rbuild — Smart colcon build wrapper
# Usage: rbuild [pkg1 pkg2 ...]
#   If no args: colcon build --symlink-install
#   If args:    colcon build --symlink-install --packages-up-to "$@"
# ---------------------------------------------------------------------------
rbuild() {
  if ! command -v colcon >/dev/null 2>&1; then
    echo "[ros2] Error: colcon not found. Please source your ROS2 workspace first." >&2
    return 1
  fi

  if [[ $# -eq 0 ]]; then
    echo "[ros2] colcon build --symlink-install"
    colcon build --symlink-install
  else
    echo "[ros2] colcon build --symlink-install --packages-up-to $*"
    colcon build --symlink-install --packages-up-to "$@"
  fi
}
