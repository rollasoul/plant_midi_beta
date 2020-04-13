# plant_midi_beta
beta repo for a plant chat app using iOS device, cloud server and hardware 
  
[![IMAGE ALT TEXT HERE](https://i.vimeocdn.com/video/877513457.jpg)](https://vimeo.com/406891053)

## Installation

### device side
* **iOS DEVICE: handles communication between device and remote server, processes midi to audio on device, runs sentiment analysis on user messages locally**
    * the app is using the [AudioKit](https://audiokit.io/) framework for midi, [install] AudioKit (https://audiokit.io/downloads/) via CocoaPods
    * if running in Xcode 11.4 or later get the [latest beta](https://github.com/AudioKit/Specs) (avoids [compiler issues](https://github.com/AudioKit/AudioKit/issues/1987))

### remote server side
* **CLOUD SERVER: handles all the communication between plant and mobile device**
    * deploy a remote server and run [this node.js server-script](https://gist.github.com/rollasoul/00cd208704a25aabdb647e6643d331db) 

### plant side (Feather Huzzah, Raspberry Pi, Govee BLE lightbulb) 
* **HARDWARE: handles physical computation side of the project**
    * get the hardware according to [this tutorial](https://github.com/electricityforprogress/BiodataSonificationBreadboardKit/blob/master/BiodataBreadboardArduinoKit_v01.pdf), assemble it 
* **FEATHER HUZZAH ESP8266: handles sensing of plant and communication between remote server, feather huzzah and sensor on plant**
    * download the [esp8266 plant socket repo](https://github.com/rollasoul/plant_midi_esp8266_beta)
    * open it in ARDUINO IDE and flash your feather with it 
* **RASPBERRY PI: handles communication between remote server, pi and BLE-lights**
    * git clone the [govee-lights BLE repo](https://github.com/Freemanium/govee_btled)
    * add the [pi-client python script](https://gist.github.com/rollasoul/54bfd4a7ac1e64432e1da83ece3d16b1) to the main-repo folder
    * in the script modify lamp mac-address and remote server-ip to your settings


## TODO
* cleanup code
* add image references to hardware setup
