#!/usr/bin/env zsh
# vim: set ft=zsh:
# =============================================================================
# ros2-zsh-plugin — Oh My Zsh plugin for ROS 2 CLI
# https://github.com/leelong2020/ros2-zsh-plugin
# =============================================================================
# A fast, safe, modular alias/function system for daily ROS 2 development.
#
# Design principles:
#   - Short but readable: 2-4 character prefixes
#   - Modular loading: enable/disable per subsystem via env vars
#   - Safe defaults: no destructive aliases enabled by default
#   - Function-over-alias: anything with logic/args uses a function
# =============================================================================

# ---------------------------------------------------------------------------
# 0. Guard: warn if not running under Oh My Zsh, but continue anyway
#    This plugin supports both OMZ and manual source installation.
# ---------------------------------------------------------------------------
[[ -z "$ZSH" ]] && echo "[ros2-zsh-plugin] Warning: ZSH not set, continuing in manual mode" >&2

# ---------------------------------------------------------------------------
# 1. Resolve plugin root (works for OMZ custom/plugins and manual install)
# ---------------------------------------------------------------------------
local _ROS2_DIR="${0:A:h}"

# ---------------------------------------------------------------------------
# 2. Default feature flags (override before sourcing if desired)
#    Example in ~/.zshrc BEFORE plugins=(... ros2-zsh-plugin ...):
#      export ROS2_ENABLE_BAG=0
# ---------------------------------------------------------------------------
: ${ROS2_ENABLE_CORE:=1}      # topic, service, node, param, action
: ${ROS2_ENABLE_PKG:=1}       # pkg, interface
: ${ROS2_ENABLE_RUN:=1}       # run, launch
: ${ROS2_ENABLE_BAG:=1}       # bag record/play
: ${ROS2_ENABLE_LIFECYCLE:=0} # lifecycle (less common; off by default)
: ${ROS2_ENABLE_DAEMON:=0}    # daemon (off by default)
: ${ROS2_ENABLE_COLCON:=1}    # colcon helpers
: ${ROS2_ENABLE_ENV:=1}       # workspace source helpers (functions)
: ${ROS2_ENABLE_UTILS:=1}     # misc helpers (doctor, etc.)

# ---------------------------------------------------------------------------
# 2.5 Distribution compatibility layer
#    ROS 2 Foxy (LTS, EOL June 2023) lacks some CLI verbs present in
#    Humble/Jazzy/Rolling.  Jazzy adds new verbs not in Foxy/Humble.
#    When ROS2_DISTRO is detected (or the user explicitly exports it),
#    aliases that depend on missing verbs are automatically disabled
#    and safe fallbacks are loaded instead.
# ---------------------------------------------------------------------------
: ${ROS2_DISTRO:=""}

# Auto-detect distro if not set
if [[ -z "$ROS2_DISTRO" ]] && [[ -n "$ROS_DISTRO" ]]; then
  ROS2_DISTRO="$ROS_DISTRO"
fi

# Normalise to lower-case
ROS2_DISTRO="${ROS2_DISTRO:l}"

# Version comparison helper: returns 0 if current distro >= reference
# Usage: _ros2_distro_at_least "humble"  → 0 if ROS2_DISTRO is humble/jazzy/lyrical/rolling
_ros2_distro_at_least() {
  local ref="${1:l}"
  local current="$ROS2_DISTRO"
  [[ -z "$current" ]] && return 1  # unknown distro → false

  # Ordered list of distros (oldest to newest)
  local -a distros=(foxy galactic humble iron jazzy lyrical rolling)
  local ref_idx=-1 current_idx=-1
  local i=1
  for d in "${distros[@]}"; do
    [[ "$d" == "$ref" ]] && ref_idx=$i
    [[ "$d" == "$current" ]] && current_idx=$i
    ((i++))
  done

  # If either not found, treat unknown as "newer"
  [[ $ref_idx -eq -1 ]] && return 0
  [[ $current_idx -eq -1 ]] && return 0

  [[ $current_idx -ge $ref_idx ]]
}

# ---------------------------------------------------------------------------
# 3. Helper: safe source wrapper with missing-file warning
# ---------------------------------------------------------------------------
_ros2_source() {
  local f="$1"
  if [[ -f "$f" ]]; then
    source "$f"
  else
    echo "[ros2-zsh-plugin] Warning: expected file not found: $f" >&2
  fi
}

# ---------------------------------------------------------------------------
# 3.5 Helper: normalize ROS2_ENABLE_* flags
#   Accepts 1/yes/true/on as "on"; anything else (including 0/no/off) as "off".
# ---------------------------------------------------------------------------
_ros2_enable_is_on() {
  local val="${1:-}"
  [[ "$val" == "1" ]] || [[ "${val:l}" == "yes" ]] || [[ "${val:l}" == "true" ]] || [[ "${val:l}" == "on" ]]
}

# ---------------------------------------------------------------------------
# 4. Load functions first (aliases may depend on them)
# ---------------------------------------------------------------------------
_ros2_enable_is_on "$ROS2_ENABLE_ENV"    && _ros2_source "$_ROS2_DIR/functions/workspace.zsh"
_ros2_enable_is_on "$ROS2_ENABLE_UTILS"  && _ros2_source "$_ROS2_DIR/functions/helpers.zsh"

# ---------------------------------------------------------------------------
# 5. Load alias modules
# ---------------------------------------------------------------------------
_ros2_enable_is_on "$ROS2_ENABLE_CORE"      && {
  _ros2_source "$_ROS2_DIR/aliases/topic.zsh"
  _ros2_source "$_ROS2_DIR/aliases/service.zsh"
  _ros2_source "$_ROS2_DIR/aliases/node.zsh"
  _ros2_source "$_ROS2_DIR/aliases/param.zsh"
  _ros2_source "$_ROS2_DIR/aliases/action.zsh"
}

_ros2_enable_is_on "$ROS2_ENABLE_PKG"       && {
  _ros2_source "$_ROS2_DIR/aliases/pkg.zsh"
  _ros2_source "$_ROS2_DIR/aliases/interface.zsh"
}

_ros2_enable_is_on "$ROS2_ENABLE_RUN"       && {
  _ros2_source "$_ROS2_DIR/aliases/run.zsh"
  _ros2_source "$_ROS2_DIR/aliases/launch.zsh"
}

_ros2_enable_is_on "$ROS2_ENABLE_BAG"       && _ros2_source "$_ROS2_DIR/aliases/bag.zsh"
_ros2_enable_is_on "$ROS2_ENABLE_LIFECYCLE" && _ros2_source "$_ROS2_DIR/aliases/lifecycle.zsh"
_ros2_enable_is_on "$ROS2_ENABLE_DAEMON"    && _ros2_source "$_ROS2_DIR/aliases/daemon.zsh"
_ros2_enable_is_on "$ROS2_ENABLE_COLCON"    && _ros2_source "$_ROS2_DIR/aliases/colcon.zsh"
_ros2_enable_is_on "$ROS2_ENABLE_UTILS"     && _ros2_source "$_ROS2_DIR/aliases/utils.zsh"

# Foxy compatibility aliases (loaded only when ROS2_DISTRO=foxy)
_ros2_source "$_ROS2_DIR/aliases/foxy-compat.zsh"

# Jazzy+ compatibility aliases (loaded only when ROS2_DISTRO >= jazzy)
_ros2_source "$_ROS2_DIR/aliases/jazzy-compat.zsh"

# ---------------------------------------------------------------------------
# 6. Load completions if available
# ---------------------------------------------------------------------------
[[ -d "$_ROS2_DIR/completions" ]] && fpath+=("$_ROS2_DIR/completions")

# ---------------------------------------------------------------------------
# 7. Cleanup
# ---------------------------------------------------------------------------
unset -f _ros2_source _ros2_enable_is_on _ros2_distro_at_least

# vim: set ft=zsh:
