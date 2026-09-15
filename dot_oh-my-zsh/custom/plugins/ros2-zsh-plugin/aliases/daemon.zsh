#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/daemon.zsh — ros2 daemon shortcuts
# Prefix: rd (ros2 daemon)
# Off by default (ROS2_ENABLE_DAEMON=0)
# =============================================================================

alias rdstart='ros2 daemon start'              # Start ROS2 daemon
alias rdstop='ros2 daemon stop'                # Stop ROS2 daemon
alias rdstatus='ros2 daemon status'            # Check daemon status
