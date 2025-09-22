import SwiftUI
import AppKit

@main
struct NewLaunchpadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    @StateObject private var settings = CustomizationSettings()
    @State private var inspectorWindow: NSWindow?

    var body: some Scene {
        WindowGroup {
            ZStack {
                LaunchpadView(settings: settings)
            }
            .onAppear {
                if let img = NSImage(named: "LaunchpadIcon") {
                    NSApp.applicationIconImage = img
                    print("Applied applicationIconImage onAppear")
                }
            }
        }
        .commands {
            CommandGroup(after: .sidebar) {
                Button("Show Inspector") {
                    if inspectorWindow == nil {
                        let inspector = NSHostingController(rootView: InspectorView(settings: settings))
                        let window = NSWindow(contentViewController: inspector)
                        window.title = "Launchpad Inspector"
                        window.setContentSize(NSSize(width: 300, height: 200))
                        window.styleMask = [.titled, .closable, .resizable]
                        window.makeKeyAndOrderFront(nil)
                        inspectorWindow = window
                    } else {
                        inspectorWindow?.makeKeyAndOrderFront(nil)
                    }
                }
                .keyboardShortcut(",", modifiers: [.command])
            }
        }
    }
}
