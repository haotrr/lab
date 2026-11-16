# AGENTS.md

本仓库用于探索和记录 UI/UX 组件与效果，作为 Web、macOS 应用开发的素材库。

## 原则

- 尽量原生、简洁、灵活。Web 端不引入框架、依赖或构建步骤；macOS 端只用 SwiftUI / AppKit。
- 每个条目自包含、可直接复制复用。
- 用中文写文档与笔记，代码标识符用英文。

## Web 条目

- 位置：`web/entries/<slug>/`，用 `npm run new -- <slug> "<Title>"` 从 `_template` 创建。
- 必备文件：`index.html`（演示）、`meta.json`（元数据）、`notes.md`（原理与要点）。
- 修改 `meta.json` 后运行 `npm run catalog`，不要手改 `web/catalog.json`。
- 只依赖 `web/shared/base.css` 与 `web/shared/entry.css`；条目专属样式与脚本写在条目内。
- 尊重 `prefers-reduced-motion` 与 `prefers-color-scheme`。

## macOS 条目

- 位置：`macos/Sources/LabGallery/Entries/<Name>.swift`，提供 `static let entry`，并登记到 `App/Catalog.swift`。
- 与 Web 对应条目使用相同 slug 作为 `id`。
- 验证：`cd macos && swift build`。
