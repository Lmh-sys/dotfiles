#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/pkg.zsh — ros2 pkg shortcuts
# Prefix: rpkg (ros2 pkg)
# =============================================================================

alias rpkgl='ros2 pkg list'                    # List all packages
alias rpkgg='ros2 pkg get'                     # Get package info (deprecated in newer ROS2, but kept for compatibility)
alias rpkgp='ros2 pkg prefix'                  # Get package install prefix
alias rpkgx='ros2 pkg xml'                     # Show package.xml
alias rpkgc='ros2 pkg create'                  # Create a new package
