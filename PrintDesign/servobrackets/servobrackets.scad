// servobrackets.scad
/* 

Copyright 2019 Howard L. Howell (Les)

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

armthick=0;
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
module armfit(){
    // a rectangle with the arm hole in it to check the fit
    difference(){
        cube([armPivotWidth()+6,armOverAllLength()+6,5]);
        translate([armPivotWidth()/2+3,armPivotWidth()/2+3,-.1])
        armsim();
    }
}

module batterycover(){
    union(){
        cube([batlength()+14,batdia()*2+10,2]);
        translate([2.9,2.2,-3]) color("red")
            cube([batlength()+8,1,5]);
        translate([3,2.7,-2])
            rotate([0,90,0])
                cylinder(batlength()+8,1,1,$fn=60);
        translate([2.9,batdia()*2+6.8,-3]) color("red")
            cube([batlength()+8,1,5]);
        translate([3,batdia()*2+7.3,-2])
            rotate([0,90,0])
                cylinder(batlength()+8,1,1,$fn=60);
    }
}

module cableperf(){
    cube([9,connthick(),connwidth()]);
}

module mainbracket(pivotstep, nonpivotstep){
    // set pivotsetp and/or nonpivotstep to get the tabs or blocks as your design requires.
    union(){
        difference(){
            cube([servolength()+2*mountingtabdepth(),
            mountingtablocation()+bracketthickness(), 
                servowidth()+2*bracketthickness()]);
            translate([mountingtabdepth(),
                       bracketthickness(),
                       bracketthickness()])
                cube([servolength(),mountingtablocation()+2,servowidth()]);
            translate([mountingtabdepth()+3, bracketthickness()+3, -.1])
                cube([servolength()-2*bracketthickness(),
                      servoheight()+2,
                      servowidth()+2*bracketthickness()+1]);
            translate([-.1,bracketthickness()+.2,
                       servowidth()/2-connwidth()/2+bracketthickness()])
               cableperf();
            translate([mountingtabdepth()-connthick()+.1,
                             bracketthickness(),
                             servowidth()/2-connwidth()/2+bracketthickness()])
                cube([connthick(),servoheight(), connwidth()]);
            if (pivotstep>0){
                translate([-.1,-3,-.1])
                    cube([5,servoheight()-12,servowidth()+10]);
            }
            if (nonpivotstep>0){
                translate([servolength()+mountingtabdepth()+3,-3,-.1])
                cube([9,servoheight()-12,servowidth()+10]);
            }
        }
        translate([mountingtabdepth()+shaftlocationL(),0,shaftlocationW()+bracketthickness()])        rotate([90,0,0])
            cylinder(6,servoshaftdia()/2,servoshaftdia()/2+.1,$fn=50);
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

//mainbracket(1,0);
//pivotingBracket();