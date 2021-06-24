// robotFoot
/* 

Copyright 2020 Howard L. Howell (Les)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/************************************************************
 ** created 2020 HLH
 ** from existing code in mybiped
 ** to add another degree of freedom.
 ***********************************************************/

include </home/lesh/3dprint_things/mybiped/PrintDesign/DS3218mglib.scad>


module dummyservo(){
    // a simulation of the servo body used to check component
    // fit and proportions. 
    union(){
        cube([servolength(),servoheight(), servowidth()]);
        translate([shaftlocationL(),servoheight()+5.9,servowidth()/2])
            rotate([90,0,0])
                cylinder(6,servoshaftdia()/2,servoshaftdia()/2,$fn=60);
        translate([-mountingtabdepth()-.1,mountingtablocation(),0])
            cube([mountingtabdepth(),mountingtabthick(),servowidth()]);
        translate([servolength()-.1,mountingtablocation(),0])
            cube([mountingtabdepth(),mountingtabthick(),servowidth()]);
    }
}

module footservobracket(){
    difference(){
        cube([servolength()+mountingtabdepth()+6,10,servowidth()+6.1]);
        translate([7,-1,-.1])
            cube([servolength(),12,servowidth()+3.1]);
        translate([servolength()+connthick()+3,-.1,servowidth()/2-connwidth()/2+4])
            cube([connthick()+1,12,connwidth()-1]);
        translate([6-2.3,12,6+2.3])
            rotate([90,0,0]) color("red")
                cylinder(21,1.5,1.5,$fn=50);
        translate([6-2.3,12,servowidth()-2.3])
            rotate([90,0,0]) color("red")
                cylinder(21,1.5,1.5,$fn=50);
        translate([servolength()+7.8+2.3,12,6+2.3])
            rotate([90,0,0]) color("red")
                cylinder(21,1.5,1.5,$fn=50);
        translate([servolength()+7.8+2.3,12,servowidth()-1.3])
            rotate([90,0,0]) color("red")
                cylinder(21,1.5,1.5,$fn=50);
    }
}

module pivottrim(){
    // used to get a curve on the ends of pivotingBrackets
    difference(){
        cube([servowidth()+2,2*servoheight()+5,(servowidth()+5)]);
        translate([(servowidth()+2)/2,0,0])
            rotate([-90,0,0])
                cylinder(2*servoheight()+10, (servowidth()+2)/2, 
                         (servowidth()+2)/2,$fn=50);
    }
}
module armsim(){
    // used to simulate the arm to make the arm opening
    // in the various pieces that need it.  Note that the 
    // slope of the shoulder to the clamp circle is independent
    // of any measurement.  You have to use armfit to verify that
    // any change in the arm works correctly.  You achieve this by 
    // changing the rotation angle and size of the cubes, or by 
    // changing the size and position of the block to allow the
    // screw clearance at the axel clamps.
    union(){
        cylinder(armThickness(),
                 armPivotWidth()/2+.2,
                 armPivotWidth()/2+.2,$fn=100);
        // use two cubes to add the taper on the arm at the pivot end
        color("red")
        translate([armPivotWidth()/2*sin(10/armPivotWidth()/2)-5,
                    armPivotWidth()/2-1,0])
            rotate([0,0,-15])
                cube([3,3,armThickness()]);
        // this is the second one.
        color("red")
        translate([armPivotWidth()/2*sin(10/armPivotWidth()/2)+3,
                    armPivotWidth()/2-3,0])
            rotate([0,0,15])
                cube([3,4,armThickness()]);
        // the actual arm part length is +1mm to provide fitment space
        translate([-armSmallWidth()/2+.2,0,0])
            cube([armSmallWidth()+.4,
                  armOverAllLength()-armPivotWidth()/2-armSmallWidth()/2+1,
                  armThickness()]);
        translate([.4,armOverAllLength()-(armPivotWidth()/2)-armSmallWidth()/2+1,0])
            cylinder(armThickness(),(armSmallWidth()+.2)/2,(armSmallWidth()/2)+.2,$fn=100);
        // bolt offsets.  The metal arm has two tension bolts that have to pass into
        // the relief for the arm.
         translate([-armTensionBoltLength()/2,armPivotWidth()/2-4,0])
            color("green")
            cube([armTensionBoltLength()+1, armTensionBoltDia(),armThickness()]);
        
    }
}
module pivotingBracket(){
// fastens to servo horn and fits over the pin on the main bracket to pivot.
    // The depth has to exceed the pivot point by:
    //      mountingtabdepth()+.707*servowidth()+1mm 
    // for clearance when pivoting.
    armthick=bracketthickness()+armThickness();
    clearance=shaftlocationL()+.707*servowidth()+mountingtabdepth()+1;
    pivotdepth=servoheight()+servocollarthick()+2*bracketthickness()+mountingtabdepth();    
    difference(){
        echo ("armthick=",armthick);
        cube([clearance+bracketthickness()+10, 
             servoheight()+2*armthick,
             servowidth()]); // bracket size
        translate([clearance,-5,servowidth()+1])
            rotate([0,90,0])
                pivottrim(); // put the round trim on it.
        translate([bracketthickness(),bracketthickness(),-.1])
            cube([clearance+bracketthickness()+7,
                  servoheight()+servocollarthick()+2*bracketthickness(),
                  servowidth()+1]); // make it a shell
        translate([clearance,-10,servowidth()/2])
            rotate([-90,0,0])
                cylinder(30,
                         servoshaftdia()/2+.1,
                         servoshaftdia()/2+.1,$fn=50); // add the pivot hole opposite the servo shaft.
         if(useArm()){// if a high power servo, use the metal arm
            color("red")
            translate([armOverAllLength(),
                 servoheight()+servocollarthick()+armthick+armThickness()-.1,
                 servowidth()/2])
               rotate([90,-90,0])
                armsim(); // subtract the simulation of the arm from the bracket
            translate([clearance+1,servoheight(),servowidth()/2])
                rotate([0,90,90])
                    color("gray")
                    cylinder(20,1.6,1.6,$fn=50); // add the screw hole for attaching to servo
        }
        else {
            translate([clearance,servoheight()+5*bracketthickness(),servowidth()/2])
                rotate([90,0,0])
                    splineshaft();
        }
    }
}

module pivotpost(){
    union(){
        color("red")
        cube([8,3,servowidth()/2+3+6]);
        translate([4,3,4+servowidth()/2])
            rotate([90,0,0])
                cylinder(7,3,3,$fn=50);
    }
}
module cableperf(){
    cube([9,connthick(),connwidth()]);
}
module Fservobox(pivotstep, nonpivotstep){
    // set pivotsetp and/or nonpivotstep to get the tabs or blocks as your design requires.
    union(){
        difference(){
            //exterior cube
            cube([servolength()+2*mountingtabdepth(),
            mountingtablocation()+4, 
                servowidth()+2*bracketthickness()]);
            // hole for the servo
            translate([mountingtabdepth(),
                       bracketthickness(),
                       bracketthickness()])
                cube([servolength(),mountingtablocation()+2,servowidth()]);
            // hole for the cable to exit the box
            translate([-.1,bracketthickness()+.2,
                       servowidth()/2-connwidth()/2+bracketthickness()])
               cableperf();
            // slot to let the cable strain pass down
            translate([mountingtabdepth()-connthick()+.1,
                             bracketthickness(),
                             servowidth()/2-connwidth()/2+bracketthickness()])
                cube([connthick(),servoheight(), connwidth()]);
            // narrow the box beneath the mounting bracket end nearest the pivot
            if (pivotstep>0){
                translate([-.1,-3,-.1])
                    cube([5,servoheight()-12,servowidth()+10]);
            }
            // narrow the box beneath the mounting bracket on the opposite end
            if (nonpivotstep>0){
                translate([servolength()+mountingtabdepth()+3,-3,-.1])
                cube([9,servoheight()-12,servowidth()+10]);
            }
            // screw holes
            translate([8-2.3,mountingtablocation()+10,6+2.3])
                rotate([90,0,0]) color("red")
                    cylinder(21,1.5,1.5,$fn=50);
            translate([8-2.3,mountingtablocation()+10,servowidth()-2.3])
                rotate([90,0,0]) color("red")
                    cylinder(21,1.5,1.5,$fn=50);
            translate([servolength()+10.8+2.3,mountingtablocation()+10,6+2.3])
                rotate([90,0,0]) color("red")
                    cylinder(21,1.5,1.5,$fn=50);
            translate([servolength()+10.8+2.3,mountingtablocation()+10,servowidth()-1.3])
                rotate([90,0,0]) color("red")
                    cylinder(21,1.5,1.5,$fn=50);
        }
        translate([mountingtabdepth()+shaftlocationL(),0,shaftlocationW()+bracketthickness()])        rotate([90,0,0])
            cylinder(6,servoshaftdia()/2,servoshaftdia()/2+.1,$fn=50);
    }
}

module foot(){
    // during slicing, mirror to get a right foot.
    union(){
        cube([servolength()+70,servoheight()+30,3]);
        translate([0,33,0])
            footservobracket();
        echo(servolength()-shaftlocationL()+3);
        translate([servolength()-shaftlocationL()+10,23+servoheight(),0])
            rotate([0,0,180])
                pivotpost();
    }
}

module shoe(){
    // during operation, for static balance, the foot is not
    //sufficiently long to support the robot.
    union(){
        cube([220,servoheight()+36,3]);
        translate([43,(servoheight()+36)/2-15,0])
            color("gray")
            cube([2,30,4]);
        translate([100,0,0]){
            difference(){
                cube([12,servoheight()+36,9]);
                translate([-1.5,3,3])
                    cube([15,servoheight()+30.4,3.2]);
            }
        }
    }
}

//translate([57,0,27])
//    rotate([0,180,0])
//        Fservobox();

//translate([50,3,3])
// foot();  // right foot

//translate([-50,3,3])
//   mirror([1,0,0]) // Left foot
//        foot();  

//color("red")
//shoe();
//translate([-2.5,0,14])
//    rotate([0,20,0])
//    union(){
//        translate([53,67,73])
//            rotate([0,180,90]) color("red")
//                Fservobox();
//        translate([47.5,57,70])
//            rotate([0,180,90])
//                dummyservo();
//        translate([48,67,47])
//            rotate([0,90,180])
//                pivotingBracket();
//    }
