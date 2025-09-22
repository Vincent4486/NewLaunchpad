//
//  CustomizationSettings.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import SwiftUI
import AppKit

class CustomizationSettings: ObservableObject {
    @Published var backgroundBaseColor: NSColor = .systemBlue
    @Published var backgroundAlpha: CGFloat = 0.0

    var backgroundNSColor: NSColor {
        backgroundBaseColor.withAlphaComponent(backgroundAlpha)
    }

    var backgroundColor: Color {
        Color(backgroundNSColor)
    }

    @Published var iconSize: CGFloat = 128
    @Published var spacing: CGFloat = 50
}
