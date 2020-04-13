//
//  Socket.swift
//  plant_midi
//
//  Created by Roland Arnoldt on 3/6/20.
//  Copyright © 2020 Roland Arnoldt. All rights reserved.
//

import Foundation
import SwiftUI
import AudioKit
import AVFoundation
import NaturalLanguage

class superMidi: ObservableObject {
        @Published var midiFromServer: Array<Int> = [73, 44, 41, 49, 73, 58]
}

class MidiData: MidiAudio {

    // Get data from Server and start the midi player
    @Published var userInput: String = ""
    @Published var socketConnected: Bool = false
    @Published var testText: String = "jfjfj"

    var midiStreaming = false
    var task: URLSessionWebSocketTask?
    let currentMidi = ""

    // Gets called when UI-Button is toggled on
    func connectSocket(userInput: String) {

        // Connect only if the socket is not already on
        if !socketConnected {
            let urlSession = URLSession(configuration: .default)
            self.task = urlSession.webSocketTask(with: URL(string: "ws://<your_server>:<port>")!)
            task!.resume()
            socketConnected = true
        }

        // Create a hello to server message, send user message if necessary
        if userInput.contains("midiRequest") {
            // Play rainforest sounds while being connected to sockets
            //TODO: make this a toggle in settings
            startRainforestPlayer()
            midiStreaming = true
            // send hello message to server
            let message = URLSessionWebSocketTask.Message.string("pls send midi from my plant called théodore")
            // Send a message
            task!.send(message) { error in
                if let error = error {
                    print("server did not connect, sent the following error: \(error))")
                }
            }
            listenToServer()
        }
        if userInput.contains("userInputMessage:") {
            // run NLP Engine on it and get sentiment
            let tagger = NLTagger(tagSchemes: [.sentimentScore])
            tagger.string = userInput
            let (sentiment, _) = tagger.tag(at: userInput.startIndex, unit: .paragraph, scheme: .sentimentScore)
            let score = Double(sentiment?.rawValue ?? "0") ?? 0
            print("NL sentiment score: \(score)")
            let userSentiment = "userInputMessage: \(score)"
            // Send user input as sentiment score to server
            let message = URLSessionWebSocketTask.Message.string(userSentiment)
            task!.send(message) { error in
                if let error = error {
                    print("could not sent message to server due to the following error: \(error)")
                }
                else {
                    print("user message \(userInput) sent to server ")
                    // End socket connection only if there is no midi streaming
                    if !self.midiStreaming {
                        self.disconnectSocket()
                    }
                }

            }
        }
    }

    func listenToServer() {
        guard let task = self.task else {return}
        // Create message
        task.receive() { result in
                switch result {
                case .failure(let error):
                    print("Failed to receive message: \(error)")
                case .success(let message):
                    switch message {
                        case .string(let text):
                            //print("Received text message: \(text)")
                            //convert string to array of ints
                            //TODO: rewrite this whole part of if-statements ...
                            if !text.contains("usermessage:") {
                                if text != "hello from your server" {
                                    if text != "hello from théodore" {
                                        if text != self.currentMidi {
                                            let currentMidi = text;
                                            let arraytext = (currentMidi.components(separatedBy: .whitespaces).joined()).components(separatedBy: ",")
                                            print(arraytext)
                                            DispatchQueue.main.async {
                                                self.midiFromServer = arraytext.map { Int(String($0))! }
                                                self.testText = arraytext.map { String($0) }.joined(separator: ", ")
                                                print("updated midi data: \(self.midiFromServer)")
                                                // start midi, wait for 6s if there is still audio playing
                                                // Check if midi player is already initialised
                                                if !self.midiPlayerInit {
                                                    self.startMidiPlayer()
                                                }
                                                self.midiPlayerInit = true
                                            }
                                        }
                                    }
                                }
                            }
                            if text.contains("usermessage:") {
                                print("usermessage was received by server")
                            }
                        case .data(let data):
                            print("Received binary message: \(data)")
                        @unknown default:
                            fatalError()
                    }

                    self.listenToServer()
                }
        }
    }

    // Gets called when UI Button is toggled off
    func disconnectSocket() {
        // Stop stream from plant
        task?.cancel()
        task = nil
        DispatchQueue.main.async {
            self.socketConnected = false
        }
        stopAllPlayers()

    }
}
