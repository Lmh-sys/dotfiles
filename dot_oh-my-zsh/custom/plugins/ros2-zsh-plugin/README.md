# ros2-zsh-plugin

[![CI](https://github.com/leelong2020/ros2-zsh-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/leelong2020/ros2-zsh-plugin/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ROS2](https://img.shields.io/badge/ROS2-Humble%20|%20Jazzy%20|%20Lyrical%20|%20Rolling-blue)](https://docs.ros.org/)

> 为 ROS 2 开发者打造的 Oh My Zsh 插件，用 2-4 个字符的短别名替代冗长的 `ros2 topic list` 命令。

[简体中文](README.md) | [English](README.en.md)

## 功能亮点

- **模块化加载**：按 topic/service/node/bag/colcon 等子系统按需启用
- **安全默认**：不启用任何破坏性别名（如自动删除 bag、kill 全部节点）
- **Function 增强**：带参数的智能命令（自动 source 工作区、bag 录制、带 `--ros-args` 的运行）
- **环境变量开关**：通过 `ROS2_ENABLE_*` 控制各模块，零配置即可用
- **完整测试**：CI 覆盖语法检查、加载测试、别名展开验证
- **多版本兼容**：自动适配 ROS 2 Foxy / Humble / Jazzy / Lyrical / Rolling（见下方说明）

## ROS 2 发行版兼容性

本插件会自动检测 `ROS_DISTRO` 环境变量并适配对应的 CLI 语法。
表中 **Jazzy+** 表示 Jazzy、Lyrical、Rolling 及更新版本。表中功能在这些版本上均可用。

| 功能 | Foxy | Humble/Iron | Jazzy+ |
|:---|:---|:---|:---|
| `ros2 topic bw` | ❌ 不存在 | ✅ `rtbw` | ✅ `rtbw` |
| `ros2 topic delay` | ❌ 不存在 | ✅ `rtd` | ✅ `rtd` |
| `ros2 topic info --verbose` | ❌ 不存在 | ❌ 不存在 | ✅ `rtiv` |
| `ros2 action call` | ❌ 使用 `send_goal` | ✅ `rac` | ✅ `rac` |
| `ros2 interface packages` | ❌ 不存在 | ✅ `rifp` | ✅ `rifp` |
| `ros2 interface package` | ❌ 不存在 | ✅ `rifpp` | ✅ `rifpp` |
| `ros2 interface proto` | ❌ 不存在 | ✅ `rifproto` | ✅ `rifproto` |
| `ros2 run --list` | ❌ 不存在 | ✅ `rrl` | ✅ `rrl` |
| `ros2 run --log-file-name` | ❌ 不存在 | ❌ 不存在 | ✅ `rrln` |
| `ros2 doctor --report` | ❌ 可能不支持 | ✅ `rdoce` | ✅ `rdoce` |
| `ros2 service echo` | ❌ 不存在 | ❌ 不存在 | ✅ `rse` / `rsef` |
| `ros2 bag record --service` | ❌ 不存在 | ❌ 不存在 | ✅ `rbsr` / `rbsa` |
| `ros2 bag play --publish-service-requests` | ❌ 不存在 | ❌ 不存在 | ✅ `rbps` |

**手动指定发行版：**
```zsh
# 在 ~/.zshrc 中，plugins 声明之前设置
export ROS2_DISTRO=foxy   # 强制使用 Foxy 兼容模式
plugins=(... ros2-zsh-plugin)
```

如果未设置，插件会自动读取 `ROS_DISTRO` 环境变量。

## 安装方式

### Oh My Zsh（推荐）

```bash
git clone https://github.com/leelong2020/ros2-zsh-plugin.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/ros2-zsh-plugin
```

在 `~/.zshrc` 中启用：

```zsh
plugins=(... ros2-zsh-plugin)
```

### 手动安装

```bash
git clone https://github.com/leelong2020/ros2-zsh-plugin.git ~/.ros2-zsh-plugin
echo "source ~/.ros2-zsh-plugin/ros2-zsh-plugin.plugin.zsh" >> ~/.zshrc
```

## 目录说明

```
ros2-zsh-plugin/
├── ros2-zsh-plugin.plugin.zsh   # 主入口：加载函数、别名、补全
├── aliases/                     # 别名模块（按子系统拆分）
│   ├── topic.zsh               # rt* 前缀
│   ├── service.zsh             # rs* 前缀
│   ├── node.zsh                # rn* 前缀
│   ├── param.zsh               # rp* 前缀
│   ├── action.zsh              # ra* 前缀
│   ├── pkg.zsh                 # rpkg* 前缀
│   ├── interface.zsh           # rif* 前缀
│   ├── run.zsh                 # rr* 前缀
│   ├── launch.zsh              # rl* 前缀
│   ├── bag.zsh                 # rb* 前缀
│   ├── lifecycle.zsh           # rlc* 前缀（默认关闭）
│   ├── daemon.zsh              # rd* 前缀（默认关闭）
│   ├── colcon.zsh              # cb* 前缀
│   ├── utils.zsh               # ru* 前缀
│   ├── foxy-compat.zsh         # Foxy 兼容回退别名
│   └── jazzy-compat.zsh        # Jazzy+ 新特性别名
├── functions/                   # 函数模块
│   ├── workspace.zsh           # rsource, rcd, rbuild
│   └── helpers.zsh             # rte, rthz, rrun, rbag, rbagplay, rkill
├── completions/                 # 补全脚本（预留）
├── tests/                       # 测试套件
│   ├── test_load.zsh
│   ├── test_aliases.zsh
│   ├── test_functions.zsh
│   ├── test_foxy_compat.zsh
│   ├── test_jazzy_compat.zsh
│   ├── test_edge_cases.zsh
│   └── test_security.zsh
├── examples/                    # 使用示例
├── .github/workflows/ci.yml     # GitHub Actions CI
├── CHANGELOG.md
├── LICENSE
├── README.en.md                 # 英文文档
└── README.md                    # 本文档
```

## Alias 速查表

### Core（默认启用）

| 别名 | 完整命令 | 说明 |
|:---|:---|:---|
| `rtl` | `ros2 topic list` | 列出所有 topic |
| `rtlt` | `ros2 topic list -t` | 列出 topic 及其类型 |
| `rte` | `ros2 topic echo` | 监听 topic |
| `rth` | `ros2 topic hz` | 测量 topic 发布频率 |
| `rti` | `ros2 topic info` | 查看 topic 信息 |
| `rsl` | `ros2 service list` | 列出所有 service |
| `rsc` | `ros2 service call` | 调用 service |
| `rnl` | `ros2 node list` | 列出所有节点 |
| `rni` | `ros2 node info` | 查看节点信息 |
| `rpl` | `ros2 param list` | 列出节点参数 |
| `rpg` | `ros2 param get` | 获取参数值 |
| `rps` | `ros2 param set` | 设置参数值 |
| `ral` | `ros2 action list` | 列出所有 action |
| `rac` | `ros2 action call` | 调用 action |

### Package & Interface

| 别名 | 完整命令 |
|:---|:---|
| `rpkgl` | `ros2 pkg list` |
| `rpkgp` | `ros2 pkg prefix` |
| `rpkgx` | `ros2 pkg xml` |
| `rifl` | `ros2 interface list` |
| `rifs` | `ros2 interface show` |

### Run & Launch

| 别名 | 完整命令 |
|:---|:---|
| `rr` | `ros2 run` |
| `rl` | `ros2 launch` |

### Bag（安全只读默认）

| 别名 | 完整命令 |
|:---|:---|
| `rbi` | `ros2 bag info` |
| `rbp` | `ros2 bag play` |

### Colcon

| 别名 | 完整命令 |
|:---|:---|
| `cb` | `colcon build` |
| `cbs` | `colcon build --symlink-install` |
| `cbt` | `colcon test` |
| `cbtr` | `colcon test-result` |
| `cbp` | `colcon build --packages-select` |
| `cbup` | `colcon build --packages-up-to` |

### Utility

| 别名 | 完整命令 |
|:---|:---|
| `rdoc` | `ros2 doctor` |
| `rver` | `ros2 --version` |

## Function 用法示例

### rsource — 自动 source 工作区

```bash
# 自动向上查找 install/setup.zsh
$ rsource
[ros2] Sourcing /home/user/ws/install/setup.zsh ...

# 指定路径
$ rsource /opt/ros/humble/setup.zsh
```

### rcd — 进入工作区根目录

```bash
# 自动向上查找 src/ 或 install/ 目录
$ rcd
[ros2] Entered workspace: /home/user/ros2_ws

# 指定名称（搜索 ~/ 或绝对路径）
$ rcd my_ws
```

### rbuild — 智能构建

```bash
# 全量构建
$ rbuild

# 构建到指定包（含依赖）
$ rbuild my_package another_pkg
```

### rrun — 带参数运行

```bash
# 自动识别 key:=value 并添加 --ros-args -p
$ rrun my_pkg my_node rate:=10.0 debug:=true
[ros2] ros2 run my_pkg my_node --ros-args -p rate:=10.0 -p debug:=true
```

### rbag — 安全录制

```bash
# 录制指定 topic 到 ~/ros2_bags/bag_YYYYMMDD_HHMMSS
$ rbag /cmd_vel /odom

# 指定输出路径
$ rbag -o /data/exp1 /scan
```

### rbagplay — 回放

```bash
# 正常回放
$ rbagplay ~/ros2_bags/bag_20260101_120000

# 0.5倍速循环
$ rbagplay ~/ros2_bags/bag_20260101_120000 0.5 --loop
```

### rkill — 安全杀节点

```bash
# 按名称模式匹配，确认后才 kill
$ rkill /teleop_twist_keyboard
[ros2] Matched nodes:
  /teleop_twist_keyboard
Kill these nodes? [y/N] y
```

> `rkill` 使用**精确匹配**，必须输入完整节点名。如需查找节点，先用 `rnl` 或 `ros2 node list | grep <pattern>`。


## 自定义配置

在 `~/.zshrc` 中，**在 plugins 声明之前**设置环境变量：

```zsh
# 禁用 bag 和 lifecycle 别名
export ROS2_ENABLE_BAG=0
export ROS2_ENABLE_LIFECYCLE=0

plugins=(git ros2-zsh-plugin)
```

### 可用开关

| 变量 | 默认 | 说明 |
|:---|:---|:---|
| `ROS2_ENABLE_CORE` | `1` | topic/service/node/param/action |
| `ROS2_ENABLE_PKG` | `1` | pkg/interface |
| `ROS2_ENABLE_RUN` | `1` | run/launch |
| `ROS2_ENABLE_BAG` | `1` | bag（只读别名） |
| `ROS2_ENABLE_COLCON` | `1` | colcon |
| `ROS2_ENABLE_ENV` | `1` | workspace 函数 |
| `ROS2_ENABLE_UTILS` | `1` | doctor 等 |
| `ROS2_ENABLE_LIFECYCLE` | `0` | lifecycle（较少用） |
| `ROS2_ENABLE_DAEMON` | `0` | daemon（较少用） |

## 别名命名规范

- **统一前缀**：所有别名以 `r` 开头，第二个字母表示子系统
  - `rt` = ros2 **t**opic, `rs` = ros2 **s**ervice, `rn` = ros2 **n**ode
  - `rp` = ros2 **p**aram, `ra` = ros2 **a**ction, `rr` = ros2 **r**un
  - `rl` = ros2 **l**aunch, `rb` = ros2 **b**ag, `rd` = ros2 **d**octor
  - `cb` = **c**olcon **b**uild
- **第三字母**：动词首字母
  - `l` = list, `e` = echo, `h` = hz, `i` = info, `c` = call
- **避免冲突**：不占用常见 shell 别名（如 `ll`, `la`, `gs`, `gp` 等）
- **已知例外**：`rd` 同时用于 `ros2 doctor`（`rdoc`）和 `ros2 daemon`（`rdstart` 等）。由于 `daemon` 模块默认关闭，通常不会冲突。未来计划将 doctor 迁移到 `rdr*` 前缀。

## 已知限制

- 需要 Zsh 和 Oh My Zsh 环境
- 部分 function 依赖 `ros2` CLI 已安装且环境已 source
- `rkill` 使用 `pgrep` 匹配，可能误杀相似进程名
- 当前补全目录为空，计划未来接入 `ros2cli` 原生补全

## 路线图

- [ ] 接入 `ros2cli` 原生补全
- [ ] 支持 ROS 2 Galactic / Foxy 兼容层
- [ ] 增加 `ros2 param` 的批量 dump/load function
- [ ] 增加 `ros2 service` 的自动类型推断 call function
- [ ] 增加更多 colcon 别名（test-only, build-and-test）
- [ ] 提供 Homebrew / AUR 包
- [ ] 将 `ros2 doctor` 别名从 `rd*` 迁移到 `rdr*`，避免与 `ros2 daemon` 冲突

## 贡献指南

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'Add amazing feature'`
4. 推送分支：`git push origin feature/amazing-feature`
5. 提交 Pull Request

请确保：
- 通过 `zsh tests/test_load.zsh` 和 `zsh tests/test_aliases.zsh`
- 新增别名遵循命名规范
- 不添加破坏性默认别名

## License

[MIT](LICENSE) © 2026 LoongLee
