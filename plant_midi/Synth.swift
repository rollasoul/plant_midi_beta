//
//  Synth.swift
//  plant_midi
//
//  Created by Roland Arnoldt on 3/3/20.
//  Copyright © 2020 Roland Arnoldt. All rights reserved.
//


import Foundation
import AVFoundation
import CoreAudioKit

class Synth {
    
    // Properties
    public static let shared = Synth()
    
    public var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
    
    private var audioEngine: AVAudioEngine
    private var time: Float = 0
    private let sampleRate: Double
    private let deltaTime: Float
    
    lazy var sourceNode = AVAudioSourceNode {(_, _, frameCount, audioBufferList) -> OSStatus in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for frame in 0..<Int(frameCount) {
            let sampleVal = self.signal(self.time)
            self.time += self.deltaTime
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
            }
        }
        return noErr
    }
    
    private var signal: Signal
    
    
    // Init
    init(signal: @escaping Signal = Oscillator.sine) {
        
        
        audioEngine = AVAudioEngine()
        
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        
        self.signal = signal
        
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: format.isInterleaved)
        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 1
        do {
            try audioEngine.start()
        } catch {
            print("could not start engine: \(error.localizedDescription)")
        }
    }
    
    // MARK: Public Functions

    public func setWaveformTo(_ signal: @escaping Signal) {
        self.signal = signal
    }
    
}

typealias Signal = (Float) -> (Float)

struct Oscillator {
    static var frequency: Float = 440
    static var amplitude: Float = 1
    
    static var sine = { (time: Float) -> Float in
        return Oscillator.amplitude * sin(2.0 * Float.pi * Oscillator.frequency * time)
    }
}


