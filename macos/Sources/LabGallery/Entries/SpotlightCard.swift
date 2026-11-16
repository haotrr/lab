import SwiftUI

struct SpotlightCard: View {
    static let entry = Entry(
        id: "spotlight-card",
        title: "Spotlight Card",
        summary: "光标跟随的径向高光卡片，含边框高光。",
        tags: ["hover", "gradient", "card"]
    ) {
        HStack(spacing: 16) {
            SpotlightCard(title: "跟随光标", detail: "径向渐变的圆心绑定到指针位置。")
            SpotlightCard(title: "边框高光", detail: "同一渐变描边，只在边框内可见。")
        }
    }

    var title: String
    var detail: String

    @State private var location: CGPoint?
    private let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(24)
        .frame(width: 280, height: 160, alignment: .topLeading)
        .background {
            ZStack {
                shape.fill(.background.secondary)
                glow(radius: 160, opacity: 0.25)
            }
        }
        .clipShape(shape)
        .overlay {
            ZStack {
                shape.strokeBorder(.separator)
                glow(radius: 110, opacity: 1).mask(shape.strokeBorder(lineWidth: 1))
            }
        }
        .onContinuousHover { phase in
            switch phase {
            case .active(let point): location = point
            case .ended: location = nil
            }
        }
        .animation(.easeOut(duration: 0.3), value: location == nil)
    }

    private func glow(radius: CGFloat, opacity: Double) -> some View {
        Circle()
            .fill(RadialGradient(
                colors: [Color.accentColor.opacity(opacity), .clear],
                center: .center,
                startRadius: 0,
                endRadius: radius
            ))
            .frame(width: radius * 2, height: radius * 2)
            .position(location ?? .zero)
            .opacity(location == nil ? 0 : 1)
            .allowsHitTesting(false)
    }
}

#Preview {
    SpotlightCard.entry.content()
        .padding(40)
}
