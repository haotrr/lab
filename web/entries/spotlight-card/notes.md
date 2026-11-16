# Spotlight Card

## 效果

卡片背景与边框上有一束跟随光标的柔光，指针离开时淡出。适合功能卡片、定价卡片等需要轻微交互反馈的场景。

## 原理

- `pointermove` 把指针相对卡片的坐标写入 CSS 变量 `--x`、`--y`。
- `::before` 用 `radial-gradient(... at var(--x) var(--y))` 画背景光晕。
- `::after` 用同样的渐变，再用 `mask` 的 `exclude` 合成，只保留 `padding: 1px` 那一圈，形成边框高光。
- `--spot` 控制透明度，进入/离开时过渡。

## 要点

- 只更新 CSS 变量，不触发布局，性能开销很小。
- `isolation: isolate` 让 `z-index: -1` 的伪元素留在卡片内部。
- 颜色用 `color-mix()` 派生自 `--accent`，深浅色模式自动适配。
- 触屏设备没有 hover，效果仅在拖动时出现，属于纯增强。

## 兼容性

`color-mix()`、`mask-composite`（`exclude`）在现代浏览器均已支持。

## macOS 对应

`macos/Sources/LabGallery/Entries/SpotlightCard.swift`：`onContinuousHover` + `RadialGradient`。
