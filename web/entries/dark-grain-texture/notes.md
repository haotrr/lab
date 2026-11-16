# Dark Grain Texture（暗色磨砂质感）

## 效果

纯色暗背景上叠加一层极淡的灰度噪点，让背景有纸张或磨砂玻璃的颗粒感，避免大面积纯色显得“平”。

参考：<https://blog.guoqi.dev/en/posts/blogger/>（2026-11-16 抓取），截图见 `reference/`。

## 原站实现（逆向结果）

页面结构（Tailwind v4 + Astro）：

```html
<html class="bg-page dark:bg-page-dark">           <!-- 背景色放在 html 上 -->
  <body class="bg-transparent ...">
    <div class="pointer-events-none fixed inset-0 z-1 size-full
                bg-[url('/noise.png')] bg-size-[128px_128px] bg-repeat opacity-6"></div>
    <div class="relative z-2 ...">…内容…</div>
  </body>
</html>
```

等价 CSS：

```css
html { background: #121212; }          /* --color-page-dark；浅色为 #fff */
body { background: transparent; }

.grain {
  position: fixed;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  background: url(noise.png) repeat;
  background-size: 128px 128px;
  opacity: 0.06;
}

.content { position: relative; z-index: 2; }
```

噪点图 `noise.png` 分析：

| 属性 | 值 |
| --- | --- |
| 尺寸 | 256×256，显示为 128px（2x 密度） |
| 格式 | 4-bit 调色板 PNG，16 级灰，约 22 KB |
| 色调分布 | 约 51% 纯黑，13% 纯白，其余在中间均匀分布 |
| 平均亮度 | 约 75 / 255 |

叠加后实际像素：纯黑噪点 ≈ 18 × 0.94 ≈ 17，纯白噪点 ≈ 18 + 237 × 0.06 ≈ 32。整体平均约 `#151515`，比底色亮一点点，肉眼几乎察觉不到色差，只感到颗粒。

同一层在浅色模式下照样生效：白底上黑噪点 6% 变暗，形成纸张感。

### 复现验证

两者都用无头 Chrome 在 2x 缩放下截图，统计空白背景区域的亮度（0–255）：

| | 平均 | 标准差 | 最小 | 最大 |
| --- | --- | --- | --- | --- |
| 原站 | 21.45 | 5.79 | 17 | 32 |
| 本条目 PNG 方案 | 21.63 | 5.88 | 17 | 32 |

## 要点

- **层级**：颗粒在背景之上、内容之下（z-1 / z-2），文字保持锐利。想要胶片感（颗粒盖住一切），把颗粒层放到最上面。
- **fixed + inset: 0**：滚动时颗粒不动，只有一个合成层，开销很小。`pointer-events: none` 不拦截点击。
- **2x 平铺**：256px 图按 128px 显示，在 Retina 屏上一个噪点等于一个物理像素，颗粒最细腻；1x 屏会被缩小采样，颗粒变柔和。
- **高反差噪点 + 低不透明度**：噪点本身黑白分明（大量纯黑和纯白），靠 6% 的不透明度压下去。比起低反差噪点配高不透明度，更“干净”。
- **opacity 而不是 blend mode**：普通混合就够了，兼容性最好，深浅主题共用一张图。
- 不透明度参考：暗色 4–8% 比较自然，超过 12% 开始明显变“脏”。

## 三种实现

`index.html` 的控制面板可以切换，也可用 URL 参数设置初始状态，例如 `?source=svg&opacity=0.1&compare=1&light=1`：

1. **PNG 平铺**（原站做法）：`noise.png` 由脚本按原图色调分布重新生成（未使用原站文件）。最稳定，可缓存。
2. **SVG feTurbulence**：data URI 内联，无额外请求。`fractalNoise` 原始输出是低反差的中灰，需要 `feComponentTransfer` 拉开反差。颗粒形态比随机像素更“云状”。
3. **Canvas 运行时生成**：JS 生成 256×256 随机像素再转 data URL，可按需调整分布、种子或尺寸。

## 兼容性

全部为基础 CSS（`position: fixed`、`background-size`、`opacity`），所有浏览器可用。SVG 滤镜在 data URI 中需正确编码 `#`。

## macOS 对应思路

SwiftUI 中可用 `Image(nsImage:).resizable(resizingMode: .tile)` 叠加在背景上，`.opacity(0.06)` 并 `.allowsHitTesting(false)`；噪点图可在启动时用 `CGContext` 生成。
