#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/action.zsh — ros2 action shortcuts
# Prefix: ra (ros2 action)
# =============================================================================
# Foxy compatibility:
#   - ros2 action list, info, type, find exist
#   - ros2 action call does NOT exist in Foxy; use ros2 action send_goal instead
# =============================================================================

alias ral='ros2 action list'                   # List all actions
alias ralt='ros2 action list -t'               # List actions with types
alias rai='ros2 action info'                   # Action info (needs arg)
alias rat='ros2 action type'                   # Action type (needs arg)
alias rafind='ros2 action find'                # Find actions by type

# Foxy: action call → send_goal
# When ROS2_DISTRO is empty/unknown, default to newer behavior (Humble+)
if [[ "$ROS2_DISTRO" == "foxy" ]]; then
  alias rac='ros2 action send_goal'            # Send goal (Foxy syntax)
else
  alias rac='ros2 action call'                 # Call action (Humble+)
fi
