# ros2-zsh-plugin

[![CI](https://github.com/leelong2020/ros2-zsh-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/leelong2020/ros2-zsh-plugin/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ROS2](https://img.shields.io/badge/ROS2-Humble%20|%20Jazzy%20|%20Lyrical%20|%20Rolling-blue)](https://docs.ros.org/)

> An Oh My Zsh plugin for ROS 2 developers. Replace lengthy commands like `ros2 topic list` with 2-4 character short aliases.

[简体中文](README.md) | English

## Features

- **Modular Loading**: Enable aliases by subsystem — topic/service/node/bag/colcon, etc.
- **Safe Defaults**: No destructive aliases enabled by default (e.g., auto-delete bag, kill all nodes).
- **Smart Functions**: Parameter-aware commands (auto-source workspace, bag recording, run with `--ros-args`).
- **Environment Switches**: Control each module via `ROS2_ENABLE_*` variables — zero configuration required.
- **Full Test Coverage**: CI covers syntax checks, load tests, and alias expansion validation.
- **Multi-Distro Support**: Auto-adapts to ROS 2 Foxy / Humble / Jazzy / Lyrical / Rolling (see below).

## ROS 2 Distribution Compatibility

This plugin automatically detects the `ROS_DISTRO` environment variable and adapts CLI syntax accordingly.
In the table below, **Jazzy+** means Jazzy, Lyrical, Rolling, and newer distributions.

| Feature | Foxy | Humble/Iron | Jazzy+ |
|:---|:---|:---|:---|
| `ros2 topic bw` | ❌ Not available | ✅ `rtbw` | ✅ `rtbw` |
| `ros2 topic delay` | ❌ Not available | ✅ `rtd` | ✅ `rtd` |
| `ros2 topic info --verbose` | ❌ Not available | ❌ Not available | ✅ `rtiv` |
| `ros2 action call` | ❌ Uses `send_goal` | ✅ `rac` | ✅ `rac` |
| `ros2 interface packages` | ❌ Not available | ✅ `rifp` | ✅ `rifp` |
| `ros2 interface package` | ❌ Not available | ✅ `rifpp` | ✅ `rifpp` |
| `ros2 interface proto` | ❌ Not available | ✅ `rifproto` | ✅ `rifproto` |
| `ros2 run --list` | ❌ Not available | ✅ `rrl` | ✅ `rrl` |
| `ros2 run --log-file-name` | ❌ Not available | ❌ Not available | ✅ `rrln` |
| `ros2 doctor --report` | ❌ May not support | ✅ `rdoce` | ✅ `rdoce` |
| `ros2 service echo` | ❌ Not available | ❌ Not available | ✅ `rse` / `rsef` |
| `ros2 bag record --service` | ❌ Not available | ❌ Not available | ✅ `rbsr` / `rbsa` |
| `ros2 bag play --publish-service-requests` | ❌ Not available | ❌ Not available | ✅ `rbps` |

**Manually specify distribution:**
```zsh
# In ~/.zshrc, BEFORE the plugins declaration
export ROS2_DISTRO=foxy   # Force Foxy compatibility mode
plugins=(... ros2-zsh-plugin)
```

If unset, the plugin automatically reads the `ROS_DISTRO` environment variable.

## Installation

### Oh My Zsh (Recommended)

```bash
git clone https://github.com/leelong2020/ros2-zsh-plugin.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ros2-zsh-plugin
```

Enable in `~/.zshrc`:

```zsh
plugins=(... ros2-zsh-plugin)
```

### Manual Installation

```bash
git clone https://github.com/leelong2020/ros2-zsh-plugin.git ~/.ros2-zsh-plugin
echo "source ~/.ros2-zsh-plugin/ros2-zsh-plugin.plugin.zsh" >> ~/.zshrc
```

## Directory Structure

```
ros2-zsh-plugin/
├── ros2-zsh-plugin.plugin.zsh          # Main entry: loads functions, aliases, completions
├── aliases/                 # Alias modules (split by subsystem)
│   ├── topic.zsh            # rt* prefix
│   ├── service.zsh          # rs* prefix
│   ├── node.zsh             # rn* prefix
│   ├── param.zsh            # rp* prefix
│   ├── action.zsh           # ra* prefix
│   ├── pkg.zsh              # rpkg* prefix
│   ├── interface.zsh        # rif* prefix
│   ├── run.zsh              # rr* prefix
│   ├── launch.zsh           # rl* prefix
│   ├── bag.zsh              # rb* prefix
│   ├── lifecycle.zsh        # rlc* prefix (disabled by default)
│   ├── daemon.zsh           # rd* prefix (disabled by default)
│   ├── colcon.zsh           # cb* prefix
│   ├── utils.zsh            # ru* prefix
│   ├── foxy-compat.zsh      # Foxy compatibility fallbacks
│   └── jazzy-compat.zsh     # Jazzy+ new feature aliases
├── functions/               # Function modules
│   ├── workspace.zsh        # rsource, rcd, rbuild
│   └── helpers.zsh          # rte, rthz, rrun, rbag, rbagplay, rkill
├── completions/             # Completion scripts (reserved)
├── tests/                   # Test suite
│   ├── test_load.zsh
│   ├── test_aliases.zsh
│   ├── test_functions.zsh
│   ├── test_foxy_compat.zsh
│   ├── test_jazzy_compat.zsh
│   ├── test_edge_cases.zsh
│   └── test_security.zsh
├── examples/                # Usage examples
├── .github/workflows/ci.yml # GitHub Actions CI
├── CHANGELOG.md
├── LICENSE
├── README.md                # Chinese version
└── README.en.md             # This file
```

## Alias Cheat Sheet

### Core (Enabled by Default)

| Alias | Full Command | Description |
|:---|:---|:---|
| `rtl` | `ros2 topic list` | List all topics |
| `rtlt` | `ros2 topic list -t` | List topics with types |
| `rte` | `ros2 topic echo` | Echo topic messages |
| `rth` | `ros2 topic hz` | Measure topic publish rate |
| `rti` | `ros2 topic info` | Show topic info |
| `rsl` | `ros2 service list` | List all services |
| `rsc` | `ros2 service call` | Call a service |
| `rnl` | `ros2 node list` | List all nodes |
| `rni` | `ros2 node info` | Show node info |
| `rpl` | `ros2 param list` | List node parameters |
| `rpg` | `ros2 param get` | Get parameter value |
| `rps` | `ros2 param set` | Set parameter value |
| `ral` | `ros2 action list` | List all actions |
| `rac` | `ros2 action call` | Call an action |

### Package & Interface

| Alias | Full Command |
|:---|:---|
| `rpkgl` | `ros2 pkg list` |
| `rpkgp` | `ros2 pkg prefix` |
| `rpkgx` | `ros2 pkg xml` |
| `rifl` | `ros2 interface list` |
| `rifs` | `ros2 interface show` |

### Run & Launch

| Alias | Full Command |
|:---|:---|
| `rr` | `ros2 run` |
| `rl` | `ros2 launch` |

### Bag (Read-Only by Default)

| Alias | Full Command |
|:---|:---|
| `rbi` | `ros2 bag info` |
| `rbp` | `ros2 bag play` |

### Colcon

| Alias | Full Command |
|:---|:---|
| `cb` | `colcon build` |
| `cbs` | `colcon build --symlink-install` |
| `cbt` | `colcon test` |
| `cbtr` | `colcon test-result` |
| `cbp` | `colcon build --packages-select` |
| `cbup` | `colcon build --packages-up-to` |

### Utility

| Alias | Full Command |
|:---|:---|
| `rdoc` | `ros2 doctor` |
| `rver` | `ros2 --version` |

## Function Usage Examples

### rsource — Auto-Source Workspace

```bash
# Automatically find install/setup.zsh upward
$ rsource
[ros2] Sourcing /home/user/ws/install/setup.zsh ...

# Specify path explicitly
$ rsource /opt/ros/humble/setup.zsh
```

### rcd — Enter Workspace Root

```bash
# Automatically find src/ or install/ directory upward
$ rcd
[ros2] Entered workspace: /home/user/ros2_ws

# Specify name (searches ~/ or absolute path)
$ rcd my_ws
```

### rbuild — Smart Build

```bash
# Full workspace build
$ rbuild

# Build up to specified packages (with dependencies)
$ rbuild my_package another_pkg
```

### rrun — Run with Parameters

```bash
# Auto-detect key:=value and add --ros-args -p
$ rrun my_pkg my_node rate:=10.0 debug:=true
[ros2] ros2 run my_pkg my_node --ros-args -p rate:=10.0 -p debug:=true
```

### rbag — Safe Recording

```bash
# Record specified topics to ~/ros2_bags/bag_YYYYMMDD_HHMMSS
$ rbag /cmd_vel /odom

# Specify output path
$ rbag -o /data/exp1 /scan
```

### rbagplay — Playback

```bash
# Normal playback
$ rbagplay ~/ros2_bags/bag_20260101_120000

# 0.5x speed with loop
$ rbagplay ~/ros2_bags/bag_20260101_120000 0.5 --loop
```

### rkill — Safe Node Killing

```bash
# Match by name pattern, confirm before killing
$ rkill /teleop_twist_keyboard
[ros2] Matched nodes:
  /teleop_twist_keyboard
Kill these nodes? [y/N] y
```

> `rkill` uses **exact matching**; you must provide the full node name. To find nodes, use `rnl` or `ros2 node list | grep <pattern>` first.


## Customization

In `~/.zshrc`, set environment variables **before** the plugins declaration:

```zsh
# Disable bag and lifecycle aliases
export ROS2_ENABLE_BAG=0
export ROS2_ENABLE_LIFECYCLE=0

plugins=(git ros2-zsh-plugin)
```

### Available Switches

| Variable | Default | Description |
|:---|:---|:---|
| `ROS2_ENABLE_CORE` | `1` | topic/service/node/param/action |
| `ROS2_ENABLE_PKG` | `1` | pkg/interface |
| `ROS2_ENABLE_RUN` | `1` | run/launch |
| `ROS2_ENABLE_BAG` | `1` | bag (read-only aliases) |
| `ROS2_ENABLE_COLCON` | `1` | colcon |
| `ROS2_ENABLE_ENV` | `1` | workspace functions |
| `ROS2_ENABLE_UTILS` | `1` | doctor, etc. |
| `ROS2_ENABLE_LIFECYCLE` | `0` | lifecycle (rarely used) |
| `ROS2_ENABLE_DAEMON` | `0` | daemon (rarely used) |

## Alias Naming Convention

- **Unified Prefix**: All aliases start with `r`; the second letter indicates the subsystem.
  - `rt` = ros2 **t**opic, `rs` = ros2 **s**ervice, `rn` = ros2 **n**ode
  - `rp` = ros2 **p**aram, `ra` = ros2 **a**ction, `rr` = ros2 **r**un
  - `rl` = ros2 **l**aunch, `rb` = ros2 **b**ag, `rd` = ros2 **d**octor
  - `cb` = **c**olcon **b**uild
- **Third Letter**: First letter of the verb.
  - `l` = list, `e` = echo, `h` = hz, `i` = info, `c` = call
- **Avoid Conflicts**: Does not occupy common shell aliases (e.g., `ll`, `la`, `gs`, `gp`).
- **Known Exception**: `rd` is used for both `ros2 doctor` (`rdoc`) and `ros2 daemon` (`rdstart`, etc.). Since the `daemon` module is disabled by default, conflicts are unlikely. Future plan: migrate doctor aliases to the `rdr*` prefix.

## Known Limitations

- Requires Zsh and Oh My Zsh environment.
- Some functions depend on `ros2` CLI being installed and the environment being sourced.
- `rkill` uses `pgrep` for matching, which may accidentally kill processes with similar names.
- The completions directory is currently empty; native `ros2cli` completion integration is planned.

## Roadmap

- [ ] Integrate native `ros2cli` completions
- [ ] Add ROS 2 Galactic / Foxy compatibility layer
- [ ] Add batch param dump/load functions for `ros2 param`
- [ ] Add auto type-inference call function for `ros2 service`
- [ ] Add more colcon aliases (test-only, build-and-test)
- [ ] Provide Homebrew / AUR packages
- [ ] Migrate `ros2 doctor` aliases from `rd*` to `rdr*` to avoid conflict with `ros2 daemon`

## Contributing

1. Fork this repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

Please ensure:
- Pass `zsh tests/test_load.zsh` and `zsh tests/test_aliases.zsh`
- New aliases follow the naming convention
- No destructive aliases are added by default

## License

[MIT](LICENSE) © 2026 LoongLee
