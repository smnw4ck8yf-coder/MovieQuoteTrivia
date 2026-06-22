import Foundation

enum AppSettings {
    static let soundEffectsKey = "mqt_soundEffectsEnabled"
    static let hapticsKey = "mqt_hapticsEnabled"

    static func bool(forKey key: String, defaultValue: Bool = true) -> Bool {
        guard UserDefaults.standard.object(forKey: key) != nil else {
            return defaultValue
        }

        return UserDefaults.standard.bool(forKey: key)
    }
}
