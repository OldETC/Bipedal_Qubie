// DS3218mglib.scad

//DS3218mg servo from DSServo
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

// This is my own design and implementation of a framework for a bipedal walking robot.
// It utilizes several servos for motion.  The design is intended for simple modification 
// based upon measurements of the intended servos and compute board.  
// the modifications are all to be made in the header file titled [servoname]lib.scad for example,
// this one is HS311lib.scad for the HITeck HS311.
// Openscad won't import variables, so here they are each functions returning the measured value with 
// added clearance where required.  Note the ones with a "+value".  these set clearances and so you
// make the measurement, put that number between the equals sign and the plus sign ex:
//  somevalue()=[measuredvalue]+.5;
function bracketthickness()=3; // minimum 2.  you may increase it to improve bracket strength.
			       // you could decrease it if you test the module strength against the servo torque

/************************************************************************
*** High strength servo's usuall have metal arms included.  Use them. ***
*************************************************************************/
// the arm shape will be something like:
//  a rounded end and a narrow arm.  This is the shape we expect for now.
//  It only matters to add placement arcs on the plastic lever. It is the screws and friction that spreads
//  the load to the plastic arm.

function useArm()=1;           // set to one to use the arm supplied with your servo.  High strength servos will tear the plastic
                               // so using the included arm will allow the force to be applied over a larger area of the plastic.
			       // the arm looks like a circle clamp with an extended horn that is about 1" long measured from the 
                               // center of the servo axel.

// these measurements are for the form of the arm to be used from the servo
// ANY CHANGE requires working through the armsim shoulders and screw blocks.  See the notes at armsim.
function armThickness()=6;     // at the thickest part around the servo axel. sized for the ds3218 20Kgcm servo
function armPivotWidth()=15.2;   // measured across the axel widest point i.e. hub diameter. sized for the ds3218 servo
//function armSmallWidth()=6.4;    // sized for the ds3218 servo
function armSmallWidth()=8.1;      // second shipment the arm was different.
function armOverAllLength()=34.6;// sized for the ds3218 measure from pivot end to end of arm
function armScrewHole()=20.00;   // distance from center of servo shaft to center of screw hole
function armScrewDia()=3;        // diameter of the screw for the pivot arm
function armScrewHole2()=24.15;  // distance to the center of the second hole from the servo control axel.
function armTensionBoltDia()=3.6;  // diameter of the arm tensioning bolt heads.
function armTensionBoltDepth()=1.3; // depth past the circumference of the pivot circle
function armTensionBoltLength()=10.9; // measure from the top of the bolt head to the slot on the opposite side, then add armTensionBoltDepth



// these next 17 measurements you need to make on your servo to get the right bracket design 
//from this software.  Every type and sometimes manufacturer, has different measurements. 
function servowidth()=20.3+.2; // the point 2 allows fitment. measured across the narrowest dimension of the servo
function servoheight()=40.5+.2; // the point 2 again for fitment. measured from the bottom of the servo to the flat behind the horn
function servolength()=40.2+.2; // the box size beneath any mountings measured beneath the mounting tabs or at the greatest 
                                //length of a tabless servo if there are no tabs, you can leave 
                                //these next two alone or modify them to change the appearance 
                                // of the main bracket around the servo.
function mountingtabthick()=3.2; // the measurement across the small dimension of the tabs.
function mountingtabdepth()=6.8+2; // the tabs here have open holes for the screws. The 2
                                   //allows a bridge so screw holes will be correct.
function mountingtablocation()=27.9; // from the bottom of the servo to the low side of the tab 
                                     // Note that with no tab, you can set this to the height of the servo.
function bracketwebHeight()=2.1; // measure the support thickness, then measure the distance from the top of 
                                 // the web to the bottom of the bracket and subtract mounting bracket thickness
function bracketWebLength()=6;   // measure servo length from flat to flat, then measure from one flat to the web end 
                                 // on the bracket and subtract.
function bracketWebThickness()=1.4; // the thickness of the web measured across the servo width.
function servocollardia()=12.9+.2; // the collar around the servo shaft
function servocollarthick()=1;     // measure the servoheight() without the collar and with the collar.  subtract.

function servoshaftdia()=6.1; // the outer diameter of the knurled shaft
function servoshaftID()=5.61; // measure from the depth of the tooth on each side.
                              //  If an odd number of teeth, you will have a small error, 
                              // but it won't affect fit unless there are fewer than 15 teeth.  
function toothdepth()=.5;  // the depth of a single tooth (measure outer dia and inner dia and subtract the smaller from the larger.
                              // if there are fewer than 15 teeth: take the measurement from the 
                              // tops of the opposing teeth with a micromoter and then move the micrometer movement on one side to the bottom  
                              // of the tooth.  subtract the two measurements and double that for the tooth depth.
function toothcount()=25;  // either count the teeth or check the mechanical drawing.
function mountingscrewdia()=4.6-.2; // measure across mounting screw hole and subtract .2 this allows you to either cut threads or 
                                    // use self threading screws

// The bracket must have a hole for the wire to pass through.  measure the combined
//  connector width.  Note that the connector must pass through the hole.
//  note that the hip assembly requires no hole and the wire is left running up past the servo.
function connwidth()=8.1+.5; // this must pass freely, so add .5
function connthick()=3+.5;  // this must pass freely, so add .5
function strainreliefwidth()=6.3+.5; // if a connector on the servo the width goes here, if wire,
                                     //the potrusion to protect the wire is what is measured.
function strainreliefheight()=5.7+.5; // the corresponding height.
// distance from the center of the shaft to closest servo edge
function shaftlocationL()=8.6;  // measure from far side of shaft to the case and 
                                 // subtract 1/2 the shaft diameter.
function shaftlocationW()=10.2; // from the farside of the shaft to either side and
                      // subtract 1/2 the shaft diameter.  
                      // Note that this depends on the shaft being centered in the servo box.
module servomounttab(){
    union(){
        cube([mountingtabdepth()+.1,servowidth(),mountingtabthick()]);
        translate([-2,servowidth()/2-.86,4.5]){
            rotate([0,30,0]){
                cube([mountingtabdepth()+.1,1.7,2.5]);
            }
        }
    }
}
module servoslotsim(){
    union(){
        cube([servolength(),servowidth(), servoheight()]);
        translate([-mountingtabdepth(),0,mountingtablocation()])
            servomounttab();
        translate([servolength()-.1,0,mountingtablocation()])
            servomounttab();
        }
}
module DS3218Servo(){
            cube([servolength(),servowidth(), servoheight()]);
        translate([0,servowidth(),mountingtablocation()])
            rotate([0,0,180])
            servomounttab();
        translate([servolength()-.1,0,mountingtablocation()])
            servomounttab();
        translate([6.1,servowidth()/2,40.5])
            color("red")
            cylinder(1.9,6.1,6.1,$fn=50);
        translate([6.1,servowidth()/2,42.5])
            color("gray")
            cylinder(4.1,2.9,2.9,$fn=50);
}