#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/run.zsh — ros2 run shortcuts
# Prefix: rr (ros2 run)
# =============================================================================
# Foxy compatibility:
#   - ros2 run exists
#   - ros2 run --list does NOT exist in Foxy (use ros2 pkg executables instead)
# =============================================================================

alias rr='ros2 run'                            # Run a node (needs args)

# Humble+ only
if [[ "$ROS2_DISTRO" != "foxy" ]]; then
  alias rrl='ros2 run --list'                  # List executables in a package
fi
