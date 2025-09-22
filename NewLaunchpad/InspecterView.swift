//
//  InspecterView.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//

import SwiftUI

struct InspectorView: View {
    @ObservedObject var settings: CustomizationSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // Background Tint
            VStack(alignment: .leading, spacing: 8) {
                Text("Background Tint")
                    .font(.headline)
                ColorPicker("", selection: Binding(
                    get: { Color(settings.backgroundBaseColor) },
                    set: { newColor in settings.backgroundBaseColor = NSColor(newColor) }
                ), supportsOpacity: false)
                .labelsHidden()
            }

            // Icon Size
            VStack(alignment: .leading, spacing: 8) {
                Text("Icon Size: \(Int(settings.iconSize))")
                    .font(.headline)
                Stepper("", value: $settings.iconSize, in: 64...256, step: 8)
                    .labelsHidden()
            }

            // Icon Spacing
            VStack(alignment: .leading, spacing: 8) {
                Text("Icon Spacing: \(Int(settings.spacing))")
                    .font(.headline)
                Slider(value: $settings.spacing, in: 10...100, step: 5)
                    .frame(width: 200)
            }

            // Background Opacity
            VStack(alignment: .leading, spacing: 8) {
                Text("Background Opacity: \(Int(settings.backgroundAlpha * 100))%")
                    .font(.headline)
                Slider(value: $settings.backgroundAlpha, in: 0...1, step: 0.05)
                    .frame(width: 200)
            }

            Spacer()
        }
        .padding()
        .frame(width: 300, height: 500)
    }
}
