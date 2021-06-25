// HS311lib.scad

//HS-311 servo from HITech
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

/* these next 17 measurements you need to make on your servo to get the right bracket design 
from this software.  Every type and sometimes manufacturer, has different measurements. */
function servowidth()=19.8+.2; // the point 2 allows fitment. measured across the narrowest dimension of the servo
function servoheight()=36.3+.2; // the point 2 again for fitment. measured from the bottom of the servo to the flat behind the horn
function servolength()=40.1+.2; // the box size beneath any mountings measured beneath the mounting tabs or at the greatest 
                                //length of a tabless servo if there are no tabs, you can leave 
                                //these next two alone or modify them to change the appearance 
                                // of the main bracket around the servo.
function mountingtabthick()=3.3; // the measurement across the small dimension of the tabs.
function mountingtabdepth()=6.8+2; // the tabs here have open holes for the screws. The 2
                                            //allows a bridge so screw holes will be correct.
function mountingtablocation()=25.9; // from the bottom of the servo to the low side of the tab 
                                     // Note that with no tab, you can set this to the height of the servo.
function servocollardia()=12.9+.2; // the collar around the servo shaft
function servocollarthick()=1.4;     // measure the servoheight() without the collar and with the collar.  subtract.

function servoshaftdia()=5.8; // the outer diameter of the knurled shaft
function servoshaftID()=5.65; // measure from the depth of the tooth on each side.
                              //  If an odd number of teeth, you will have a small error, 
                              // but it won't affect fit unless there are fewer than 15 teeth.  
function toothdepth()=.15;  // the depth of a single tooth (measure outer dia and inner dia and subtract the smaller from the larger.
                              // if there are fewer than 15 teeth: take the measurement from the 
                              // tops of the opposing teeth with a micromoter and then move the micrometer movement on one side to the bottom  
                              // of the tooth.  subtract the two measurements and double that for the tooth depth.
function toothcount()=24;  // either count the teeth or check the mechanical drawing.
function mountingscrewdia()=4.4-.2; // measure across mounting screw hole and subtract .2 this allows you to either cut threads or 
                                    // use self threading screws

// The bracket must have a hole for the wire to pass through.  measure the combined
//  connector width.  Note that the connector must pass through the hole.
//  note that the hip assembly requires no hole and the wire is left running up past the servo.
function connwidth()=7.9+.5; // this must pass freely, so add .5
function connthick()=2.4+.5;  // this must pass freely, so add .5
function strainreliefwidth()=6.2+.5; // if a connector on the servo the width goes here, if wire,
                                     //the potrusion to protect the wire is what is measured.
function strainreliefheight()=4+.5; // the corresponding height.
// distance from the center of the shaft to closest servo edge
function shaftlocationL()=9.8;  // measure from far side of shaft to the case and 
                                 // subtract 1/2 the shaft diameter.
function shaftlocationW()=9.7; // from the farside of the shaft to either side and
                      // subtract 1/2 the shaft diameter.  
                      // Note that this depends on the shaft being centered in the servo box.
