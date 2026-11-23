# Modern Web Guidance for WorkBuddy

这是一个同时适用于**国内版 WorkBuddy**和**国际版 WorkBuddy**的开箱即用 Skill 仓库。它把 Google 官方发布的 `modern-web-guidance` Skill 产物整理成 WorkBuddy 可直接识别的目录结构，提供脚本安装、ZIP 上传安装和中文文档。

> 上游项目：[GoogleChrome/modern-web-guidance](https://github.com/GoogleChrome/modern-web-guidance)  
> 本仓库仅做 WorkBuddy 适配与打包，不修改上游指南内容。

## 兼容性结论

**国内版和国际版都适用。** 两版使用的是同一套开放 `SKILL.md` 格式，但用户级 Skill 目录不同：

| 版本 | 用户级 Skill 目录 |
|---|---|
| 国内版 WorkBuddy | `C:\Users\<用户名>\.workbuddy\skills\` |
| 国际版 WorkBuddy | `C:\Users\<用户名>\.workbuddy-ai\skills\` |
| 项目级（两版共用） | `<项目根目录>\.codebuddy\skills\` |

本仓库的安装脚本默认 `-Edition Auto`，会自动检测本机已经存在的版本目录；也可以用 `-Edition Both` 一次安装到两个目录。详见 [docs/COMPATIBILITY.md](./docs/COMPATIBILITY.md)。

## 这个 Skill 做什么

`modern-web-guidance` 会在 WorkBuddy 处理以下任务时，优先检索官方维护的现代 Web 指南，再把结果注入上下文，避免模型输出过时写法：

- HTML / CSS / 客户端 JavaScript
- 对话框、Popover、菜单、导航抽屉等 UI 组件
- 响应式布局、容器查询、动画、View Transitions
- 表单、自动填充、校验、无障碍
- 性能优化、Core Web Vitals、安全、PWA、Web Components
- 浏览器内置 AI、Temporal、日期时区等平台 API

不适用：后端 API、数据库、CI/CD、Docker、脚本工具链等任务。

## 仓库结构

```text
modern-web-guidance-workbuddy/
├─ skills/
│  └─ modern-web-guidance/
│     ├─ SKILL.md              # WorkBuddy Skill 入口（已补 WorkBuddy 元数据）
│     └─ guides/               # 官方指南语料
├─ dist/
│  └─ modern-web-guidance.zip  # 可直接上传到 WorkBuddy 技能页面的 ZIP
├─ scripts/
│  ├─ install.ps1              # Windows PowerShell 安装脚本
│  ├─ install.sh               # Git Bash / macOS / Linux 安装脚本
│  ├─ verify.ps1               # Windows 验证脚本
│  └─ verify.sh                # Git Bash / macOS / Linux 验证脚本
├─ docs/
│  ├─ COMPATIBILITY.md         # 国内版 / 国际版差异说明
│  └─ TROUBLESHOOTING.md       # 常见问题
├─ INSTALL.md                  # 详细安装、验证、更新、卸载步骤
├─ provenance.json             # 上游版本与来源记录
├─ LICENSE                     # 上游 Apache-2.0 许可证
└─ package.json                # 可选 npm 快捷脚本
```

## 快速开始（Windows）

自动检测本机版本并安装：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1
```

同时安装到国内版和国际版目录：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Edition Both
```

安装为项目级 Skill：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\install.ps1 -Scope Project
```

然后**完全退出并重新打开 WorkBuddy**。详细步骤见 [INSTALL.md](./INSTALL.md)。

## 方式二：在 WorkBuddy 技能页面上传 ZIP

国内版和国际版都支持：

1. 打开 WorkBuddy 的「技能 / Skills」页面；
2. 点击「添加技能 / Add skill」→「上传技能 / Upload skill」；
3. 选择本仓库的 `dist/modern-web-guidance.zip`；
4. 启用技能并新建会话。

## 运行环境要求

- 国内版或国际版 WorkBuddy
- Node.js `>= 22`
- WorkBuddy 允许执行 `npx -y modern-web-guidance@latest *`
- 首次使用需要联网；CLI 本身在缓存后可离线运行

## 验证

终端验证：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify.ps1 -Edition Both
```

WorkBuddy 内验证：新建一个会话，输入：

```text
帮我实现一个关闭按钮和点击遮罩都能关闭的 dialog，请用现代 Web 指南确认做法。
```

正常触发时，回答末尾会出现 `### Modern Web Guidance` 段落。

## 来源与许可

- 上游仓库：`https://github.com/GoogleChrome/modern-web-guidance`
- 上游提交：`64a6d708f5a43f2cd3fde5d4d7db3905ba1bdf65`
- 上游版本：`1.0.1`
- 许可证：Apache-2.0，见 [LICENSE](./LICENSE)

本仓库为 WorkBuddy 适配版，额外添加了 `display_name`、`description_zh`、`agent_created: true` 等 WorkBuddy Skill 元数据；指南正文保持不变。
