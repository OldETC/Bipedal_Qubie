// shoulderBearing.scad


// designed to remove some of the stress off the shoulder
// servo bearings.
// two parts...
// 1.  the shoulderBearing itself
// 2.  the new shoulderCrank arms
// I may need to modify this to get the arms to swivel by adding
// another servo to get that particular degree of freedom.abs

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
include </home/lesh/3dprint_things/mybiped/PrintDesign/DS3218mglib.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/limg18650.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/raspberrypilib.scad>

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

module pivottrim(){
    // used to get a curve on the ends of pivotingBrackets
    difference(){
        cube([servowidth()+2,2*servoheight()+5,(servowidth()+5)]);
        translate([(servowidth()+2)/2,0,0])
            rotate([-90,0,0])
                cylinder(2*servoheight()+10,(servowidth()+2)/2,(servowidth()+2)/2,$fn=50);
    }
}


module shouldercrank(){
    // an extension of the servo arm to let the arm cross the body
    // with a bearing post to help support the arm by the 
    // shoulder pivot bearing
    union(){
        difference(){
            cube([armPivotWidth()+6,armOverAllLength()+126-mountingtablocation()-bracketthickness(),9]);
            translate([armPivotWidth()/2+3,armPivotWidth()/2+3,-.1])
                armsim();
            translate([armPivotWidth()/2+3.5,armPivotWidth()/2+3,0])
                cylinder(12,1.5,1.5,$fn=50);
            translate([0,10,-2])
                rotate([90,0,0])
                    pivottrim();
             translate([7,71,-.1])
                cube([20,60,10]);
        }
        translate([armPivotWidth()/2+3.5,armPivotWidth()/2+3,8.9]){
            difference(){
                cylinder(6,5.2,5.2,$fn=60);
                translate([0,0,-.1])
                    cylinder(7,3.2,3.2,$fn=60);
                translate([0,0,-.1])
                    cylinder(6,1.6,1.6,$fn=60);
            }
        }
        translate([5,71,0])
            color("red")
            pivotingBracket();
    }
}    
module Lshouldercrank(){
    union(){
        shouldercrank();
        translate([7,95,8])
            rotate([90,0,90]) color("green")
                linear_extrude(2)
                text("L");
    }
}
module Rshouldercrank(){
    union(){
        mirror([1,0,0])
        shouldercrank();
        translate([-7,105,8])
            rotate([90,0,-90]) color("green")
                linear_extrude(2)
                text("R");
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

module cableperf(){
    // used to provide a cable opening.
    cube([9,connthick(),connwidth()]);
}

module rounding(){
    // used to round the ends of the shoulder bearing
    difference(){
        cube([armPivotWidth()+9,armPivotWidth()+9,12]);
        translate([(armPivotWidth()+9)/2,0,-1])
            cylinder(14,(armPivotWidth()+9)/2,(armPivotWidth()+9)/2);
    }
}


module shoulderBearing(){
    // goes over the neck opening, and supports the arms 
    difference(){
        union(){
            cube([155.8,armPivotWidth()+9,9]);
            translate([155.8/2-4.25,-5.9,0]){
                difference(){
                    cube([8.5,6,9]);
                    translate([1.5,2,1])
                        cube([5.5,3.5,9]);
                }
            }
        }
        // bearing hole for arm pivots
        translate([8.45,(armPivotWidth()+9)/2,-.1])
            cylinder(6.1,5.4,5.4,$fn=60);
        translate([151.7-7.45,(armPivotWidth()+9)/2,-.1])
            cylinder(6.1,5.4,5.4,$fn=60);
        // neck hole
        translate([155.8/2,(armPivotWidth()+9)/2+.3,-.1])
            cylinder(10,9.3,9.3,$fn=60);
        // lock screw hole
        translate([155.8/2,5,4.5])
            rotate([90,0,0])
                cylinder(20,1.8,1.8,$fn=60);
    }

}

module neckextension(){
    difference(){
        union(){
            difference(){
                cylinder(20,9.2,9.2,$fn=50);
                translate([0,0,-.1])
                    cylinder(13,7.1,7.1,$fn=50);
            }
            translate([0,0,13]) color("red")
                cylinder(30,7,7,$fn=50);
        }
        translate([0,0,-.1])
            cylinder(55,5.5,5.5,$fn=50);
    }
}

module shoulderswivel(){
    // allow arm to pivot under the shoulder crank.
    // adds another servo to the shoulder unit.
    // this servo to be mounted upright over the shoulder crank
    // with the arm supported under it.  Requires a slot in the
    // shoulder crank to allow the servo mounting.
}
module roundedShoulderBearing(){
    difference(){
        shoulderBearing();
        translate([(armPivotWidth()+9)/2,0,-1])
            rotate([0,0,90])
                rounding();
//        translate([155.8-(armPivotWidth()+9)/2,0,-1])
//            rotate([0,0,270])
//                rounding();
        translate([155.8-(armPivotWidth()+9)/2,
            armPivotWidth()+9,-1])
            rotate([0,0,270])
                rounding();
    }
}

//rounding();
//pivotingBracket();
//translate([0,11,0]) 
//neckextension();
//Lshouldercrank();
//Rshouldercrank();
//roundedShoulderBearing();
        