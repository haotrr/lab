import SwiftUI

struct Entry: Identifiable {
    /// Same slug as the matching web entry under `web/entries/`.
    let id: String
    let title: String
    let summary: String
    let tags: [String]
    let content: @MainActor () -> AnyView

    init(
        id: String,
        title: String,
        summary: String,
        tags: [String] = [],
        @ViewBuilder content: @escaping @MainActor () -> some View
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.tags = tags
        self.content = { AnyView(content()) }
    }
}

@MainActor
enum Catalog {
    static let entries: [Entry] = [
        SpotlightCard.entry,
    ]
}
