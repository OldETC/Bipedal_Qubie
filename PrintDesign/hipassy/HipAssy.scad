// HipAssy.scad
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
include </home/lesh/3dprint_things/mybiped/PrintDesign/shoulderbearing/shoulderbearing.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/servobrackets/servobrackets.scad>

module hipmount(){
    union(){
        color("grey")
        hipmainbracket();
        translate([25,-11.6,0]){
            color("green"){
                difference(){
                    cube([33,12,26.5]);
                    translate([-2,13,13.25])
                        rotate([90,0,0])
                            cylinder(14,14.2,14.2,$fn=50);
                }
            }
        }
    }
}

module hipmainbracket(){
    // this is designed for the DS3218 servo ONLY!!
    difference(){
        mainbracket(0,0);
        translate([-.1,3,-.3])
            cube([6,6,30]);
    }
}
module RightHippivot(){
    // this pivot is designed for extremely close
    // tolerance.  Note that this means there needs to
    // be a slot in the main bracket for the wire to exit.
    // incorporates the hip lateral axis servo mainbracket
    difference(){
        union(){
            difference(){
                union()
                {
                    pivotingBracket();
                    translate([6.5,0,0])
                        cube([3,58,20.5]);
                }
                translate([-13.5,-1,-1])
                    cube([20,60,25]);
                translate([6,15,8])
                    rotate([90,0,90])
                        linear_extrude(height=5)
                            text("right");
            }
            translate([-17,58,26])
                rotate([-90,0,-90])
                color("red")
                mainbracket(0,0);
            translate([8,22,10])
                cube([2,8,2]);
        }
        translate([33,51,11])
            scale([1,1.1,1])
                rotate([0,90,90])
                armsim();
        translate([36,50,2.5])
            cube([20,7,15.5]);
        translate([0,-.01,-.01])
            scale([1.,1.01,1.01])
                pivotbar();
        translate([20,-2,0])
            cube([30,30,30]);
    }
}
module LeftHippivot(){
    difference(){
        union(){
            difference(){
                union()
                {
                    pivotingBracket();
                    translate([6.5,0,0])
                        cube([3,58,20.5]);
                }
                translate([-13.5,-1,-1])
                    cube([20,60,25]);
                translate([8,15,0])
                    rotate([90,0,90])
                        linear_extrude(height=5)
                            text("left");
            }
            translate([9.5,58,-6])
                rotate([90,0,-90])
                color("red")
                mainbracket(0,0);
        }
        translate([33,51,11])
            scale([1,1.1,1])
                rotate([0,90,90])
                armsim();
        translate([36,50,2.5])
            cube([20,7,15.5]);
        translate([0,-.01,-.01])
            scale([1.,1.01,1.01])
                pivotbar();
        translate([20,-2,0])
            cube([30,30,30]);
    }
}  

module pivotbar(){
    difference(){
        pivotingBracket();
        translate([-1,3,-1])
            cube([50,60,30]);
    }
}

module RightHipassy(){
    translate([-27,3,20])
        color("blue")
        hipmount();
    rotate([0,-90,0])
        RightHippivot();

}
module LeftHipassy(){
        translate([-27,3,20])
        color("blue")
        hipmount();
    translate([-20,0,66])
    rotate([0,90,0])
        LeftHippivot();
}
module servoStandoff(){
    difference(){
        cylinder(6.3,2,2,$fn=50);
        cylinder(20,.7,.7,$fn=50);
    }
}

module servomounts(){ 
    // used to set the posts for the servo driver board
    translate([3.202+55.88,3.202,0])
        servoStandoff();
    translate([3.202,3.202,0])
        servoStandoff();
    translate([3.202,19.050+3.202,0])
        servoStandoff();
    translate([3.202+55.88,19.050+3.202,0])
        servoStandoff();
}

module servodrPlate(){ // just a test mount for checking the servo driver mounts
    union(){
        cube([63,25,3]);
        translate([0,0,2.9])
        servomounts();
    }
}

module connectionBox(){
    // servo control boards, hip servos, pivots for the hip joint
    difference(){ // cut off the pivot posts on the servo housings
        union(){
            difference(){
                // these two form the box for the servo controllers
                cube([85.7,81.7,servowidth()+23.7]);
                translate([3,3,3])
                    cube([79.7,74.7,servowidth()+23.7]);
                // hole for wires from the body
                translate([43,77.0,26])
                    cube([15,10,15]);
                // cover mounting holes
                translate([8.1,8.1,servowidth()+20.5])
                    rotate([90,0,0])
                        cylinder(20,1.7,1.7,$fn=50);
                translate([85.7-8.1,8.1,servowidth()+20.5])
                    rotate([90,0,0])
                        cylinder(20,1.7,1.7,$fn=50);
                translate([8.1,79.7+8,servowidth()+20.5])
                    rotate([90,0,0])
                        cylinder(20,1.7,1.7,$fn=50);
                translate([85.7-8.1,79.7+8,servowidth()+20.5])
                    rotate([90,0,0])
                        cylinder(20,1.7,1.7,$fn=50);
            }
            // standoffs for the servo controller
            translate([10.7,10,2.9])
                servomounts();
            translate([10.7,82.7-35,2.9])
                servomounts();  
            translate([0,24,0]){
                // hipservo holders
                translate([-11,-.27,0])
                    rotate([0,0,90]) 
                        hipmount();
                translate([97,-.27,26.5])
                    rotate([180,0,90]) 
                        hipmount();
            }
        }
        translate([-50,70,8])
            rotate([0,90,0])
                color("red")
                    cylinder(200,.875,.875,$fn=50);
        translate([-50,70,18])
            rotate([0,90,0])
                color("red")
                    cylinder(200,.875,.875,$fn=50);
    }
}

module connectionboxcover(){
    union(){
        difference(){
            // cover and slot for servo wires
            cube([85.7,74.7,3]);
            translate([19.35,-.5,-.1])
                cube([49,11,4]);
        }
        // mounting cube with hole
        translate([3.2,3,-7.5]){
            difference(){
                cube([9,8,8.1]);
                translate([5,9,4])
                    rotate([90,0,0])
                        cylinder(servoheight()+5,1.5,1.5,$fn=50);
            }
        }
        // mounting cube with pin for hole that will be blind when box and body mate
        translate([85.7-12,74.7-11,-8]){
            union(){
                cube([8,8,8.1]);
                translate([4,10,4.5])
                    rotate([90,0,0])
                        cylinder(4,1.5,1.5,$fn=50);
            }
        }
    }
}

module LeftHipTilt(){
            difference(){
                union()
                {
                    pivotingBracket();
                    translate([6.5,0,-14])
                        cube([3,58,55.5]);
                }
                translate([-13.5,-1,-1])
                    cube([20,60,25]);
                translate([6,15,8])
                    rotate([90,0,90])
                        linear_extrude(height=5)
                            text("left");
                translate([35,50.6,10.9])
                    rotate([0,90,90])
                     color ("green")
                     scale([1,1,1.03])
                     armsim();
            }
}
module RightHipTilt(){
            difference(){
                union()
                {
                    pivotingBracket();
                    translate([6.5,0,-21])
                        cube([3,58,55.5]);
                }
                translate([-13.5,-1,-1])
                    cube([20,60,25]);
                translate([6,15,8])
                    rotate([90,0,90])
                        linear_extrude(height=5)
                            text("Right");
                translate([35,50.6,10.9])
                    rotate([0,90,90])
                     color ("green")
                     scale([1,1,1.03])
                     armsim();
            }
}
//rotate([0,90,0])
//    LeftHipTilt();
//translate([20.5,-1,0])
//    rotate([0,90,180])
//        RightHipTilt();

//RightHipassy(); // just to visualize the hip assembly.
//RightHippivot(); //  just to prototype the RightHippivot
//pivotbar(); // need 2 of these
//LeftHipassy(); // just to visualize the hip assembly
//LeftHippivot(); // just to prototype the LeftHippivot
//connectionBox(); // need one of these
//servodrPlate();  // just to check the fit of the servo drivers on the posts
//union(){ // to prototype the mount for fit check
//    hipmount(); // just to visualize the mount that will be on the connection box
//    translate([0,-31.5,0])
//       cube([60,20,20]);
//}

