# 常见问题排查

## 1. WorkBuddy 里看不到 `modern-web-guidance`

先确认装到了对应版本的目录：

| 版本 | 检查命令 |
|---|---|
| 国内版 | `Test-Path "$env:USERPROFILE\.workbuddy\skills\modern-web-guidance\SKILL.md"` |
| 国际版 | `Test-Path "$env:USERPROFILE\.workbuddy-ai\skills\modern-web-guidance\SKILL.md"` |
| 项目级 | `Test-Path ".\.codebuddy\skills\modern-web-guidance\SKILL.md"` |

然后按顺序检查：

1. `SKILL.md` 前几行是否包含：

   ```yaml
   name: modern-web-guidance
   agent_created: true
   ```

2. 是否**完全退出并重新打开**对应版本的 WorkBuddy，而不是只关闭会话窗口。
3. 是否新建了会话；旧会话可能不会重新加载 Skill 列表。
4. 如果在 WorkBuddy 技能页面中上传了 ZIP，确认技能已启用。
5. 如果仍然不显示，退出 WorkBuddy 后删除对应版本的 Skill 缓存再启动：

   ```powershell
   # 国内版
   Remove-Item -LiteralPath "$env:USERPROFILE\.workbuddy\.skill-list-cache.json" -Force -ErrorAction SilentlyContinue

   # 国际版
   Remove-Item -LiteralPath "$env:USERPROFILE\.workbuddy-ai\.skill-list-cache.json" -Force -ErrorAction SilentlyContinue
   ```

   删除缓存不会删除 Skill 本体，WorkBuddy 会自动重建。

---

## 2. 国内版能看到，国际版看不到（或相反）

这是正常的：两版用户级 Skill 目录互相独立。执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition Both
```

或分别执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition Domestic
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition International
```

然后分别重启两版 WorkBuddy。

---

## 3. 终端能运行，但 WorkBuddy 不调用 CLI

通常是终端权限没有放行。WorkBuddy 弹出命令确认时，请允许以下精确前缀：

```text
npx -y modern-web-guidance@latest
```

Windows 下可能是：

```text
npx.cmd -y modern-web-guidance@latest
```

如果 WorkBuddy 只是一般性地回答前端问题而没有检索指南，可以在提示词里显式要求：

```text
请先用 modern-web-guidance 检索相关指南，再开始写代码。
```

---

## 4. `npx` 卡住或超时

可能原因：首次下载 npm 包、网络受限、npm registry 不可达。

排查命令：

```powershell
npx.cmd -y modern-web-guidance@latest --version
npx.cmd -y modern-web-guidance@latest search "responsive table"
```

处理方式：

- 确认 Node.js 版本 >= 22；
- 确认能访问 npm registry；
- 国内网络如访问默认 registry 不稳定，可配置可达的 npm registry 镜像；
- 缓存完成后可尝试离线模式：

  ```powershell
  npx.cmd --offline -y modern-web-guidance@latest search "responsive table"
  ```

---

## 5. 提示 Node 版本过低

检查：

```powershell
node --version
```

若低于 22，安装 Node.js 22 LTS 后重启 WorkBuddy 和终端。

---

## 6. 安装脚本覆盖了旧 Skill

`install.ps1` / `install.sh` 在目标已存在时会先备份，例如：

```text
C:\Users\<用户名>\.workbuddy\skills\modern-web-guidance.backup-<时间戳>
C:\Users\<用户名>\.workbuddy-ai\skills\modern-web-guidance.backup-<时间戳>
```

恢复时删除新目录，再把 backup 目录改回 `modern-web-guidance` 即可。

---

## 7. 为什么不用源码仓库里的 `.agents/skills/`

`modern-web-guidance-src-main/.agents/skills/` 里的 `project-guides`、`project-evals` 等是给贡献者维护源码仓库用的流程规范，不是面向日常前端开发任务的运行时指南。WorkBuddy 需要安装的是发布产物：

```text
skills/modern-web-guidance/
```

---

## 8. 如何确认安装的是完整语料

国内版：

```powershell
(Get-ChildItem "$env:USERPROFILE\.workbuddy\skills\modern-web-guidance\guides" -Recurse -File -Filter *.md).Count
```

国际版：

```powershell
(Get-ChildItem "$env:USERPROFILE\.workbuddy-ai\skills\modern-web-guidance\guides" -Recurse -File -Filter *.md).Count
```

正常应为 **210** 个 Markdown 指南文件。
