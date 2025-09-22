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
        VStack(spacing: 20) {

            ColorPicker("Background Tint", selection: $settings.backgroundColor, supportsOpacity: true)

            Stepper("Icon Size: \(Int(settings.iconSize))", value: $settings.iconSize, in: 64...256, step: 8)
            

            Text("Icon Spacing")
            Slider(value: $settings.spacing, in: 10...100, step: 5)
                .frame(width: 200)
            

            Spacer()
            
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}
