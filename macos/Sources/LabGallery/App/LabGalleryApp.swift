import AppKit
import SwiftUI

@main
struct LabGalleryApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup("Lab") {
            GalleryView()
        }
        .defaultSize(width: 1040, height: 680)
    }
}

// `swift run` launches a bare executable, which macOS treats as a background
// process with no Dock icon or key window unless the policy is set explicitly.
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
