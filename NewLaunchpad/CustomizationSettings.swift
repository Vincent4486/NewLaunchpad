//
//  CustomizationSettings.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import SwiftUI

class CustomizationSettings: ObservableObject {
    @Published var backgroundColor: Color = Color.blue.opacity(0.1)
    @Published var iconSize: CGFloat = 128
    @Published var spacing: CGFloat = 50
}
