// myminigrip.scad
/*****************************************************
 ** based on the minigripper in thingiverse:
 ** https://www.thingiverse.com/thing:4243097
 ** This thing was created by Thingiverse user Alarik72,
 ** and is licensed under cc-nc-sa.
 ** reduced in size with new claw design which will
 ** take silicon pads pasted onto them.
 ** shrunk about 1/3 in size to match my robot.
 *****************************************************/
include </home/lesh/3dprint_things/mybiped/PrintDesign/SG90lib.scad>
shell=2;
module claw(){
    difference(){
        scale([.75,.6,.6]){
            union(){
                import("./temp/files/Claw.stl",convexity=7);
                translate([-29,0,-5])
                    cube([30,3.5,10]);
                translate([-29,9.3,-5])
                    cube([30,3.5,10]);
            }
        }
        translate([-3,9,0])
            rotate([90,0,0])
                cylinder(10,2.1,2.1,$fn=50);
        translate([-18,9,0])
            rotate([90,0,0])
                cylinder(10,2.1,2.1,$fn=50);    }
}
module fullbase(){
    union(){
        difference(){
            union(){
                import("./temp/files/Base_AR2.stl",convexity=20);
                // eliminate the original screw holes
                translate([-18,0,-10])
                    cube([6,13,6]);
                translate([-18,0,4])
                    cube([6,13,6]);
            }
            // truncate the front edge
           translate([-21,-1,-20])
                cube([5,15,60]);
            // truncate the back
            translate([30,-1,-30])
                cube([35,35,60]);
            // add the screw holes for the claw arms
            translate([-12,15,4.2])
                rotate([90,0,0])
                    color("red")
                    cylinder(18,2.2,2.2,$fn=50);
            translate([-12,15,-4.2])
                rotate([90,0,0])
                    color("red")
                    cylinder(18,2.2,2.2,$fn=50);
        }
        // wrist lower support wall
        translate([29,0,-22])
            cube([3,13,12.3]);
        // wrist base support
        translate([29,0,-10])
            cube([14.5,2,5]);
        // writes upper support wall
        translate([29,0,16]) 
            cube([3,13,6]);
        // wrist base support
        translate([29,0,11.5]) 
            cube([14.5,2,5]);
        // box for wrist servo
        translate([25,1,-10])
            rotate([90,0,90])
                servoMount();
    }
}
module servoConGear(){
    difference(){
        union(){
            difference(){
                import("./temp/files/Servo_Connector_Gear.stl",convexity=20);
                translate([24.5,-3,-5])
                    cube([100,10,10]);
            }
            translate([24.5,2,0])
                rotate([90,0,0])
                    cylinder(4,4,4,$fn=50);
        }
        translate([24.5,3,0])
            rotate([90,0,0])
                cylinder(6,2.2,2.2,$fn=50);
    }
}
module ConGear(){
    difference(){
        union(){
            difference(){
                import("./temp/files/Connector_Gear.stl",convexity=20);
                translate([24.5,-3,-5])
                    cube([100,10,10]);
            }
            translate([24.5,2,0])
                rotate([90,0,0])
                    cylinder(4,4,4,$fn=50);
        }
        translate([24.5,3,-.75])
            rotate([90,0,0])
                cylinder(6,2.1,2.2,$fn=50);
    }
}
module connector(){
    difference(){
        union(){
            cube([7.8,34.4,3.5]);
            translate([3.9,0,0])
                cylinder(3.5,3.9,3.9,$fn=50);
            translate([3.9,34.4,0])
                cylinder(3.5,3.9,3.9,$fn=50);
        }
        translate([3.9,0,-1])
            cylinder(5,2.1,2.1,$fn=50);
        translate([3.9,34.4,-1])
            cylinder(5,2.1,2.1,$fn=50);
    }
}
module siliconrecess(){
    union(){
        cylinder(3,1.3,1.3,$fn=50);
        translate([0,0,3])
            sphere(2,$fn=50);
    }
}
module myclaw(){
    difference(){
        union(){
            translate([0,-3,0])
                cube([25,10,10]);
            translate([19,-2,0])
                rotate([0,0,-25])
                    cube([40,17,10]);
        }
        // split for connectors
        translate([-1,-4,3.2])
            cube([27,23,3.6]);
        // holes for connector screws
        translate([4,2,-1])
            cylinder(20,2.1,2.1,$fn=50);
        translate([19.3,2,-1])
            cylinder(20,2.1,2.1,$fn=50);
        //
        translate([0,4,0]){
            // shape the gripper angle
            translate([19,-27,-1])
                cube([50,20,12]);
            // sharpen the nose a bit
                translate([66,-15,-1])
                rotate([0,0,45])
                    cube([10,10,12]);
            //lighten it with holes
            translate([53.5,-5,-1])
                cylinder(15,1,1,$fn=50);
            translate([47.5,-4.5,-1])
                cylinder(15,1.5,1.5,$fn=50);
            translate([40,-3.5,-1])
                cylinder(15,2,2,$fn=50);
            translate([30,0,-1])
                cylinder(15,4.5,4.5,$fn=50);
            translate([45,4,-1])
                rotate([0,0,-15])
                scale([1.1,.9,1])
                    cylinder(15,6,6,$fn=50);
        }
        translate([58,-2.5,-1]) color("red")
            cube([1,1,12]);
        translate([55,-1,-1]) color("red")
            cube([1,1,12]);
        translate([52,0.5,-1]) color("red")
            cube([1,1,12]);        
        translate([49,2,-1]) color("red")
            cube([1,1,12]);
        translate([46,2,-1]) color("red")
            cube([1,1,12]);
        translate([43,2.2,-1]) color("red")
            cube([1,1,12]);
        translate([40.5,3.4,-1]) color("red")
            cube([1,1,12]);
        translate([39,5.2,-1]) color("red")
            cube([1,1,12]);
        translate([36,8,-1]) color("red")
            cube([1,1,12]);
        translate([34,9,-1]) color("red")
            cube([1,1,12]);
        translate([32,10,-1]) color("red")
            cube([1,1,12]);
        translate([30,10.7,-1]) color("red")
            cube([1,1,12]);
        translate([28,11.5,-1]) color("red")
            cube([1,1,12]);
    }
 }
module servoMount(){
    // a box to hold a servo as described in the library.
    difference(){
        cube([SG90servowidth()+2*shell,
            SG90servolength()+2*shell,
            SG90mountingtablocation()+shell]);
        //hole for the servo body
        translate([shell,shell,shell-.1]){
            cube([SG90servowidth(),
                  SG90servolength(),
                  SG90mountingtablocation()+shell]);
        // cuts down the sides 
        translate([-3,shell+1,shell-.1])
            cube([SG90servowidth()+4*shell,
                    SG90servolength()-6,
                    SG90mountingtablocation()+shell]);
        translate([(SG90servowidth()+2*shell)/2-cablewidth(),-shell-.1,cableheight()])
            cube([cablewidth(),3,SG90servoheight()]);
        }
    }
}
module servoWristCover(){
    difference(){
        cube([SG90servowidth()+4*shell+2,
            SG90servolength()+4*shell,
            SG90mountingtablocation()+shell+10]);
        translate([shell,shell,shell+.1]){
            cube([SG90servowidth()+2*shell+2,
                  SG90servolength()+2*shell,
                  SG90mountingtablocation()+2*shell+10]);
        }
        translate([-.1,2*shell,2*shell+.1]){
            cube([SG90servowidth()+5*shell+2,
                  SG90servolength(),
                  SG90mountingtablocation()+10]);
        }
        translate([(SG90servowidth()+4*shell)/2,
                    SG90shaftlocationL()+2*shell,-1])
            cylinder(4,5.4,5.4,$fn=60);
    }
}
module armtemplate(){
    union(){
        cylinder(2.5,3.75,3.75,$fn=50);
        linear_extrude(height=2.5)
        polygon(points= [[-3.4,0],
                        [-3.0,7.9],
                        [3.0,7.9],
                        [3.4,0],
                        [3.0,-7.9],
                        [-3.0,-7.9],
                        [-3.4,0]]);
    }
}

module pivotplate(){
    // mates to the servo horn
    difference(){
        union(){
            cylinder(4,7.8,7.88,$fn=50);
            cylinder(9.2,3,3,$fn=50);
        }
        translate([0,0,-.1])
            armtemplate();
        }
}
module pivotplatecap(){
    //glues to the arm
    // fits over the pivotplate
    difference(){
        cylinder(2,7.8,7.8,$fn=50);
        translate([0,0,-1])
            cylinder(4,3.75,3.75,$fn=50);
    }
}

module mountingPlate(){
    // holds the arm in the plate
    difference(){
        union(){
            cube([50,25,3]);
            translate([25,12.5,0])
                cylinder(3+shell+.2,5.1,4.9,$fn=50);
        }
        translate([25,12.5,-.1])
            cylinder(8,3.2,3.2,$fn=50);
    }
}

module minigripperassy(){
    fullbase();
    translate([-8,15,15])
        rotate([0,-150,0]) color ("red")
        ConGear();
    translate([-41,17,25])
        rotate([90,120,0])
            connector();
    translate([-25,21,31])
        rotate([90,157,0]) color("green")
            myclaw();
    translate([-43,17,-18])
        rotate([90,60,0])
            connector();
    translate([-8,15,-12])
        rotate([0,150,0]) color("blue")
            servoConGear();
    translate([-25,10,-31])
        rotate([-90,210,0])
            myclaw();
}

module gazebogripperbase(){
    fullbase();
    translate([-3,-14,-2])
        rotate([-90,0,0]) color("gray")
            SG90();
     translate([27,3,14])
        rotate([0,90,0]) color("gray")
            SG90();   
     translate([61,-2,18])
        rotate([-90,0,90]) color("red")
            servoWristCover();
     translate([56,8,8])
        rotate([-90,0,-90]) color("green")
            pivotplate();
}

//TEST for SUBASSEMBLIES
//servoMount();
//minigripperassy();

//GAZEBO parts
//gazebogripperbase();


//ACTUAL PARTS
//pivotplate();
//translate([25,-12.5,9.2])
//    rotate([0,180,0]) color("red")
//        mountingPlate();
//pivotplatecap();
//myclaw();
//fullbase();
//servoConGear();
//ConGear();
//connector();
//servoWristCover();
