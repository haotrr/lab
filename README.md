# Lab

UI/UX 组件与效果的探索实验室，也是后续 Web、macOS 等应用开发的弹药库。

原则：尽量原生、简洁、灵活。Web 端零依赖、无构建步骤；macOS 端为纯 SwiftUI Swift Package。

## 目录结构

```
lab/
├── web/                    # Web 实验（原生 HTML / CSS / JS）
│   ├── index.html          # 画廊首页，读取 catalog.json 展示所有条目
│   ├── catalog.json        # 由脚本根据 entries/*/meta.json 生成，勿手改
│   ├── shared/             # 公共样式与脚本（reset、设计 token、条目页外框）
│   └── entries/
│       ├── _template/      # 新条目模板
│       └── <slug>/         # 一个条目一个目录：index.html + meta.json + notes.md
├── macos/                  # SwiftUI 画廊（Swift Package）
│   ├── Package.swift
│   └── Sources/LabGallery/
│       ├── App/            # App 入口与画廊框架
│       └── Entries/        # 一个条目一个文件
└── scripts/                # 零依赖 Node 脚本：本地服务、新建条目、生成目录
```

## Web

需要 Node 18+，无需安装依赖。

```sh
npm run dev                          # 启动本地服务 http://localhost:5173
npm run new -- spotlight-card "Spotlight Card"   # 从模板新建条目
npm run catalog                      # 重新生成 web/catalog.json
```

每个条目都是独立的 HTML 页面，可直接复制到其他项目使用。`notes.md` 记录原理、要点、兼容性和参考资料。

## macOS

需要 Xcode 16+ / Swift 6，macOS 15+。

```sh
cd macos && swift run                # 运行画廊
open macos/Package.swift             # 或用 Xcode 打开（支持预览）
```

新增条目：在 `Sources/LabGallery/Entries/` 新建一个 View 文件，提供 `static let entry`，再登记到 `App/Catalog.swift`。

## 条目约定

- slug 使用 kebab-case，Web 与 macOS 上同一效果用同一个 slug，便于对照。
- `meta.json` 字段：`title`、`summary`、`tags`、`created`（YYYY-MM-DD）。
- 每个条目尽量自包含，只依赖 `shared/` 中的基础样式。
