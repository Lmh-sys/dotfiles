#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/jazzy-compat.zsh — Jazzy+ specific aliases
# Prefix: rjz (ros2 jazzy)
# =============================================================================
# This module is ONLY loaded when ROS2_DISTRO >= jazzy (jazzy, lyrical, rolling, or newer).
# It provides aliases for commands that are NEW in Jazzy and not available
# in Foxy/Humble/Iron.
# =============================================================================

# Guard: only load on Jazzy+
if ! _ros2_distro_at_least "jazzy" 2>/dev/null; then
  return 0
fi

# ---------------------------------------------------------------------------
# Service: echo (service introspection)
#   Jazzy adds "ros2 service echo" for viewing service client/server
#   communication. Requires introspection to be enabled in code.
# ---------------------------------------------------------------------------
alias rse='ros2 service echo'                  # Echo service traffic
alias rsef='ros2 service echo --flow-style'    # Echo with flow-style output

# ---------------------------------------------------------------------------
# Bag: service recording (Jazzy+)
#   Jazzy adds the ability to record and play service data.
# ---------------------------------------------------------------------------
alias rbsr='ros2 bag record --service'         # Record specific services
alias rbsa='ros2 bag record --all-services'    # Record all services
alias rbps='ros2 bag play --publish-service-requests'  # Play with service requests

# ---------------------------------------------------------------------------
# Topic: info --verbose (Jazzy+)
#   Jazzy adds --verbose flag to ros2 topic info
# ---------------------------------------------------------------------------
alias rtiv='ros2 topic info --verbose'         # Verbose topic info

# ---------------------------------------------------------------------------
# Action: type sub-command (Jazzy+)
#   Jazzy officially adds "ros2 action type" (may have existed in Humble)
# ---------------------------------------------------------------------------
# Already covered in action.zsh — no new alias needed here.

# ---------------------------------------------------------------------------
# Run: --log-file-name (Jazzy+)
#   Jazzy adds --log-file-name argument to ros2 run
# ---------------------------------------------------------------------------
alias rrln='ros2 run --ros-args --log-file-name'  # Run with custom log file name

# ---------------------------------------------------------------------------
# Doctor: --report (Jazzy+)
#   Already covered in utils.zsh for Humble+ — no new alias needed.
# ---------------------------------------------------------------------------
