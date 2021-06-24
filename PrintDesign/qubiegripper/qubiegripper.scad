//RobotHand.scad
/* 

Copyright 2021 Howard L. Howell (Les)

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

/**************************************************************/
/** design criteria *******************************************/
/**************************************************************
1.  use sg90 servos.
2.  have sufficient compliance to prevent burn out
3.  be somewhat capable of picking up small objects
4.  3 degrees of freedom
    a. rotate
    b. bend up to 90 degrees
    c. open/close
5.  hopefully open enough to pick up legos and pens/pencils.abs
*****************************************************************/

include </home/lesh/3dprint_things/mybiped/PrintDesign/SG90lib.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/headassy/head.scad>

HR=1.7; // hole radius for connectors

module hinge(){
    difference(){
        union(){
            cylinder(18,3,3,$fn=50);
            translate([-1.3,-5,0])
                cube([4.4,4,18]);
        }
        translate([0,0,-1])
            cylinder(20,HR,HR,$fn=50);
    }
}
module wrist(){
    union(){
        translate([19,15,0])
            rotate([0,-90,90])
                servobox();
        translate([23.5,14,0])
            rotate([0,-90,0])
                servobox();
        //strengthen the wristbox
        translate([2,0,0])
            cube([3,14,23.5]);
        translate([19,0,0])
            cube([3,14,23.5]);
        // pivot for the fold
        translate([20,32.5,20.4])
            rotate([0,-90,0])        
                hinge();
    }
}


module newbaseplate(){
        union(){
            translate([0,0,0])
                rotate([0,0,90])
                    servobox();
            difference(){
                translate([-19,24,20])
                    rotate([90,-90,0])
                        scale([1.0,1.0,1.35])
                            hinge();
                 translate([-24,2.5,16]) color("red")
                    cube([8,18.5,8]);
            }
            translate([-1,0,18]){
                difference(){
                    union(){
                        difference(){
                            cube([30,23,11]);
                            translate([-.1,5,-.1])
                                cube([21,13,12]);
                        }
                         translate([21,7,4.9]){
                            difference(){
                                color("red")
                                cube([12,8,13]);
                                translate([-1,1,9])
                                    cube([14,6,3.2]);
                            }
                        }
                    }
                    translate([27,2.5,-.1])
                        cylinder(14,1.5,1.5,$fn=50);
                     translate([27,20.5,-.1])
                        cylinder(14,1.5,1.5,$fn=50);               }
            }
            translate([0,0,18])
                cube([5,23,5]);
        }
}

module newgripper(){
    // use piano wire in claws to provide sprint relief against
    // dual sided cam and grip as 1mmxlength supported at sharp end
    // only to provide grip compliance
    newbaseplate();
}

module newcompliantClaw(){
        union(){
            difference(){
                color("green")
                cylinder(6,44.45,44.45,$fn=60);
                translate([0,11,-.1])
                    cylinder(7,50,50,$fn=60);
                translate([30,-30,-.1])
                    cube([20,20,8]);

            }
            translate([25,-35,0]){
                rotate([0,0,-50]){
                    difference(){
                        union(){
                            cube([24,7,6]);
                             translate([22,3.5,0])
                                    cylinder(10,1.5,1.5,$fn=50);
                        }
                    translate([5,3.5,-.1])
                        cylinder(7,HR,HR,$fn=50);
                    }
                }
            }

            difference(){
                union(){
                    translate([-40,-20,0])
                        rotate([0,0,-10])
                            cube([67,.75,6]);
                    translate([19,-36,0])
                        rotate([0,0,-10])
                            cube([7,5,6]);
                }
            }
        }
}

module armconnector(){
    difference(){
        union(){
            cube([6,61,3]);
            translate([-10,0,0])
                cube([25,8,3]);
        }
        translate([3,16,-.1])
            cylinder(6,HR,HR,$fn=60);
        translate([-8,2,-.1])
            cube([21,4,4]);
    }
}
module clawconnector(){
    difference(){
        cube([5,26,2]);
        translate([2.5,3.5,-.1])
            cylinder(6,HR,HR,$fn=60);
        translate([2.5,23.3,-.1])
            cylinder(6,HR,HR,$fn=60);
        translate([0,0,1])
            cube([5,10,2]);
    }
}

module wristmount(){
    difference(){
        cube([40,20,5]);
        translate([20,10,-.1])
            cylinder(4,5,5,$fn=60);
    }
}

module wristdrive(){
    difference(){
        union(){
            cylinder(8,7,7,$fn=60);
            cylinder(15,4.8,4.8,$fn=60);
        }
       translate([0,0,0])
            SG90armtemplate();
    }
}


module wristcover(){
    difference(){
        cube([18.5,23,21]);
        translate([2,-1,-.1])
            cube([14.6,25,18]);
        translate([8.5,16.7,17])
            cylinder(20,5,5,$fn=60);

    }
}
module armtrim(){
    difference(){
        translate([-4.15,0,.1])
            cube([8.3,8.3,4]);
        cylinder(5,4.15,4.15,$fn=60);
    }
}
module arm(){
    difference(){
        cube([8,20,3]);
        translate([4,5,-3])
            rotate([0,0,0])
                SG90armtemplate();
        translate([4,5,0])
            rotate([0,0,0])
                cylinder(10,.6,.6,$fn=60);
        translate([4,18,-.1])
            cylinder(10,HR,HR,$fn=60);
        translate([4.14,15.85,-.1])
            armtrim();
     }
}

module connectorpin(){
    union(){
        cylinder(2,5,5,$fn=50);
        cylinder(5,.5,.5,$fn=60);
    }
}

module connectorsocket(){
    union(){
        cylinder(2,5,5,$fn=50);        
        difference(){
            cylinder(5,1.5,1.5,$fn=50);
            cylinder(5,.6,.6,$fn=50);
        }
    }
}

//connectorpin();
//translate([0,0,10])
//    rotate([0,180,0])
//        connectorsocket();

//arm();
//difference(){
//    union(){
 
//    translate([-7,-20.,7])
//       rotate([90,0,0]) color("blue")
//            wristmount();

//        translate([12,-8.7,17])
//        rotate([90,0,0]) color("red")
 //           wristdrive();
//
//    translate([4,1.2,0.5])
//        rotate([90,0,0])
//           wristcover();
//    }
//
//    translate([-10,-60,0])
//        cube([20,100,100]);
//}

translate([-52,22.5,0])
    rotate([0,0,-90])
        wrist();

// gripper frame
newgripper();

translate([-1,0,1])
    rotate([0,0,90])
        color("blue")
             SG90();

translate([-1,14,32])
    rotate([0,0,-90])
        armconnector();
    
translate([12,8,35.5]) color("purple")
    rotate([0,0,0])
       clawconnector();

translate([12,14,37.5]) color("green")
    rotate([180,0,0])
       clawconnector();

translate([62,-12,29.5])
   rotate([0,0,187])
       newcompliantClaw();


translate([62,35,29.5])
    rotate([0,0,-7])
        mirror()
        newcompliantClaw();

/*
// measurement lines
translate([-40,10.5,29.5])
    cube([200,.5,3]);
translate([-40,30.5,29.5]) color("green")
    cube([120,.5,3]);
translate([-7,5,29.5]) color("red")
    rotate([0,0,180])
    cube([13,.5,3]);
 //translate([-8,10.5,34]) color("purple")
 //   rotate([0,0,30])
 //  cube([20,.5,3]);
 translate([89,10.5,28]) color("black")
    rotate([0,0,90])
    cube([43,.5,3]);
*/    

 
/*
        translate([-1,-1.2,1])
            rotate([0,0,90])
                color("red")
                SG90();
translate([9,10,29])
    rotate([0,0,0]) color("blue")
        clawconnector();
translate([9.5,-.5,29])
    rotate([0,0,58]) color("gray")
*/
//clawconnector();


 
 //               wrist();
//                   hinge();
/*
translate([44,0,0])
            rotate([0,-90,-90])
                color("red")
                    SG90();
        translate([58,18,0])
            rotate([0,-90,180])
                color("red")
                    SG90();
*/
/*
    translate([23,27.5,22])
        rotate([180,90,0])
            color("green")
            SG90();

translate([23.7,71.5,24]){
    rotate([0,180,90]){
        translate([0,0,0])
            rotate([0,0,0])
                newgripper();

        translate([5,7,-14])
            rotate([0,0,0])
                color("red")
                SG90();
    }
}
*/
//cam();
/*
//parts that didn't work
translate([12,12,14])
    rotate([0,0,15])
        cam();
module compliantClaw(){
    difference(){
        union(){
            difference(){
                color("green")
                cylinder(6,44.45,44.45,$fn=60);
                translate([0,11,-.1])
                    cylinder(7,50,50,$fn=60);
                translate([30,-30,-.1])
                    cube([20,20,8]);

            }
            translate([25,-35,0]){
                rotate([0,0,-30]){
                    difference(){
                        cube([44,10,6]);
                        translate([8,4,-.1])
                            cube([30,6,8]);
                    translate([5,5,-.1])
                        cylinder(7,1.6,1.6,$fn=50);
                    }
                }
            }
            difference(){
                union(){
                    translate([-40,-20,0])
                        rotate([0,0,-20])
                            cube([52,.5,6]);
                    translate([0,-40.5,0])
                        rotate([0,0,-20])
                            cube([7,5,6]);
                }
            }
        }
    translate([25,-26,3])
        rotate([0,90,-30])
            cylinder(200,.5,.5,$fn=50);
    }
}

translate([-49,16,14])
    rotate([0,0,30]) color("green")
        compliantClaw();

translate([-49,10,18])
    rotate([180,0,-30]) color("green")
        compliantClaw();
*****  An experiment that moved off center of the pivot
module baseplate(){
    difference(){
        union(){
            cube([35,26,3]);
            translate([-10,0,0])
                rotate([0,0,0])
                    cube([40,6.8,13]);
            translate([-10,19.2,0])
                rotate([0,0,0])
                    cube([40,6.8,13]);
            difference(){
                translate([39,26,3])
                    rotate([90,90,0])
                        scale([1.0,1.0,1.45])
                            hinge();
                translate([36,22,6])
                    rotate([90,90,0])
                        cube([6,6,18.5]);
            }

        }
     //servo opening
    translate([5,7,0])
        rotate([0,0,0])
            color("red")
            scale([1.03,1.03,1.03])
                SG90();
     //expand the sidewall opening for the mounting plates
       translate([0,7,3])
            cube([SG90mountingtabdepth(),SG90servowidth()*1.03,
                20]);
       translate([(SG90servolength()+SG90mountingtabdepth()),7.3,3])
            cube([SG90mountingtabdepth(),SG90servowidth(),
                20]);    
    //screwholes for the claw mountings
    translate([-5,3,-1])
        rotate([0,0,0]) color("green")
            cylinder(20,1.5,1.5,$fn=50);
    translate([-5,23,-1])
        rotate([0,0,0]) color("green")
            cylinder(20,1.5,1.5,$fn=50);
    }
}

module gripper(){
    // use piano wire in claws to provide sprint relief against
    // dual sided cam and grip as 1mmxlength supported at sharp end
    // only to provide grip compliance
    baseplate();    
}

module camgroove(){
    difference(){
        scale([1,6/15,1])
            cylinder(.5,15.1,15.1,$fn=60);
        scale([1,6/15,1])
            cylinder(.5,14,14,$fn=60);
    }
}
module cam(){
    difference(){
        scale([1,6/15,1])
            cylinder(6,15,15,$fn=60);
        translate([0,0,-1])
            rotate([0,0,90])
                SG90armtemplate();
        cylinder(10,1,1,$fn=50);
        translate([0,0,2.75])
            camgroove();
    }
}



*/