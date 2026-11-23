# 国内版 / 国际版 WorkBuddy 兼容性

## 结论

同一份 Skill 文件**国内版和国际版都适用**，不需要为两版分别制作不同的 Skill。两版都读取开放标准的 `SKILL.md` 文件夹，只是用户级 Skill 根目录不同。

## 差异对照

| 项目 | 国内版 WorkBuddy | 国际版 WorkBuddy |
|---|---|---|
| Skill 格式 | `SKILL.md` 文件夹 | `SKILL.md` 文件夹 |
| 用户级 Skill 目录 | `~/.workbuddy/skills/` | `~/.workbuddy-ai/skills/` |
| 项目级 Skill 目录 | `<项目>/.codebuddy/skills/` | `<项目>/.codebuddy/skills/` |
| UI 上传技能 | 技能页 → 添加技能 → 上传技能 | Skills → Add skill → Upload skill |
| 本仓库 ZIP | `dist/modern-web-guidance.zip` | 同一个 ZIP |
| 触发方式 | 按 `description` 自动触发 | 按 `description` 自动触发 |
| 外部命令 | `npx -y modern-web-guidance@latest` | 同左 |
| Node 版本要求 | `>= 22` | `>= 22` |

## 本仓库如何处理差异

`install.ps1` / `install.sh` / `verify.ps1` / `verify.sh` 都支持 `-Edition` / 第二个参数：

- `auto`（默认）：检测本机存在哪个目录；两个都存在就装两个
- `domestic`：只装 `~/.workbuddy/skills/`
- `international`：只装 `~/.workbuddy-ai/skills/`
- `both`：两个用户级目录都装

当前机器上两个目录都存在：

```text
C:\Users\aiwen\.workbuddy
C:\Users\aiwen\.workbuddy-ai
```

因此默认 `Auto` 会同时安装到两版目录，验证脚本也会同时检查两处。

## 为什么项目级目录不是 `.workbuddy/skills`

WorkBuddy 的项目级配置与 CodeBuddy Code 同源，官方推荐使用：

```text
<项目根目录>\.codebuddy\skills\
```

本仓库的 `-Scope Project` 已按这个路径安装，国内版和国际版一致。

## 网络差异

Skill 本体不联网，但它会指示 WorkBuddy 调用：

```text
npx -y modern-web-guidance@latest search/retrieve
```

国内网络若访问默认 npm registry 不稳定，可先配置可达的 npm registry 镜像；Skill 内容和调用命令不变。CLI 首次下载后可在缓存基础上使用 `npx --offline`。

## 需要注意

- 两版的用户级 Skill 是分开存储的；装了国内版不代表国际版自动可用。
- 使用 `-Edition Both` 或 UI 上传两次，可让两版都启用。
- 如果只在一版中看到技能，先确认装到了对应目录，再完全退出并重启该版本 WorkBuddy。
- 同一 Skill 名称在两版中同时存在不会冲突，因为它们位于不同数据目录。
