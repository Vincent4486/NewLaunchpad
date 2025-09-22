//
//  AppDelegate.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var inspectorWindow: NSWindow?
    var settings: CustomizationSettings!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set dock icon
        if let img = NSImage(named: "LaunchpadIcon") {
            NSApp.applicationIconImage = img
            print("Applied applicationIconImage")
        }

        // Create fullscreen main window
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame

            let launchpadWindow = NSWindow(
                contentRect: screenFrame,
                styleMask: [.titled, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )

            launchpadWindow.title = "Launchpad"
            launchpadWindow.titleVisibility = .hidden
            launchpadWindow.titlebarAppearsTransparent = true
            launchpadWindow.setFrame(screenFrame, display: true)
            launchpadWindow.level = .normal
            launchpadWindow.isOpaque = false
            launchpadWindow.backgroundColor = settings.backgroundNSColor
            launchpadWindow.hasShadow = false
            launchpadWindow.collectionBehavior = [.fullScreenPrimary, .canJoinAllSpaces]
            launchpadWindow.isMovableByWindowBackground = true
            launchpadWindow.contentView = NSHostingView(rootView: LaunchpadView(settings: settings))
            launchpadWindow.makeKeyAndOrderFront(nil)
            launchpadWindow.acceptsMouseMovedEvents = true
            launchpadWindow.ignoresMouseEvents = false

            self.window = launchpadWindow
            self.settings = CustomizationSettings()
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
}
