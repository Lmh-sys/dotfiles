#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/lifecycle.zsh — ros2 lifecycle shortcuts
# Prefix: rlc (ros2 lifecycle)
# Off by default (ROS2_ENABLE_LIFECYCLE=0)
# =============================================================================

alias rlcl='ros2 lifecycle list'               # List lifecycle nodes
alias rlci='ros2 lifecycle info'               # Get lifecycle state info
alias rlcs='ros2 lifecycle set'                # Set lifecycle state
alias rlcg='ros2 lifecycle get'                # Get current lifecycle state
