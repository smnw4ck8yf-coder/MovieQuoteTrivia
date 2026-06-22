import AVFoundation
import UIKit

final class AnswerFeedbackPlayer {
    static let shared = AnswerFeedbackPlayer()

    private var activePlayers: [AVAudioPlayer] = []

    private init() {}

    func playAnswerFeedback(isCorrect: Bool) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(isCorrect ? .success : .error)

        playTone(
            frequency: isCorrect ? 740 : 220,
            duration: isCorrect ? 0.09 : 0.12,
            volume: isCorrect ? 0.18 : 0.14
        )
    }

    private func playTone(frequency: Double, duration: Double, volume: Float) {
        do {
            let player = try AVAudioPlayer(data: Self.toneData(frequency: frequency, duration: duration, volume: volume))
            activePlayers.append(player)
            player.prepareToPlay()
            player.play()

            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.2) { [weak self, weak player] in
                guard let player else { return }
                self?.activePlayers.removeAll { $0 === player }
            }
        } catch {
            // Haptics still fire if audio cannot be prepared.
        }
    }

    private static func toneData(frequency: Double, duration: Double, volume: Float) -> Data {
        let sampleRate = 44_100
        let sampleCount = Int(Double(sampleRate) * duration)
        var samples = Data(capacity: sampleCount * MemoryLayout<Int16>.size)

        for index in 0..<sampleCount {
            let progress = Double(index) / Double(max(sampleCount - 1, 1))
            let envelope = sin(.pi * progress)
            let wave = sin(2.0 * .pi * frequency * Double(index) / Double(sampleRate))
            var sample = Int16(wave * envelope * Double(volume) * Double(Int16.max)).littleEndian
            samples.append(Data(bytes: &sample, count: MemoryLayout<Int16>.size))
        }

        return wavData(from: samples, sampleRate: sampleRate)
    }

    private static func wavData(from pcmData: Data, sampleRate: Int) -> Data {
        var data = Data()
        let byteRate = sampleRate * 2
        let blockAlign: UInt16 = 2
        let bitsPerSample: UInt16 = 16
        let subchunk2Size = UInt32(pcmData.count)
        let chunkSize = UInt32(36 + pcmData.count)

        data.appendString("RIFF")
        data.appendLittleEndian(chunkSize)
        data.appendString("WAVE")
        data.appendString("fmt ")
        data.appendLittleEndian(UInt32(16))
        data.appendLittleEndian(UInt16(1))
        data.appendLittleEndian(UInt16(1))
        data.appendLittleEndian(UInt32(sampleRate))
        data.appendLittleEndian(UInt32(byteRate))
        data.appendLittleEndian(blockAlign)
        data.appendLittleEndian(bitsPerSample)
        data.appendString("data")
        data.appendLittleEndian(subchunk2Size)
        data.append(pcmData)

        return data
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        append(Data(string.utf8))
    }

    mutating func appendLittleEndian(_ value: UInt16) {
        var value = value.littleEndian
        append(Data(bytes: &value, count: MemoryLayout<UInt16>.size))
    }

    mutating func appendLittleEndian(_ value: UInt32) {
        var value = value.littleEndian
        append(Data(bytes: &value, count: MemoryLayout<UInt32>.size))
    }
}
