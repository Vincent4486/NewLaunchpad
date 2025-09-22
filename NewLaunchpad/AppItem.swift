//
//  AppItem.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import Foundation
import AppKit

struct AppItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: NSImage
    let url: URL
}
