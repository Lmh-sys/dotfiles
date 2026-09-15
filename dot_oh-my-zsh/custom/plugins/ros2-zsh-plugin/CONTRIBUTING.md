# 贡献指南

感谢你对 ros2-zsh-plugin 的关注！

## 快速开始

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'feat(scope): 添加某个功能'`
4. 推送分支：`git push origin feature/amazing-feature`
5. 提交 Pull Request

## 开发环境

```bash
# 克隆你的 fork
git clone https://github.com/<your-username>/ros2-zsh-plugin.git
cd ros2-zsh-plugin

# 本地测试
zsh tests/test_load.zsh
zsh tests/test_aliases.zsh
```

## 命名规范

### 别名命名

所有别名以 `r` 开头，第二个字母表示子系统：

| 前缀 | 子系统 |
|---|---|
| `rt` | ros2 topic |
| `rs` | ros2 service |
| `rn` | ros2 node |
| `rp` | ros2 param |
| `ra` | ros2 action |
| `rr` | ros2 run |
| `rl` | ros2 launch |
| `rb` | ros2 bag |
| `rd` | ros2 doctor / daemon |
| `cb` | colcon |

第三字母为动词首字母（l=list, e=echo, h=hz, i=info, c=call）。

### Commit 规范

采用 [Conventional Commits](https://www.conventionalcommits.org/) 格式，**使用中文撰写**：

```
<type>(<scope>): <简短描述>

<详细说明，可选>
```

类型（type）：
- `feat`：新功能
- `fix`：修复 bug
- `refactor`：重构
- `docs`：文档
- `test`：测试
- `ci`：CI 配置

示例：
- `feat(topic): 添加 topic echo 类型自动检测`
- `fix(kill): 修复 macOS 下进程检测兼容问题`
- `docs(readme): 更新安装说明`

## 测试要求

所有贡献必须通过现有测试：

```bash
# 运行全部测试
for f in tests/*.zsh; do zsh "$f"; done

# 单独测试
zsh tests/test_load.zsh      # 语法检查和加载测试
zsh tests/test_aliases.zsh   # 别名展开测试
zsh tests/test_functions.zsh # 函数存在性测试
```

## 安全原则

- **不启用破坏性别名**：默认不定义会自动删除 bag、kill 全部节点等操作的别名
- **输入校验**：函数必须对参数进行合法性校验
- **路径安全**：避免路径穿越风险

## 提交 PR 前检查

- [ ] 通过所有测试
- [ ] 新增别名遵循命名规范
- [ ] 不添加破坏性默认别名
- [ ] 更新 README（如适用）
- [ ] CHANGELOG.md 记录变更（如适用）

## 问题反馈

- 提交 Issue：https://github.com/leelong2020/ros2-zsh-plugin/issues
- 邮件联系：（请在 GitHub 上联系）

## License

提交贡献即表示你同意将代码以 MIT 协议开源。
