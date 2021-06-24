// gripperWrist.scad
/******************************************************
  A gripper designed for mybiped prototype humanoid robot
  it rotates and has a pincer type grip.
********************************************************/
/***********************************************
  materials:
    3d prints of these parts
    3mm screws and nuts
    2 mini sg90 servos (may be different but affects design)
    some silicon sealant to improve the grip.
    some glue for your chosen plastic.
*******************************************************/
include </home/lesh/3dprint_things/mybiped/PrintDesign/SG90lib.scad>
// a shell thickness to use
shell=1.0; 
module servoMount(){
    // a box to hold a servo as described in the library.
    difference(){
        cube([SG90servowidth()+2*shell,
            SG90servolength()+2*shell,
            SG90mountingtablocation()+shell]);
        translate([1,1,1.1]){
            cube([SG90servowidth(),
                  SG90servolength(),
                  SG90mountingtablocation()+shell]);
        translate([-2,3,3])
        cube([SG90servowidth()+4*shell,
            SG90servolength()-6,
            SG90mountingtablocation()+shell]);
        translate([(SG90servowidth()+2*shell)/2-cablewidth()/2,-2,cableheight()])
            cube([cablewidth(),3,SG90servoheight()]);
        }
    }
}

module dualServoMount(){
    union(){
        servoMount();
        translate([SG90servowidth()+1.95*shell,
                   SG90servoheight()+1.95*shell,0]){
            rotate([90,0,0]){
                servoMount();
            }
        }
    }
}
module armtemplate(){
    union(){
        cylinder(1.5,3.75,3.75,$fn=50);
        linear_extrude(height=2.5)
        polygon(points= [[-3.5,0],
                        [-3.1,7.9],
                        [3.1,7.9],
                        [3.5,0],
                        [3.1,-7.9],
                        [-3.1,-7.9],
                        [-3.5,0]]);
    }
}

module pivotplate(){
    difference(){
        union(){
            cylinder(4,7.8,7.88,$fn=50);
            cylinder(8.2,3,3,$fn=50);
        }
        translate([0,0,-.1])
            armtemplate();
        }
}
module pivotplatecap(){
    difference(){
        cylinder(2,7.8,7.8,$fn=50);
        translate([0,0,-1])
            cylinder(4,3.75,3.75,$fn=50);
    }
}

module pivotcap(){
    difference(){
        union(){
            cylinder(2,7.8,7.8,$fn=50);
            cylinder(4.2,5.1,5.1,$fn=50);
        }
        translate([0,0,-1])
            cylinder(6,3.2,3.2,$fn=50);
    }
}

module pivotcheck(){
    difference(){
        translate([-15,-10,0])
            cube([30,20,2]);
        translate([0,0,-1])
            cylinder(4,5.4,5.4,$fn=60);
    }
}

//servoMount();
//armtemplate();

//dualServoMount();
pivotplate();
// pivotplatecap();
//translate([0,0,4.2])
//    rotate([0,180,0])
//        color("red")
//        pivotcap();
//pivotcheck();
//pivotcap();
