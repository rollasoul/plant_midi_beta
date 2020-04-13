# plant_midi_beta
beta iOS client for plant chat app

### Installation
This app is using the [AudioKit](https://audiokit.io/) framework for midi
* if running in Xcode 11.4 or later get the [latest beta](https://github.com/AudioKit/Specs) (avoids [compiler issues](https://github.com/AudioKit/AudioKit/issues/1987))
* [install] AudioKit (https://audiokit.io/downloads/) via CocoaPods
* deploy a remote server and run the node.js server-script (handles all the communication between plant and mobile device)
* get the hardware, assemble it and flash it with this arduino-script (handles sensing of plant, BLE lamp connection and websockets)

### TODO
* cleanup code
* add references to hardware & server setup/code
