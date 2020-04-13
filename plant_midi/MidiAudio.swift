import AudioKit
import AVFoundation


class MidiAudio: superMidi {

    var midiPlayerInit = false
    var midiFade = false
    var audioPlayer: AVAudioPlayer!

    // Rainforest ambience sounds
    func startRainforestPlayer() {

        let sound = Bundle.main.path(forResource: "rainforest", ofType: "mp3")

        // Stop and delete audio player in case button gets pressed again before fade out is finished
        if (audioPlayer != nil) {
            print("bar")
            if audioPlayer.isPlaying {
                print("foo")
                audioPlayer.stop()
            }
            audioPlayer = nil
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            // Loop until player is stopped
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0
        }
        catch {
            print(error)
        }
        audioPlayer.play()
        audioPlayer.setVolume(1, fadeDuration: 6)
        print("started rainforest")
    }

    // Plant midi as tubular bell sounds
    func startMidiPlayer() {

        let playRate = 2.0
        let tubularBells = AKTubularBells()
        let delay = AKDelay(tubularBells)

        delay.time = 2.0 / playRate
        delay.dryWetMix = 0.2
        delay.feedback = 0.2

        let reverb = AKReverb(delay)
        AKManager.output = reverb

        let performance = AKPeriodicFunction(frequency: playRate) {
            //print("hello from other class: \(self.midiFromServer)")
            //TODO: delete random selections after implementation of scale update
            let scale = [ 0, 2, 4, 5, 7, 9, 11]
            var note = self.midiFromServer.randomElement()
            while !scale.contains(note! % 12) {
                note! += 1
            }
            let frequency = (note!).midiNoteToFrequency()
            let amplitude = random(in: 0.125...0.5)
            if random(in: (Double(note!) - 5)...Double(note!)) > Double(self.midiFromServer.randomElement()!) {
                tubularBells.trigger(frequency: frequency, amplitude: amplitude)
            }
        }

        do {
            try AKManager.start(withPeriodicFunctions: performance)
            midiPlayerInit = true
        }
        catch {
            print("Oops! AudioKit didn't start!")
        }
        performance.start()
    }


    // Stopping AudioKit Module, AVAudioPlayer and Websockets
    func stopAllPlayers() {
        if midiPlayerInit {
            // stop audioKit
            midiFade = true
            // Wait for reverb to finish async then stop AudioKit
            DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
                    do {
                        try AKManager.stop()
                        DispatchQueue.main.async {
                            self.midiFade = false
                        }
                    } catch {
                        print(error)
                    }
            }

            // Slowly fade out and stop the player
            self.audioPlayer.setVolume(0, fadeDuration: 6)
            // Wait for fade to finish async then stop
            DispatchQueue.global().asyncAfter(deadline: .now() + 6) {
                if self.audioPlayer != nil && self.audioPlayer.volume == 0 {
                    print("stopping the player in the background thread")
                    self.audioPlayer.stop()
                    self.audioPlayer = nil
                }
            }
        }
        midiPlayerInit = false
    }
}
