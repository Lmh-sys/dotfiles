#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/colcon.zsh — colcon build shortcuts
# Prefix: cb (colcon)
# =============================================================================

alias cb='colcon build'                        # Build workspace
alias cbs='colcon build --symlink-install'     # Build with symlink install (recommended for dev)
alias cbt='colcon test'                        # Run tests
alias cbtr='colcon test-result'                # Show test results
alias cbc='colcon clean'                       # Clean build artifacts
alias cbp='colcon build --packages-select'     # Build specific packages
alias cbup='colcon build --packages-up-to'     # Build up to specific packages
