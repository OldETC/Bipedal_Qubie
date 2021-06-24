// petitgripper
// designed for a small humanoid robot
// servo to be inside the bot body to save arm weight and inertia
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


// each element supported by its own pivot and controlled by springs.
// all elements driven simultaneously by a single control, with the springs 
// providing complience
cwidth=7;

module claw(){
    union(){
        scale([1,2,1]){
            difference(){
                cylinder(cwidth,20,20,$fn=50);
                translate([0,0,-1])
                    cylinder(cwidth+2,16,16,$fn=50);
                translate([-2,-40,-1])
                    cube([50,90,cwidth+2]);
            }
        }
        translate([0,-34,0]){
            difference(){
                cylinder(cwidth,6.5,6.5,$fn=50);
                cylinder(cwidth+2,1.5,1.5,$fn=50);
            }
        }
        translate([-1,36,0])
            cylinder(cwidth,4.5,4.5,$fn=50);
        translate([4,-37,0])
            rotate([0,0,0])
                difference(){
                    cube([14,6,cwidth]);
                    translate([10,3,-1])
                        cylinder(cwidth+2,1,1,$fn=50);
                     translate([10,3.5,3.5])
                        rotate([90,0,0])
                            cylinder(cwidth+2,2.75,2.75,$fn=50);               }
    }
}

module clawsupport(){
    difference(){
        union(){
            difference(){
                cube([25.4,20,cwidth*2]); // main bearing block
                translate([-.1,-1,cwidth/2])
                    cube([30,24,cwidth+.2]); // slot for the single 
                translate([12.7,13,-5])
                    cylinder(cwidth*5,1.5,1.5,$fn=50); // claw mount screw hole
            }
            translate([-2,0,-cwidth/2]){
                difference(){
                    translate([0,-6.9,-7])
                        cube([30,7,35]); // platform/base
                    translate([26,2,21])
                        rotate([90,0,0])
                            cylinder(20,.5,.5,$fn=50); // control line hole
                    translate([26,2,-1])
                        rotate([90,0,0])
                            cylinder(20,.5,.5,$fn=50); // control line hole
                    translate([4,2,11])
                        rotate([90,0,0])
                            cylinder(20,.5,.5,$fn=50); // control line hole
                }
            }
        }
        translate([13,-7,7])
            rotate([-90,0,0])
                posthole();
    }
}
module posthole(){
    cylinder(5.1,5.1,5.1,$fn=50); // hole for mounting post
    cylinder(50,1.6,1.6,$fn=50); // hole for mounting post screw
}
module clawmount(){
    difference(){
        union(){
            cylinder(20,5,5,$fn=50);
            translate([-7.5,-7.5,0]){
                cube([15,15,3]);
            }
        }
        translate([0,0,-3])
            cylinder(25,1.5,1.5,$fn=50);
    }
}
//claw();
//rotate([90,0,0])
clawsupport();
//translate([0,0,-30])
//clawmount();