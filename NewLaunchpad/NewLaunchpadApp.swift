//
//  NewLaunchpad.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//
import SwiftUI
import AppKit

@main
struct NewLaunchpadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var settings = CustomizationSettings()
    @State private var inspectorWindow: NSWindow?

    // ✅ Assign settings in init — outside of body
    init() {
        appDelegate.settings = settings
    }

    var body: some Scene {
        // Prevent default window creation
        Settings {
            EmptyView()
        }
    }
}
