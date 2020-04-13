//
//  ContentView.swift
//  plant_midi
//
//  Created by Roland Arnoldt on 3/2/20.
//  Copyright © 2020 Roland Arnoldt. All rights reserved.
//

import SwiftUI
import AudioKit
import AVFoundation

//var sound: AVAudioPlayer?
//var midi: AVMIDIPlayer?

struct ContentView: View {
    @State private var connect = true
    @State private var connected = false
    @State private var sendMessage = true
    @State private var sentMessage = false
    @State private var showTextfield = false
    @State private var message: String = ""
    
    @EnvironmentObject var midiV: MidiData

    
    @State private var sides: Double = 4
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("currentMidi: \(midiV.testText)")
                    .foregroundColor(.black)
                // Top of UI with plant name, image of plant and toggle textfield for messaging
                Spacer()
                Text("théodore")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding()
                Spacer()
                // If user pressed Send-Message Button, display textfield
                if showTextfield {
                    Text("photon message")
                        .foregroundColor(.black)
                        .font(.callout)
                        .bold()
                    TextField(" Type here ... ", text: $message)
                        .background(Color.white)
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                Image("sill_plant")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(connected ? 0 : 10)
                    .scaleEffect(!connected ? 0.8 : 1.0)
                    .animation(.easeInOut(duration: 3.0))
                Spacer()
                // Bottom of UI with audio/message buttons
                HStack {
                    
                    // If audio-stream is not running, display Play/Connect-Button
                    Spacer()
                    if connect {
                        Button(action: {
                            self.connect.toggle()
                            self.connected.toggle()
                            // Get midi from server and start stream
                            self.midiV.connectSocket(userInput: "midiRequest")
                        }) {
                            Image(systemName: "waveform.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            .padding()
                        }
                    }
                    // If audio-stream is running, display Stop-Button
                    if connected {
                        Button(action: {
                            self.connect.toggle()
                            self.connected.toggle()
                            // Stop playing stream and close socket connection
                            self.midiV.disconnectSocket()
                        }) {
                            Image(systemName: "waveform.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding()
                        }
                    }
                    
                    // Send light message to plant
                    Spacer()
                    if sendMessage {
                        Button(action: {
                            self.sendMessage.toggle()
                            // type in message
                            // open text field for user input
                            self.showTextfield.toggle()
                            // create some send button
                        }) {
                            Image(systemName: "paperplane")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding()
                                .animation(.easeInOut)
                        }
                    }
                    // If user is entering message, toggle Send-Message Button
                     if showTextfield {
                         Button(action: {
                             self.sendMessage.toggle()
                             self.midiV.connectSocket(userInput: "userInputMessage: \(self.message)")
                             self.showTextfield.toggle()
                             self.message = ""
                         }) {
                             Image(systemName: "paperplane.fill")
                                 .font(.largeTitle)
                                 .foregroundColor(.black)
                             .padding()
                         }.animation(.easeInOut)
                     }
                    
                    Spacer()
                }
                Spacer()
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        ContentView().environmentObject(MidiData())
    }
}



