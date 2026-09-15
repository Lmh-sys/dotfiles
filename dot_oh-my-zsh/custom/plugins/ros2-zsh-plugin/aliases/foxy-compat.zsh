#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/foxy-compat.zsh — Foxy-specific compatibility aliases
# Prefix: rfx (ros2 foxy)
# =============================================================================
# This module is ONLY loaded when ROS2_DISTRO=foxy.
# It provides aliases for commands that exist in newer distros but have
# different syntax or are missing in Foxy.
# =============================================================================

# Only load on Foxy
[[ "$ROS2_DISTRO" != "foxy" ]] && return 0

# ---------------------------------------------------------------------------
# Action: call → send_goal
#   Foxy uses "ros2 action send_goal" instead of "ros2 action call"
#   Already handled in aliases/action.zsh, listed here for documentation.
# ---------------------------------------------------------------------------
# alias rac='ros2 action send_goal'   # defined in action.zsh

# ---------------------------------------------------------------------------
# Topic: bw / delay missing
#   No direct replacement; users can use rqt or custom scripts.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Interface: packages / package / proto missing
#   No direct replacement in Foxy.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Run: --list missing
#   Use "ros2 pkg executables <pkg>" as fallback.
# ---------------------------------------------------------------------------
alias rrl='ros2 pkg executables'               # Foxy fallback for run --list

# ---------------------------------------------------------------------------
# Doctor: --report may not exist
#   Use "ros2 doctor" without flags.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Lifecycle: daemon: both exist in Foxy but are off by default.
# ---------------------------------------------------------------------------
