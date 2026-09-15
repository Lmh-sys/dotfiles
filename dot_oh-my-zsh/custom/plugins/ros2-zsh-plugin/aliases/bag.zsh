#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/bag.zsh — ros2 bag shortcuts
# Prefix: rb (ros2 bag)
# WARNING: These are safe read-only by default. Record commands require explicit args.
# =============================================================================
# Foxy compatibility: all bag verbs exist in Foxy.
# =============================================================================

alias rbi='ros2 bag info'                      # Show bag info (needs arg)
alias rbp='ros2 bag play'                      # Play a bag (needs arg)
alias rbl='ros2 bag list'                      # List bags in a directory


