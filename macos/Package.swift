// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LabGallery",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(name: "LabGallery", path: "Sources/LabGallery")
    ]
)
