#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# aliases/interface.zsh — ros2 interface shortcuts
# Prefix: rif (ros2 interface)
# =============================================================================
# Foxy compatibility:
#   - ros2 interface list, show exist
#   - ros2 interface packages, package, proto do NOT exist in Foxy
# =============================================================================

alias rifl='ros2 interface list'               # List all interfaces
alias rifs='ros2 interface show'               # Show interface definition

# Humble+ only
if [[ "$ROS2_DISTRO" != "foxy" ]]; then
  alias rifp='ros2 interface packages'         # List packages with interfaces
  alias rifpp='ros2 interface package'         # List interfaces in a package
  alias rifproto='ros2 interface proto'        # Show protobuf representation
fi
