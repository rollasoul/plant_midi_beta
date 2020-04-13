# plant_midi_beta
beta iOS client for plant chat app

### Installation
This app is using the [AudioKit](https://audiokit.io/) framework for midi
* if running in Xcode 11.4 or later get the [latest beta](https://github.com/AudioKit/Specs) (avoids [compiler issues](https://github.com/AudioKit/AudioKit/issues/1987))
* [install] AudioKit (https://audiokit.io/downloads/) via CocoaPods
* deploy a remote server and run the node.js server-script (handles all the communication between plant and mobile device)
* get the hardware according to [this tutorial](https://github.com/electricityforprogress/BiodataSonificationBreadboardKit/blob/master/BiodataBreadboardArduinoKit_v01.pdf), assemble it 
* FEATHER HUZZAH ESP8266: download the [esp8266 plant socket repo](https://github.com/rollasoul/plant_midi_esp8266_beta), open it in ARDUINO IDE and flash your feather with it (handles sensing of plant and websockets)
* RASPBERRY PI: git clone the [govee-lights BLE repo](https://github.com/Freemanium/govee_btled), add the [pi-client python script](https://gist.github.com/rollasoul/54bfd4a7ac1e64432e1da83ece3d16b1) to the folder (modify lamp mac-address and remote server-ip before running)


### TODO
* cleanup code
* add references to hardware & server setup/code
