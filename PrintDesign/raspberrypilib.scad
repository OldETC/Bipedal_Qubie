// raspberrypilib.scad

/***********************************************************************************
** Copyright 2019 Howard L. Howell (Les)
** 
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
** 
** http://www.apache.org/licenses/LICENSE-2.0
** 
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.
**************************************************************************************/

// should fit pi2, pi3, and pi4.
// basic board dimensions
function piHeight()=19.8;      // from top of dual usp to highest protrusion on the bottom.
function piLength()=87.2;      // including the protrusion of the USB ports to far board edge
function piWidth()=57.6;       // across the HDMI to the opposite side.
function piAudioJack()=.8;     // depth the audio jack protrudes from the board edge
function piBoardThick()=1.2;   // thickness of only the circuitboard
function piFlangeOffset()=2.9;  //

// locations of the jacks along the hdmi side of the board
function piAudioJackDia()=5.8; // measured outside board dia
function piAudioJackloc()=51+piAudioJackDia()/2;  // measured from board end
function piuUSB2end()=7.3;  // measured from board end to microusb
function piuUSBWidth()=7.7;  // measured across flanges
function piuUSBheight()=2.7; // measured across flanges.  Mounted flush to board top surface.
function piHDMIloc()=24.9;   // measured from board end
function piHDMIwidth()=14.9; // measured across flange
function piHDMIheight()=6.3; // measured across flange

// screw or post mounting the pi board needs these measurements
function piScrewHoledia()=3; // inside diameter of the screw holes
function piScrewHoleEnd()=2.2+piScrewHoledia()/2; // distance to holes at board end
function piScrewHoleUSB()=60.2+ piScrewHoledia()/2;// distance to holes at usb end
function piScrewHoleLoc()=2.2+ piScrewHoledia()/2; // all four measured from board edge.
function piScrewHoleWidth()=49.5; // distance between the screw holes measuring across the width of the board
function piScrewHoleLength()=58.5; // distance between the screw holes measuring along the length of the board

// sockets along the USB end
function piFirstUSBloc()=4.2;   // measured from GPIO connector edge
function piSecondUSBloc()=20.7; // measured from GPIO connector edge 
function piUSBHeight()=15.7;// height of the opening to access the dual usb port
function piUSBWidth()=14.9; // width of the opening to access the dual usb port
function piEthernetLoc()=38.2; // measured from GPIO edge
function piEthernetHeight()=13.6; // height of the opening to access the eithernet port
function piEthernetWidth()=16.1; // width of the opening to access the ethernet port
// gpio stuff
function piBoardPinThick()=4.7;     // board thickness including pin heights
function piGPIOthick()=5.5;          // measured across the plastic mount and padded .2
function piGPIOwidth()=50.9;         // measured across the plastic mount and padded .2
function piGPIOloc()=6.8;            // measured from board end and reduced by .1
// locations of the internal flat ribbon cables
function piDisplayPortFLoc()=39.4;   // far end of display port from HDMI edge
function piDisplayPortNLoc()=19.2;   // near end of display port from HDMI edge
function piDisplayPortFend()=6.1;    // far side of display port to board end
function piDisplayPortNend()=1.8;    // near side of display port to board end
function piCameraPortFend()=46.5;    // far side of camera port to board end
function piCameraPortNend()=44;      // near side of camera port to board end
function piCameraPortNside()=3.1;    // end of camera port to board edge
function piCameraPortFside()=22.5;   // far end of camera port to board edge


