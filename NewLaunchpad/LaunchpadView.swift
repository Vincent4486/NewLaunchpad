//
//  LaunchpadView.swift
//  NewLaunchpad
//
//  Created by vincent on 21-09-2025.
//
import SwiftUI
import AppKit

struct LaunchpadView: View {
    @ObservedObject var settings: CustomizationSettings
    @State private var apps: [AppItem] = []

    var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(settings.iconSize), spacing: settings.spacing), count: 8)
    }

    var body: some View {
        ZStack {
  
            settings.backgroundColor
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 16) {

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(apps) { app in
                            Button {
                                print("LAUNCHPAD: button tapped for", app.name)
                                NSApp.activate(ignoringOtherApps: true)

                                let cfg = NSWorkspace.OpenConfiguration()
                                NSWorkspace.shared.openApplication(at: app.url, configuration: cfg) { launched, error in
                                    if let e = error as NSError? {
                                        print("openApplication failed:", e.domain, e.code, e.userInfo)
                                    } else {
                                        print("openApplication success:", String(describing: launched))
                                        DispatchQueue.main.async {
                                            NSApp.hide(nil) // ✅ Safe on main thread
                                        }
                                    }
                                }
                            } label: {
                                VStack(spacing: 32) {
                                    Image(nsImage: app.icon)
                                        .resizable()
                                        .frame(width: settings.iconSize, height: settings.iconSize)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Text(app.name)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .lineLimit(1)
                                }
                                .contentShape(Rectangle())
                                .padding(4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: loadApps)
    }

    func getAppDirectories() -> [String] {
        return [
            "/Applications",
            "\(NSHomeDirectory())/Applications",
            "/System/Applications",
            "/Applications/XAMPP",
            "/Applications/Nikon Software/NX Studio",
            "/System/Applications/Utilities"
        ]
    }

    func loadApps() {
        let appDirs = getAppDirectories()
        var foundApps: [AppItem] = []
        var seen = Set<String>()

        let ignoredKeywords = ["helper", "uninstall", "broker", "transport", "agent", "daemon", "support", "service", "crash", "update", "error", "cef", "xml"]

        for dir in appDirs {
            let url = URL(fileURLWithPath: dir)
            guard let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles]) else { continue }

            for case let fileURL as URL in enumerator {
                guard fileURL.pathExtension == "app" else { continue }
                let fullPath = fileURL.path
                if seen.contains(fullPath) { continue }

                var isDir: ObjCBool = false
                guard FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir), isDir.boolValue else { continue }

                let plistPath = fileURL.appendingPathComponent("Contents/Info.plist")
                guard let plistData = try? Data(contentsOf: plistPath),
                      let plist = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else { continue }

                if let uiElement = plist["LSUIElement"] as? Bool, uiElement { continue }
                if let backgroundOnly = plist["LSBackgroundOnly"] as? Bool, backgroundOnly { continue }
                guard let executable = plist["CFBundleExecutable"] as? String, !executable.isEmpty else { continue }

                let icon = NSWorkspace.shared.icon(forFile: fullPath)
                icon.size = NSSize(width: 128, height: 128)
                if icon.isTemplate || icon.representations.isEmpty { continue }

                let name = fileURL.deletingPathExtension().lastPathComponent.lowercased()
                if ignoredKeywords.contains(where: { name.contains($0) }) { continue }

                foundApps.append(AppItem(name: name.capitalized, icon: icon, url: fileURL))
                seen.insert(fullPath)
            }
        }

        apps = foundApps.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
}
