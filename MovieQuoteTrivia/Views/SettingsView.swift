import SwiftUI

struct SettingsView: View {
    @AppStorage(AppSettings.soundEffectsKey) private var soundEffectsEnabled = true
    @AppStorage(AppSettings.hapticsKey) private var hapticsEnabled = true

    let onResetStatistics: () -> Void

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

        if let version, let build, !build.isEmpty {
            return "Version \(version) (\(build))"
        }

        if let version {
            return "Version \(version)"
        }

        return "Version 1.0"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .accessibilityIdentifier("settings_title")

            VStack(spacing: 12) {
                Toggle(isOn: $soundEffectsEnabled) {
                    Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .tint(.orange)
                .padding()
                .background(Color.gray.opacity(0.18))
                .cornerRadius(12)
                .accessibilityIdentifier("sound_effects_toggle")

                Toggle(isOn: $hapticsEnabled) {
                    Label("Haptics", systemImage: "iphone.radiowaves.left.and.right")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .tint(.orange)
                .padding()
                .background(Color.gray.opacity(0.18))
                .cornerRadius(12)
                .accessibilityIdentifier("haptics_toggle")
            }

            Button(action: onResetStatistics) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset Statistics")
                }
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.35))
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .accessibilityIdentifier("reset_statistics_button")

            Spacer()

            Text(appVersion)
                .font(.caption)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityIdentifier("app_version_label")
        }
        .padding()
        .background(Color.black)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier("settings_screen")
    }
}
