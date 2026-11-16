import SwiftUI

struct GalleryView: View {
    @State private var selection: Entry.ID? = Catalog.entries.first?.id
    @State private var query = ""

    private var filtered: [Entry] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return Catalog.entries }
        return Catalog.entries.filter { entry in
            ([entry.title, entry.summary] + entry.tags).joined(separator: " ").lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationSplitView {
            List(filtered, selection: $selection) { entry in
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                    Text(entry.tags.map { "#\($0)" }.joined(separator: " "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .searchable(text: $query, placement: .sidebar, prompt: "搜索")
            .navigationSplitViewColumnWidth(min: 200, ideal: 240)
        } detail: {
            if let entry = Catalog.entries.first(where: { $0.id == selection }) {
                EntryDetail(entry: entry)
            } else {
                ContentUnavailableView("选择一个条目", systemImage: "square.grid.2x2")
            }
        }
    }
}

private struct EntryDetail: View {
    let entry: Entry

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title).font(.title2.weight(.semibold))
                Text(entry.summary).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)

            Divider()

            entry.content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(32)
        }
        .navigationTitle(entry.title)
    }
}
