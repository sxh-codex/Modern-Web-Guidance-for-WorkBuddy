# 安装指南：国内版 / 国际版 WorkBuddy

本文件说明如何把本仓库里的 `skills/modern-web-guidance/` 安装到 WorkBuddy。整个过程**不需要修改上游源码**，只是复制一份 Skill 目录。

同一套文件同时适用于国内版和国际版 WorkBuddy。两版差异见 [docs/COMPATIBILITY.md](./docs/COMPATIBILITY.md)。

---

## 0. 前置检查

### 0.1 确认 Node.js 版本

WorkBuddy 需要调用 `npx modern-web-guidance@latest`，要求 Node.js 22 或更高版本。

```powershell
node --version
```

期望输出类似：

```text
v22.22.2
```

如果版本低于 22，请先安装 Node.js 22 LTS： <https://nodejs.org/>

### 0.2 确认 CLI 可用

可先在终端单独测试：

```powershell
npx.cmd -y modern-web-guidance@latest search "dialog light dismiss"
```

如果能返回 JSON 结果，说明网络、Node.js 和 npm registry 都正常。

### 0.3 建议先退出 WorkBuddy

安装前建议**完全退出国内版和国际版 WorkBuddy**，避免它们缓存旧的 Skill 列表。

---

## 1. 安装位置

### 1.1 用户级 Skill（推荐，所有项目可用）

| 版本 | 目录 |
|---|---|
| 国内版 | `C:\Users\<用户名>\.workbuddy\skills\modern-web-guidance\` |
| 国际版 | `C:\Users\<用户名>\.workbuddy-ai\skills\modern-web-guidance\` |

当前机器对应：

```text
C:\Users\aiwen\.workbuddy\skills\modern-web-guidance\
C:\Users\aiwen\.workbuddy-ai\skills\modern-web-guidance\
```

### 1.2 项目级 Skill（仅当前项目可用，两版共用）

```text
<项目根目录>\.codebuddy\skills\modern-web-guidance\
```

如果 WorkBuddy 会话中没有启用项目级 Skill，请优先使用用户级安装。

---

## 2. 方式 A：PowerShell 一键安装（推荐 Windows）

在仓库根目录打开 PowerShell。

### 2.1 自动检测本机已安装的版本（默认）

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

当前机器两个版本目录都存在，因此默认会同时装到国内版和国际版。

### 2.2 指定版本

只装国内版：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition Domestic
```

只装国际版：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition International
```

两个用户级目录都装：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition Both
```

### 2.3 项目级安装

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Scope Project
```

脚本会：

1. 检查 `skills/modern-web-guidance/SKILL.md` 是否存在；
2. 根据 `-Edition` 选择目标目录；
3. 如果目标 Skill 已存在，先重命名为 `modern-web-guidance.backup-<时间戳>`；
4. 复制完整 Skill 到每个目标目录；
5. 逐目录验证 `SKILL.md` 是否存在。

---

## 3. 方式 B：Git Bash / macOS / Linux 一键安装

命令格式：

```bash
bash ./scripts/install.sh [user|project] [auto|domestic|international|both]
```

示例：

```bash
# 自动检测
bash ./scripts/install.sh

# 只装国内版
bash ./scripts/install.sh user domestic

# 只装国际版
bash ./scripts/install.sh user international

# 两版都装
bash ./scripts/install.sh user both

# 项目级
bash ./scripts/install.sh project
```

---

## 4. 方式 C：在 WorkBuddy 技能页面上传 ZIP

国内版和国际版都支持 UI 上传，无需脚本。

1. 打开 WorkBuddy 的技能页面：
   - 国内版：左侧栏「专家 · 技能 · 连接器」→「技能」
   - 国际版：Skills
2. 点击「添加技能 / Add skill」→「上传技能 / Upload skill」；
3. 选择本仓库的：

   ```text
   dist/modern-web-guidance.zip
   ```

4. 在技能列表中启用它；
5. 新建会话后使用。

ZIP 内已经包含 `modern-web-guidance/` 文件夹和 `SKILL.md`，不需要解压后再手动改目录名。

---

## 5. 方式 D：手动复制

### 5.1 PowerShell

国内版：

```powershell
$Src = "D:\Codex app\000\002\modern-web-guidance-workbuddy\skills\modern-web-guidance"
$Dst = "$env:USERPROFILE\.workbuddy\skills\modern-web-guidance"

New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
Copy-Item -LiteralPath $Src -Destination $Dst -Recurse -Force

Test-Path "$Dst\SKILL.md"
```

国际版：

```powershell
$Src = "D:\Codex app\000\002\modern-web-guidance-workbuddy\skills\modern-web-guidance"
$Dst = "$env:USERPROFILE\.workbuddy-ai\skills\modern-web-guidance"

New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
Copy-Item -LiteralPath $Src -Destination $Dst -Recurse -Force

Test-Path "$Dst\SKILL.md"
```

最后一行返回 `True` 即复制成功。

### 5.2 Git Bash

国内版：

```bash
SRC="/d/Codex app/000/002/modern-web-guidance-workbuddy/skills/modern-web-guidance"
DEST="$HOME/.workbuddy/skills/modern-web-guidance"

mkdir -p "$(dirname "$DEST")"
cp -R "$SRC" "$DEST"
test -f "$DEST/SKILL.md" && echo "OK"
```

国际版：

```bash
SRC="/d/Codex app/000/002/modern-web-guidance-workbuddy/skills/modern-web-guidance"
DEST="$HOME/.workbuddy-ai/skills/modern-web-guidance"

mkdir -p "$(dirname "$DEST")"
cp -R "$SRC" "$DEST"
test -f "$DEST/SKILL.md" && echo "OK"
```

---

## 6. 启动 WorkBuddy 并放行命令

1. 重新启动对应的 WorkBuddy 版本。
2. 新建一个会话。
3. 如果 WorkBuddy 询问是否允许执行终端命令，请允许以下前缀：

```text
npx -y modern-web-guidance@latest
```

Windows 下也可能是：

```text
npx.cmd -y modern-web-guidance@latest
```

不要放行宽泛的 `npx *` 或 `npx.cmd *`，按最小权限放行即可。

---

## 7. 验证安装

### 7.1 终端验证

Windows：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1 -Edition Both
```

Git Bash：

```bash
bash ./scripts/verify.sh user both
```

脚本会检查：

- 目标 Skill 目录是否存在；
- `SKILL.md` 的 `name` 是否为 `modern-web-guidance`；
- `agent_created: true` 是否存在；
- 210 个指南文件是否完整；
- Node.js 是否可用；
- `modern-web-guidance search` 是否能正常返回。

### 7.2 WorkBuddy 内验证

新建会话后输入：

```text
帮我实现一个点击遮罩或按 Esc 都能关闭的 dialog，请用现代 Web 指南确认做法。
```

正常情况：

- WorkBuddy 会调用 `modern-web-guidance search "light dismiss dialog"` 之类的命令；
- 回答末尾会出现 `### Modern Web Guidance` 段落；
- 代码会优先使用 `<dialog closedby="any">` 等现代平台能力。

如果触发不明显，可以直接说：

```text
请先用 modern-web-guidance 检索 dialog light dismiss 指南，再写代码。
```

---

## 8. 更新

CLI 命令使用 `@latest`，所以指南检索能力会随 npm 包自动更新。

若要更新本地 Skill 元数据与随包指南：

1. 拉取上游发布仓库最新内容；
2. 用新的 `skills/modern-web-guidance/` 覆盖本仓库同名目录；
3. 重新生成 `dist/modern-web-guidance.zip`；
4. 重新执行安装脚本或重新上传 ZIP；
5. 重启 WorkBuddy。

上游仓库：

```text
https://github.com/GoogleChrome/modern-web-guidance
```

---

## 9. 卸载

### 9.1 国内版用户级

```powershell
Remove-Item -LiteralPath "$env:USERPROFILE\.workbuddy\skills\modern-web-guidance" -Recurse -Force
```

### 9.2 国际版用户级

```powershell
Remove-Item -LiteralPath "$env:USERPROFILE\.workbuddy-ai\skills\modern-web-guidance" -Recurse -Force
```

### 9.3 项目级

删除项目中的：

```text
.codebuddy\skills\modern-web-guidance\
```

卸载后重启对应 WorkBuddy 版本。

---

## 10. 重要说明

- 本仓库安装的是发布产物 `skills/modern-web-guidance/`。
- 不要安装 `modern-web-guidance-src-main/.agents/skills/`；那些是维护源码仓库用的工作流技能，不是面向前端开发任务的运行时指南。
- Skill 本体只负责告诉 WorkBuddy 何时、如何检索指南；实际检索通过 `npx modern-web-guidance@latest` 完成，因此首次使用需要联网。
- 国内版和国际版的用户级 Skill 目录互相独立，装了一版不代表另一版自动可用。
- 常见问题见 [docs/TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)。
