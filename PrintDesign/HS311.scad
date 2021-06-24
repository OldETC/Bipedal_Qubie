//HS-311 servo from HITech
// openscad will not import variables.
// therefore the variables are declared void in the main code and this routine sets them.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

function setup(){

	bracketthickness=1; // leave this, it determines the bracket strength.
echo ("SU bracket =",bracketthickness);

	/* these next 17 measurements you need to make on your servo to get the right bracket design 
	from this software.  Every type and sometimes manufacturer, has different measurements. */
	servowidth=19.8+.2; // the point 2 allows fitment.
	servoheight=36.3+.2; // the point 2 again for fitment.
	servolength=40.1+.2; // the box size beneath any mountings
	mountingtabthick=3.3; // the measurement across the small dimension of the tabs.
	mountingtabdepth=6.8+2; // the tabs here have open holes for the screws. The 2
		                                    //allows a bridge so screw holes will be correct.
	mountingtablocation=25.9; // from the bottom of the servo to the low side of the tab
	servocollardia=12.9+.2; // the collar around the servo shaft
	servocollarthick=1.4;     // measure the servoheight without the collar and with the collar.  subtract.
	servoshaftdia=5.8; // the od of the knurled shaft
	toothdepth=.15;  // the depth of a single tooth (measure outer dia and inner dia and
		                    // subtract.)
	toothcount=24;  // either count the teeth or check the mechanical drawing.
	mountingscrewdia=4.2; // measure across mounting screw hole and subtract .2

	// The bracket must have a hole for the wire to pass through.  measure the combined
	//  connector width.  Note that the connector must pass through the hole.
	connwidth=7.9+.5; // this must pass freely, so add .5
	connthick=2.4+.5;  // this must pass freely, so add .5
	strainreliefwidth=6.2+.5; // if a connector on the servo the width goes here, if wire,
		                                //the potrusion to protect the wire is what is measured.
	strainreliefheight=4+.5; // the corresponding height.
	// distance from the center of the shaft to closest servo edge
	shaftlocationL=9.8;  // measure from far side of shaft to the case and 
		                         // subtract 1/2 the shaft diameter.
	shaftlocationW=9.7; // from the farside of the shaft to either side and
		                         // subtract 1/2 the shaft diameter.

}

