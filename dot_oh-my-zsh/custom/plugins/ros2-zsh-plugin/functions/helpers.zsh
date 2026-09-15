#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# functions/helpers.zsh — helper functions for common ROS2 operations
# =============================================================================
# Foxy compatibility notes:
#   - r2echo, r2hz, rrun, rbag, rbagplay, rkill all work on Foxy
#   - rrun uses --ros-args -p which is valid on Foxy
#   - rbag uses ros2 bag record which exists on Foxy
# =============================================================================

# ---------------------------------------------------------------------------
# r2echo — Smart ros2 topic echo with optional type
# Usage: r2echo <topic_name> [type]
#   If type not provided, auto-detects via ros2 topic type
# ---------------------------------------------------------------------------
r2echo() {
  local topic="${1:-}"
  if [[ -z "$topic" ]]; then
    echo "Usage: r2echo <topic_name> [type]" >&2
    return 1
  fi

  local msg_type="${2:-}"
  if [[ -z "$msg_type" ]]; then
    msg_type=$(ros2 topic type "$topic" 2>/dev/null)
    if [[ -z "$msg_type" ]]; then
      echo "[ros2] Could not determine type for topic: $topic" >&2
      return 1
    fi
  fi

  echo "[ros2] ros2 topic echo $topic $msg_type"
  ros2 topic echo "$topic" "$msg_type"
}

# ---------------------------------------------------------------------------
# r2hz — ros2 topic hz with sensible defaults
# Usage: r2hz <topic_name> [window_size]
# ---------------------------------------------------------------------------
r2hz() {
  local topic="${1:-}"
  local window="${2:-}"
  if [[ -z "$topic" ]]; then
    echo "Usage: r2hz <topic_name> [window_size]" >&2
    return 1
  fi

  if [[ -n "$window" ]]; then
    ros2 topic hz --window "$window" "$topic"
  else
    ros2 topic hz "$topic"
  fi
}

# ---------------------------------------------------------------------------
# rrun — ros2 run with --ros-args auto-detection
# Usage: rrun <pkg> <exe> [param1:=val1 param2:=val2 ...]
#   Automatically appends --ros-args -p for key:=value pairs
#   Validates package and executable names for safety
# ---------------------------------------------------------------------------
rrun() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: rrun <package> <executable> [param1:=value1 ...]" >&2
    return 1
  fi

  if ! command -v ros2 >/dev/null 2>&1; then
    echo "[ros2] Error: ros2 not found. Please source your ROS2 workspace first." >&2
    return 1
  fi

  local pkg="$1"
  local exe="$2"
  shift 2

  # Validate package name (alphanumeric, underscores, hyphens only)
  if [[ ! "$pkg" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "[ros2] Invalid package name: $pkg (only a-z, A-Z, 0-9, _, - allowed)" >&2
    return 1
  fi

  # Validate executable name (alphanumeric, underscores, hyphens only)
  if [[ ! "$exe" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "[ros2] Invalid executable name: $exe (only a-z, A-Z, 0-9, _, - allowed)" >&2
    return 1
  fi

  local ros_args=()
  local other_args=()

  for arg in "$@"; do
    if [[ "$arg" == *:=* ]]; then
      # Validate ROS parameter name format: key:=value
      # Parameter names may contain namespaces separated by '/'.
      local param_name="${arg%%:=*}"
      if [[ ! "$param_name" =~ ^[a-zA-Z0-9_./-]+$ ]]; then
        echo "[ros2] Invalid parameter name: $param_name" >&2
        return 1
      fi
      ros_args+=(-p "$arg")
    else
      other_args+=("$arg")
    fi
  done

  if [[ ${#ros_args} -gt 0 ]]; then
    echo "[ros2] ros2 run $pkg $exe --ros-args ${ros_args[*]} -- ${other_args[*]}"
    ros2 run "$pkg" "$exe" --ros-args "${ros_args[@]}" -- "${other_args[@]}"
  else
    echo "[ros2] ros2 run $pkg $exe ${other_args[*]}"
    ros2 run "$pkg" "$exe" "${other_args[@]}"
  fi
}

# ---------------------------------------------------------------------------
# rbag — Safe bag record wrapper
# Usage: rbag [-o output] <topic1> [topic2 ...]
#   Defaults to ~/ros2_bags/bag_$(date +%Y%m%d_%H%M%S)
# ---------------------------------------------------------------------------
rbag() {
  local out=""
  local topics=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -o|--output)
        if [[ -z "${2:-}" ]]; then
          echo "[ros2] Error: -o/--output requires a path argument" >&2
          return 1
        fi
        out="$2"
        shift 2
        ;;
      -*)
        echo "Unknown option: $1" >&2
        return 1
        ;;
      *)
        topics+=("$1")
        shift
        ;;
    esac
  done

  if [[ ${#topics} -eq 0 ]]; then
    echo "Usage: rbag [-o output] <topic1> [topic2 ...]" >&2
    return 1
  fi

  if [[ -z "$out" ]]; then
    local bag_dir="$HOME/ros2_bags"
    [[ -d "$bag_dir" ]] || mkdir -p "$bag_dir"
    out="$bag_dir/bag_$(date +%Y%m%d_%H%M%S)"
  fi

  echo "[ros2] Recording to: $out"
  echo "[ros2] Topics: ${topics[*]}"
  ros2 bag record -o "$out" "${topics[@]}"
}

# ---------------------------------------------------------------------------
# rbagplay — Bag play with optional rate and loop
# Usage: rbagplay <bag_path> [--rate RATE] [--loop]
#   Explicit option flags prevent positional argument ambiguity
# ---------------------------------------------------------------------------
rbagplay() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: rbagplay <bag_path> [--rate RATE] [--loop]" >&2
    return 1
  fi

  local bag="$1"
  shift

  local rate=""
  local loop=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --rate)
        if [[ -n "$2" ]] && [[ "$2" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
          rate="--rate $2"
          shift 2
        else
          echo "[ros2] Error: --rate requires a numeric value" >&2
          return 1
        fi
        ;;
      --loop|-l)
        loop="--loop"
        shift
        ;;
      *)
        echo "[ros2] Unknown option: $1" >&2
        echo "Usage: rbagplay <bag_path> [--rate RATE] [--loop]" >&2
        return 1
        ;;
    esac
  done

  echo "[ros2] ros2 bag play $rate $loop $bag"
  ros2 bag play $rate $loop "$bag"
}

# ---------------------------------------------------------------------------
# rkill — Kill ROS2 nodes by exact name (safe: asks for confirmation)
# Usage: rkill <node_name>
#   Only matches exact node names from 'ros2 node list'
#   Uses pgrep -x for exact process name matching
#   Verifies process belongs to ROS2 before killing
# ---------------------------------------------------------------------------
rkill() {
  local pattern="${1:-}"
  if [[ -z "$pattern" ]]; then
    echo "Usage: rkill <node_name>" >&2
    return 1
  fi

  # Get exact node names from ros2 node list
  local nodes
  nodes=$(ros2 node list 2>/dev/null | grep -F "$pattern")
  if [[ -z "$nodes" ]]; then
    echo "[ros2] No nodes matched: $pattern" >&2
    return 1
  fi

  # Filter to exact match only
  local exact_nodes=""
  while IFS= read -r node; do
    # Remove leading slash for matching if present
    local node_clean="${node#/}"
    if [[ "$node" == "$pattern" ]] || [[ "$node_clean" == "$pattern" ]]; then
      exact_nodes+="$node"$'\n'
    fi
  done <<< "$nodes"

  if [[ -z "$exact_nodes" ]]; then
    echo "[ros2] No exact match found for: $pattern" >&2
    echo "[ros2] Available matches:" >&2
    echo "$nodes" >&2
    return 1
  fi

  echo "[ros2] Matched nodes:"
  echo "$exact_nodes"
  echo -n "Kill these nodes? [y/N] "
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    while IFS= read -r node; do
      [[ -z "$node" ]] && continue
      # Extract executable name from node (last component after /)
      local exe_name="${node##*/}"
      # Use exact match on process name, not full command line
      local pids
      pids=$(pgrep -x "$exe_name" 2>/dev/null)
      if [[ -z "$pids" ]]; then
        echo "[ros2] No process found for node: $node (exe: $exe_name)"
        continue
      fi
      # Verify each PID is a ROS2 process (cmdline contains ros2 or the exe)
      while IFS= read -r pid; do
        [[ -z "$pid" ]] && continue
        local cmdline
        if [[ -f "/proc/$pid/cmdline" ]]; then
          cmdline=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null)
        else
          cmdline=$(ps -p "$pid" -o command= 2>/dev/null)
        fi
        if [[ "$cmdline" == *"ros2"* ]] || [[ "$cmdline" == *"$exe_name"* ]]; then
          echo "[ros2] Killing $node (PID $pid)"
          kill "$pid"
          # Wait and verify termination
          sleep 0.5
          if kill -0 "$pid" 2>/dev/null; then
            echo "[ros2] Node $node did not terminate, sending SIGKILL..."
            kill -9 "$pid"
          fi
        else
          echo "[ros2] Skipping PID $pid (not a ROS2 process: $cmdline)"
        fi
      done <<< "$pids"
    done <<< "$exact_nodes"
  else
    echo "[ros2] Cancelled."
  fi
}
