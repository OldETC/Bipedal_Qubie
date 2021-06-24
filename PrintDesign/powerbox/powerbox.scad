// powercontrol
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
/***********************************************************
 ***********************************************************
This goes with the mybiped.scad file.  Mybiped is my own design for a small humanoid 
robot.  It is a prototype at best, but is to help me learn what it means to create a
bipedal robot with some degree of selfawareness and navigation capability.  I have 
licensed my design under apache so others could use it.  
************************************************************
************************************************************/
// the box will be open top with a vented top to help cool the electronics.
// the electronics will include a switch for power, a fuse to protect the 
// lithium Ion batteries from a short, a DC/DC converter to convert 7.4 volts
// from the batteries to 5v for the PI which will in turn reduce it to 3.3 volts
// for the other associated electronics.abs
include </home/lesh/3dprint_things/mybiped/PrintDesign/limg18650.scad>

dcdcWidth=21.6;
dcdcLength=47.5;
dcdcThick=1.5;

// board slips in the wide way with slots on the narrow sides.abs
module dcdcSlots(){
    difference(){
        cube([3,dcdcWidth,9]);
        translate([2,-1,6])
            cube([5,dcdcWidth+2,1.5]);
    }
    translate([dcdcLength+2,0,0]){
        difference(){
            cube([3,dcdcWidth,9]);
            translate([-4,-1,6])
                cube([5,dcdcWidth+2,1.5]);
        }
    }
}    

module bno055pins(){
    // Mounting Hole dimensions: 22mm x 15.5mm apart
    piStandoff();
    translate([22,0,0])
        piStandoff();
    translate([22,15.5,0])
        piStandoff();
    translate([0,15.5,0])
        piStandoff();
}
module piStandoff(){
    difference(){
        cylinder(9.1,2,2,$fn=50);
        translate([0,0,0])
            cylinder(10,.6,.6,$fn=50);
    }
}

module batteryholder(){
    // 2 batteries on each side of the main body
    // each holder holds 2 batteries in series
    // This is the left side one, which holds the IMU and DC/DC converter
   
    // battery neg hole locations
    battermdiff=batnegdia()-batposdia();
    batneghoriz=batdia()/2-batnegdia()/2+4;
    batneg1vert=8; // 5mm from bottom
    batneg2vert=batdia()-5;
    batposhoriz=batdia()/2+3;
    conholerad=1;
    batpos1vert=batdia()/2-2;
    batpos2vert=batdia()/2+4;
    difference(){
        union(){
            difference(){
                // each slot is 2mm wider than the battery and 
                // 10mm longer for the contact spacing
                cube([batlength()+14,batdia()*2+12,batdia()+5]);
                translate([2,3,3])
                    cube([batlength()+10,batdia()*2+6,batdia()+7]);
            }
            difference(){
                // divider
                translate([0,batdia()+5,3])
                    cube([batlength()+14,2,batdia()]);
                // hole for the lifting ribbon
                translate([(batlength()+14)/2-6,batdia(),17])
                    cube([10,10,2]);
                // pin hole for pinning the ribbon in place.
                translate([(batlength()+14)/2,batdia()+6,4])
                    cylinder(20,.6,.6,$fn=50);
            }
        }
        // contact holes
        // contacts are 3mm button head screws, one end is hard fastened to the case
        // the other is a 10mm long with a spring on it
        // on one end the hard mount on one (+ end) is wired to the spring to put 
        // the batteries in series.  The other end the hard mount goes to a red wire
        // and the other to a black wire to provide the connections to the battery. 
        translate([-1,batdia()/2+2,batdia()/2+3])
            rotate([0,90,0]) 
                cylinder(10,1.75,1.75,$fn=60);
        translate([-1,3*batdia()/2+4,batdia()/2+3])
            rotate([0,90,0]) 
                cylinder(10,1.75,1.75,$fn=60);
        translate([batlength()+10,batdia()/2+2,batdia()/2+3])
            rotate([0,90,0]) 
                cylinder(10,1.75,1.75,$fn=60);
        translate([batlength()+10,3*batdia()/2+4,batdia()/2+3])
            rotate([0,90,0]) 
                cylinder(10,1.75,1.75,$fn=60);
        // the slots for the cover to notch into
        translate([2,1.5,batdia()+2])
            color("red")
            cube([batlength()+10,2,2]);
        translate([2,batdia()*2+8.5,batdia()+2])
            color("red")
            cube([batlength()+10,2,2]);    }
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

module batterytermcover(){
    // a cover for the battery terminals to prevent shorts
    //NEEDED adjust for power box width
    difference(){
        cube([15,2*(batdia()*2+4)+35,batdia()]);
        translate([2,2,-.1])
            cube([15,2*(batdia()*2+4)+31,batdia()-2]);
        translate([10,2,-.1])
            cube([15,2*(batdia()*2+4)+29,batdia()+2]);    }
}


module powerbox(){
    union(){
        difference(){
            // shell
            cube([96,80,29.8]);
            translate([3,3,3])
                cube([90,74,29.8]);
            //2 latch slots for the cover
            translate([3,2,25.8])
                color("gray")
                cube([90,2,2]);
            translate([3,76.15,25.8])
                color("gray")
                cube([90,2,2]);
            // switch hole
            translate([90,39.075,17.4])
                rotate([0,90,0])
                    cylinder(16,3.2,3.2,$fn=50);
            // wiring hole
            translate([80,39.075,-.1])
                rotate([0,0,0])
                    cylinder(6,5.5,5.5,$fn=50);
            // battery wire pass throughs
            translate([90,40,13.4])
                rotate([90,0,0])
                    cylinder(100,2,2,$fn=50);
            // tiewrap holes for additional regulator
            translate([-.1,50,7])
                cube([9,4,3]);
            translate([-.1,50,17])
                cube([9,4,3]);
        }
        translate([2,2.6,dcdcWidth+2])
            rotate([-90,0,0])
                dcdcSlots();
        translate([55,78.2,6])
            rotate([90,0,0])
                bno055pins();
    }
}

module powerboxcover(){
    union(){
        difference(){
            cube([96,80,3]);
            translate([10,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
            translate([14,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
            translate([18,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);    
            translate([36,10,1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("Qubie", font = "Courier:style=Bold Italic",size=16);
            translate([40,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
            translate([44,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
            translate([48,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);        
            translate([52,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
            translate([56,10,-.1])
                rotate([0,0,90])
                linear_extrude(height=4)
                    text("_____", font = "Courier:style=Bold Italic",size=16);
        }
        // two clip rails
        translate([3,3.2,-2])
            cube([90,1,3]); // force fit to box
        translate([3,3.7,-2.8])
            rotate([0,90,0])
                cylinder(90,1,1,$fn=50);
        translate([3,75.5,-2])
            cube([90,1,3]); // force fit to box
        translate([3,76.1,-2.8])
            rotate([0,90,0])
                cylinder(90,1,1,$fn=50);
    }
}

module pwrBattsLhalf(){
    difference(){
        pwrBatts();
        translate([-.1,-61,-.1])
            cube([99,100,30]);
    }
}

module pwrBattsRhalf(){
    difference(){
        pwrBatts();
        translate([-.1,39,-.1])
            cube([99,100,30]);
    }
}
module pwrBatts(){
    union(){
        powerbox();
        translate([0,79.8,0])
            rotate([0,0,0])
                batteryholder();
        translate([0,-48.8,0])
            rotate([0,0,0])
                batteryholder();
    }
}
//difference(){
//    union(){
//        translate([0,0,30]) 
//            rotate([0,0,0])
//                color("red")
//                powerboxcover();
//        powerbox();
//    }
//    translate([-.1,-.1,-.1])
//    cube([10,200,50]);
//}
//pwrBatts();
//pwrBattsLhalf();
//pwrBattsRhalf();
//batterycover();
