#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/utils.zsh — utility aliases
# Prefix: ru (ros2 utils)
# =============================================================================
# Foxy compatibility:
#   - ros2 doctor exists
#   - ros2 doctor -r (report) may not exist in Foxy; use --report if available
#   - ros2 --version exists
# =============================================================================

alias rdoc='ros2 doctor'                       # Run ROS2 doctor
alias rver='ros2 --version'                    # Show ROS2 CLI version

# Humble+: --report flag; Foxy may not support it
if [[ "$ROS2_DISTRO" != "foxy" ]]; then
  alias rdoce='ros2 doctor --report'           # Run ROS2 doctor with report
fi


