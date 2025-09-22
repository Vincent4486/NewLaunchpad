//
//  AppDelegate.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var inspectorWindow: NSWindow?
    var settings: CustomizationSettings?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set dock icon
        if let img = NSImage(named: "LaunchpadIcon") {
            NSApp.applicationIconImage = img
            print("Applied applicationIconImage")
        }

        // Launch in full screen
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame

            if let window = NSApplication.shared.windows.first {
                window.setFrame(screenFrame, display: true)
                window.level = .normal // or .floating if you want it above desktop
                window.isOpaque = false
                window.backgroundColor = .clear
            }
        }
    }

    func applicationDidHide(_ notification: Notification) {
        if NSApplication.shared.windows.isEmpty {
            NSApplication.shared.terminate(nil)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }

    // Optional: expose inspector logic here
    func showInspector() {
        guard let settings = settings else { return }

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
}
