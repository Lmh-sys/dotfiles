# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-07-22

### Added
- ROS 2 Lyrical distribution support (inherits Jazzy+ compatibility aliases)
- Lyrical compatibility test in CI workflow

### Fixed
- Security test: gracefully skip `rsource` ownership check when sudo/nobody is unavailable in restricted CI environments

### Changed
- Updated Chinese and English README to document Lyrical support
- Synchronized repository links to `https://github.com/leelong2020/ros2-zsh-plugin`

## [0.1.0] - 2026-06-07

### Added
- Initial release with modular alias system
- Core aliases: topic, service, node, param, action
- Package aliases: pkg, interface
- Run/launch aliases
- Bag aliases (safe read-only defaults)
- Colcon build aliases
- Workspace functions: rsource, rcd, rbuild
- Helper functions: rte, rthz, rrun, rbag, rbagplay, rkill
- Environment variable toggles for all modules
- CI workflow with GitHub Actions
- Comprehensive test suite

[Unreleased]: https://github.com/leelong2020/ros2-zsh-plugin/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/leelong2020/ros2-zsh-plugin/releases/tag/v0.2.0
[0.1.0]: https://github.com/leelong2020/ros2-zsh-plugin/releases/tag/v0.1.0
