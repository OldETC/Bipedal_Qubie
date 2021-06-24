// mybiped.scad
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

/*****************************************************************
** Created in 2019 
** edited and modified continusously until Jan 2020, when entire frame work
** had been created.  Beginning in Jan 2020 refinements made to make the 
** system actually workable
**  11 Jan  found that the shoulder servos were not entirely
**            stable.  Webbing on
**          servo mount makes it pivot against the frame, and 
**          the support tabs on 
**          the cover were not deep enough to counteract that
**          movement.  Adding notch 
**          in the body to accept the webs, and moving the
**          struts on the cover and making
**          them protrude 6mm deeper into the body to fix that
**          Found pi mounts were not correctly spaced in width.
**          Created piPlate to check that.
**   30 Jan Began breaking some pieces out to their own files. 
**          Powerbox contains the dc/dc converter and its cover
**          is perferated by the name for cooling.  
**          Headassy contains the head and neck stem and the servo
**          mounts for the nod and turn capability.  The face
**          mounts by screws to the headback and holds the video
**          board.  
**   ## Feb added the body cover with hole the head wiring. Added
**          the battery cases and the feet with left/right ankle 
**          pivots. Began to think about grippers.  First design
**          is too big and doesn't work well.
**   5  Mar began printing the modified pieces.  Mods were to make
**          things fit better, allow wire accesses, change mounts
**          for electronics etc. as required for fitment. 
**   6  Mar realized the PI would need cooling.  Designed a fan
**          mount for the body cover. 
**  10  Apr Adding the cooling meant moving the power box to the other 
**          side of the body and changing the passthrough for power and
**          IMU wiring.  It also meant modifying the body cover.  The 
**          Servo wires need more room to pass through the neck and the
**          body to the servo control boards, requiring the hin/connection 
**          box to be redesigned also.
**  22 Jun  Lots of time and redo's.  Widened the body and hipconbox to give 
**          more room for wiring, modified the hip pivot points to make
**          them stronger. Began developing the wrist and gripper design.
**  23 Jun  Designed braces to attach at the hip pivot points to make wiring
**          test and arm control tests easier.
**  17 Apr 21 Changed to use separate hipassy.  part of redesigh for better movement
**            and more space in the connection box.  Also more modular design.
** 20 Apr 21 moved all scad, stl and gcode and subdirectories to ~PrintDesign to
**            simplify the directory structure.
** 1 May 21 updated the loose assembly and the body cover.
*/

// This is my own design and implementation of a framework for a bipedal walking robot.
// It utilizes several servos for motion.  The design is intended for simple modification 
// based upon measurements of the intended servos and compute board.  
// the modifications are all to be made in the header file titled servos.h.
// there are globals initialized there that are utilized throughout this program.
// Software for the robot is not included.  Some examples I have worked on will be available
// on the RSSC website if the club concurs.
// to change the default parameters, copy the HS311.h to a new filename 
// then edit it with the appropriate measurements.
// the variables here are the HS311 measurements.  They are overridden by 
// calling the module setup before calling any of the design elements.
// include </home/lesh/3dprint_things/mybiped/HS311lib.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/DS3218mglib.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/limg18650.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/raspberrypilib.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/headassy/head.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/shoulderbearing/shoulderbearing.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/hipassy/HipAssy.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/powerbox/powerbox.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/foot/robotFoot.scad>
include </home/lesh/3dprint_things/mybiped/PrintDesign/minigripper/myminigripper.scad>


armthick=0;

module fullrobot_loose_assy(){
// to view the robot assembly uncomment the following block
// note that moving the pieces is in fixed coordinates, so when
// you change servo sizes,the pieces will change so their positions have
// to be adjusted by hand.  Sorry I am not good enough to fix this.
// to un comment the block, add two slashes in front of the following
// line, and remove the space in the end block 

    rotate([0,-90,0]){
        color("gray")
        translate([180,47,-47])
            rotate([90,-90,0])
                body();
        color("red")
        translate([-26,0,0])
            rotate([-90,-90,0])
                connectionBox();
    }
    // battery holders sit behind the main body
    translate([-85,47,85])
        rotate([0,-90,-90])
            color("orange")
            pwrBatts();
    
// LEFT LEG
    // hipjoint
            translate([9,5,-22])
                rotate([0,-90,-90])
                    color("green")
                    pivotbar();
            translate([10,5,-22])
                rotate([0,-90,-90])
                    color("green")
                    LeftHippivot();
            translate([60,-5,-58]) //second hip axis
                rotate([0,-90,0])
                    color("red")
                    LeftHipTilt();            
        translate([5,30,-52])
            rotate([0,90,-90])
                pivotingBracket();
      //Knee
        translate([9,32,-68])
            color("red")
            rotate([0,90,-90])
                mainbracket(1,0);
        translate([5,30,-128])
            rotate([0,90,-90])
                pivotingBracket();    
        translate([9,32,-143])
            color("red")
            rotate([0,90,-90])
                mainbracket(1,0);
        translate([10,11,-199])
            rotate([0,90,0])
                pivotingBracket();
        translate([40,14,-219])
            color("green")
            rotate([0,180,0])
                mainbracket(1,0);
         translate([-10,35,-244])
            rotate([0,90,-90])
                pivotingBracket();
       translate([55,60,-292])
            color("blue")
            rotate([0,0,90])
                mirror([1,0,0]) // Left foot
                foot();
            
            
 // RIGHT LEG
 translate([-94,22,-17]){
             translate([-2,-20,0])
                rotate([0,-90,-90])
                    color("yellow")
                    pivotbar();
             translate([0,0,0])
                rotate([0,-90,90])
                    color("green")
                    RightHippivot();
             translate([-30,-30,-37])
                rotate([0,-90,0])
                    color("red")
                    RightHipTilt();
 }     
    translate([-89,13.5,-47])
        rotate([0,90,90])
            pivotingBracket();
    translate([-93,10,-63])
        color("red")
        rotate([0,90,90])
            mainbracket(1,0); // Thigh 
    translate([-89,13.5,-123])
        rotate([0,90,90])
            pivotingBracket();
    translate([-93,11,-138])
        color("red")
        rotate([0,90,90])
            mainbracket(1,0);
    translate([-113,8,-194])
        rotate([0,90,0])
            pivotingBracket();
    translate([-121,11,-241])
        color("green")
        rotate([0,0,0])
            mainbracket(1,0);
     translate([-68,11,-239])
        rotate([0,90,90])
            pivotingBracket();
   translate([-134,60,-287])
        color("blue")
        rotate([0,0,-90])
            foot();
            
// HEAD and NECK
    translate([-80,60,220])
        rotate([0,0,-90])
            headback();
    translate([-42,23,240])
        rotate([0,180,0])
            stem();
            
    // right arm
        translate([60,0,0])
        {
            translate([-40,30,185])
                color("red")
                rotate([0,0,-90])
                    shouldercrank();
            translate([35,10,212])
                color("yellow")
                rotate([180,90,90])
                    mainbracket(1,0);
            translate([35,7,153])
                rotate([0,90,-90])
                    color("blue")
                    pivotingBracket();
            translate([40,10,140])
                color("red")
                rotate([180,90,90])
                    mainbracket(1,0);
        }
    // left arm
    translate([-100,50,0]){
        rotate([0,0,180]){
            mirror([1,0,0])
            translate([0,20,185])
                color("blue")
                rotate([0,0,90])
                    shouldercrank();
            translate([77,73,212])
                color("red")
                rotate([180,90,90])
                    mainbracket(1,0);
            translate([70,73,155])
                rotate([0,90,-90])
                    pivotingBracket();
            translate([75,75,139])
                color("red")
                rotate([180,90,90])
                    mainbracket(1,0);
        }
    }
}
/*******************************************
************ assyend **********************
********************************************/    

// the main bracket goes around the servo just below mounting tab
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


module toothspike(){
    shaftid2=servoshaftID()/2;
    toothbase=2*shaftid2*PI/toothcount();
    angle=asin(toothdepth()/toothbase);
//    echo("angle=",angle);
//    echo("toothdepth=",toothdepth());
//    echo("toothbase=",toothbase);
    translate([-toothbase/2,0,0]){
        difference(){
            cube([toothbase,shaftid2+toothdepth(),10]);
            translate([0,shaftid2,-1])
                rotate([0,0,angle])
                    cube([toothbase+.1,toothdepth(),12]);  
            translate([toothbase/2,shaftid2+toothdepth(),-1])
                rotate([0,0,-angle])
                    cube([toothbase+.1,toothdepth(),12]);  

          }
    }
}

module splineshaft(){
     shaftid=servoshaftID();
    toothbase=shaftid*PI/toothcount();
    degree=360/toothcount();
    union(){
       for(i=[0:1:toothcount()]){
            rotate([0,0,i*degree]) toothspike();
        }
    }
}

module cableperf(){
    cube([9,connthick(),connwidth()]);
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

module chkcollett(){
    // print one of these to check that the collet design really works on  your servo
    union(){
        rotate([0,90,0]){
            difference(){
                cube([10,20.1,3]);
                translate([5,5,0])
                    splineshaft();
            }
        }
        translate([0,17,-10])
            rotate([0,0,90])
                cube([3,20,10]);
    }
}

module tabs(){
    // fixing an error in first box print
    // tabs to glue inside cover that is straight fit
    cube([80,12.7,2]);
}



module piStandoff(){
    standoff(3.1,1.15);
}

module screwpost(){
    // a post designed to receive an m2 self threading screw.
    difference(){
        color("red")
        cylinder(4,2.5,2.5,$fn=50,center=true);
        translate([0,0,-0.5])
            cylinder(7,1,1,$fn=50,center=true);
    }
}


module body(){ // designed to hold a raspberry pi 4 and 
               //shoulder servos
    union(){
        difference(){
            // 1 june added 1/2 in in all dimensions
            cube([2*servolength()+4*mountingtabdepth()+62.7,
                servoheight()+piWidth()+24.7,
                servowidth()+26.7]);
            translate([3,3,3])
                cube([2*servolength()+4*mountingtabdepth()+56.7,
                    servoheight()+piWidth()+18.7,
                    servowidth()+26.7]);
            // openings for the shoulder servos
            translate([mountingtabdepth()+3.1,
                        mountingtablocation()+mountingtabthick()+3.1,
                        servowidth()/2+3.1])
                rotate([90,0,0])
                    servoslotsim();
            translate([servolength()+3*mountingtabdepth()+59.7,
                        mountingtablocation()+mountingtabthick()+3.1,
                        servowidth()/2+3.1])
                rotate([90,0,0])
                    servoslotsim();
            // neck opening()
            translate([2*mountingtabdepth()+servolength()+32.35,4,
                        (servowidth()+26.7)/2])
                rotate([90,0,0])
                    cylinder(7,5.5,5.5,$fn=50);
            // power wiring hole
            translate([2*mountingtabdepth()+servolength()+32.35,
                       20,-.1])
                rotate([0,0,0])
                    cylinder(7,5.5,5.5,$fn=50);            

            // screwholes for the fastening
            translate([-3,mountingtabthick()+12,22])
                rotate([0,90,0])
                    cylinder(30,1.6,1.6,$fn=50);
            translate([2*servolength()+4*mountingtabdepth()+40,
                       mountingtabthick()+12,22])
                rotate([0,90,0])
                    cylinder(30,1.6,1.6,$fn=50);
            translate([-3,servoheight()+piWidth()+13.7,22])
                rotate([0,90,0])
                    cylinder(30,1.6,1.6,$fn=50);
            translate([2*servolength()+4*mountingtabdepth()+40,
                       servoheight()+piWidth()+13.7,22])
                rotate([0,90,0])
                    cylinder(30,1.6,1.6,$fn=50);            
                    // simcard access
            translate([130,servoheight()+15+18,9])
                cube([24,13,6]);
           // wiring access to hip module note that this has to match up.
            translate([2*mountingtabdepth()+servolength()+32,
                        servoheight()+piWidth()+15.7,10])
                cube([15,10,15]);
        }
        //neck 
        translate([2*mountingtabdepth()+servolength()+32.35,4,
                        (servowidth()+26.7)/2]){
            rotate([90,0,0]){
                difference(){
                    cylinder(17,7,7,$fn=50);
                    translate([0,0,-1])
                        cylinder(19,5.5,5.5,$fn=50);
                }
            }
        }
        translate([piLength()+24,
                   servoheight()+15,
                   2.9])
            PImounts();
        //June 1 2020 added reinforcement for neck
        translate([2*mountingtabdepth()+servolength()+23,
                    2.9,2.9])
            cube([3,10,servowidth()+23.7]);
        translate([2*mountingtabdepth()+servolength()+38,
                    2.9,2.9])
            cube([3,10,servowidth()+23.7]);
        // reinforcement for the servos
        translate([2,1,10])
            cube([2*servolength()+95,5,3]);
        translate([2,1,servowidth()+14])
            cube([2*servolength()+95,5,3]);
        // servo support
        translate([13,10,2]) color("red")
            cube([servolength()-2,16,11]);
        translate([servolength()+87,10,2]) color("red")
            cube([servolength()-2,16,11]);    }
}

module servosupport(){
    color("red"){
        difference(){
            cube([mountingtabdepth()-1.7,mountingtablocation()-13,servowidth()+22.7]);// 13 was 10
            translate([-1,8,28.2])// 8 was 11.
                rotate([0,90,0])
                    cylinder(20,1.3,1.3,$fn=50);
        }
    }
}

module fanscrews(){
    cylinder(6,1.8,1.8,$fn=60);
    translate([24.5,0,0])
        cylinder(6,1.8,1.8,$fn=60);
    translate([24.5,24.5,0])
        cylinder(6,1.8,1.8,$fn=60);
    translate([0,24.5,0])
        cylinder(6,1.8,1.8,$fn=60);
}    
module oval(){
    scale([1,3,1])
        cylinder(7,2,2,$fn=60);
}

module grill(){
    scale([.8,.8,1]){
        oval();
        translate([-8,19,0])
            rotate([0,0,45])
                oval();
        translate([-8,3,0])
            rotate([0,0,-45])
                oval();
        translate([-10,11,0])
            rotate([0,0,90])
                oval();    
        translate([10,11,0])
            rotate([0,0,90])
                oval(); 
        translate([8,3,0])
            rotate([0,0,45])
                oval();    
        translate([8,19,0])
            rotate([0,0,-45])
                oval();   
        translate([0,21,0])
                oval();   
    }
}
module bodycover(){
//    echo((2*servolength()+4*mountingtabdepth()+22.7));
    difference(){
        union(){
            cube([2*servolength()+4*mountingtabdepth()+62.7,
                servoheight()+piWidth()+24.7,
                3]);
            // servo mount blocks.  No screws needed due to clamping action.
            translate([3.1,mountingtabthick()+4.1,0])
                servosupport();
            translate([servolength()+mountingtabthick()+8,
                        mountingtabthick()+4.1,0])
                servosupport();
            translate([2*mountingtabdepth()+servolength()+59.7,
                        mountingtabthick()+4.1,0])
                servosupport();
            translate([2*servolength()+3*mountingtabdepth()+59.7,
                        mountingtabthick()+4.1,0])
                servosupport();
            // locator bits
            difference(){
                translate([2*servolength()+3*mountingtabdepth()+59.7,
                        servoheight()+piWidth()+5,0])
                    servosupport();
                translate([2*servolength()+3*mountingtabdepth()+18.7,
                        servoheight()+piWidth()+4,32])
                    cube([20,20,20]);
            }
            difference(){
                translate([3.2,servoheight()+piWidth()+5,0])
                    servosupport();
                translate([2.2,servoheight()+piWidth()+4,32])
                    cube([20,20,20]);
            }
        }
        translate([150,77,-1])
            rotate([0,0,22.5])
                grill();
        translate([35,77,-1])
            rotate([0,0,22.5])
                grill();    
        translate([20,73,-1])
            fanscrews();
        
        translate([92.5,47,-1])
            rotate([0,0,22.5])
                scale([1.5,1.5,1])
                grill();    
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
module armfit(){
    // a rectangle with the arm hole in it to check the fit
    difference(){
        cube([armPivotWidth()+6,armOverAllLength()+6,5]);
        translate([armPivotWidth()/2+3,armPivotWidth()/2+3,-.1])
        armsim();
    }
}

module standoff(r1,r2){
    difference(){
        cylinder(8,r1,r1,$fn=50);
        translate([0,0,0])
            cylinder(10,r2,r2,$fn=50);
    }
}
module checkmounts(){ // check what size is needed to bind a raspberry pi
                      // and the servo boards.abs
    union(){
        cube([10,100,2]);
        translate([5,5,0])
            standoff(5,.5);
        translate([5,17.7,0])
            standoff(4,.6);
        translate([5,30.4,0])
            standoff(4,.7);
        translate([5,43.1,0])
            standoff(4,.8);
        translate([5,55.8,0])
            standoff(4,.9);
        translate([5,68.5,0])
            standoff(4,1);
        translate([5,81.2,0])
            standoff(4,1.1);
        translate([5,93.9,0])
            standoff(4,1.2);
    }
}

module PImounts(){
    // used to set the precise locations of the pi's pins relative to each other
        translate([0,0,0]) //one corner at origin
            piStandoff();
        translate([0,piScrewHoleWidth(),0])
            piStandoff();
        translate([piScrewHoleLength()-.5,0,0])
            piStandoff();
        translate([piScrewHoleLength()-.5,piScrewHoleWidth(),0])
            piStandoff();
}

module piPlate(){ // just a test mount for checking the pi mounts
    union(){
        cube([piLength(),piWidth()+piFlangeOffset(),3]);
        translate([piScrewHoleEnd()+piFlangeOffset(),piScrewHoleLoc(),2.90])
            PImounts();
    }
}

module rulerPt1mm(){
    union(){
        cube([160,2,2]);
    for (dy=[0:.2:160]) {
        translate([dy,1,1.9])
                cube([0.1,2,0.5]);
        }
    for (dy=[0:.5:160]) {
        translate([dy,1,1.9]) color("green")
                cube([0.05,2.5,0.5]);
        }
    for (dy=[0:1:160]) {
        translate([dy,1,1.9]) color("red")
                cube([0.05,2.75,0.5]);
        }
    for (dy=[0:10:160]) {
        translate([dy,1,1.9]){
            color("BLUE")
            cube([0.05,3,0.5]);
            color("blue")
            translate([0,0,.2])
            linear_extrude(height=.5)
                text(str(dy),size=2);
            }
        }
    }
}
module pivotMount(){
    difference(){
        cube([25,8,15]);
        translate([12.5,16,11])
            rotate([90,0,0])
                cylinder(20,1.8,1.8,$fn=50);
    }
}




/****************************************************************/
/********** Gazebo simulation parts *****************************/
/****************************************************************/
// Body and power box together for simulation

module gazeboBody(){
    union(){
        body();
        translate([178,00,50])
            rotate([0,180,00])
                color("blue")
                bodycover();
        translate([128,100,-.1])
            rotate([0,180,90])
                color("blue")
                pwrBatts();
        translate([47,5,-30])
            rotate([0,180,-90])
                color("red")
                powerboxcover();
        translate([129,20,-23])
            rotate([0,180,-90])
                color("green")
                batterycover();
        translate([0,20,-23])
            rotate([0,180,-90])
                color("green")
                batterycover();
        translate([90,0,23])
            rotate([90,0,0])
                neckextension();
        translate([12,-10,10])
                    rotate([90,0,0])
                        color("brown")
                        roundedShoulderBearing();
         translate([46,205,50])
            rotate([180,0,0])
                color("red")
                connectionBox();
         translate([146,173,47])
            rotate([-90,0,-90])
                color("lightblue")
                DS3218Servo();
         translate([32,173,27])
            rotate([-90,180,90])
                color("lightblue")
                DS3218Servo();
         //Shoulder servos
         translate([12,34,12])
            rotate([-90,180,180])
                color("lightblue")
                DS3218Servo();
          translate([166,34,34])
            rotate([-90,0,180])
                color("lightblue")
                DS3218Servo();    }
}

module gazeboHead(){
    union(){
        headback();
        translate([85,65,10])
            rotate([0,-90,180])
                color("blue")
                displaysim();
        translate([90,77,0])
            rotate([0,0,180])
                face();
        translate([50,40,20])
            rotate([0,180,90])
                stem();
    }
}
module gazebobracketpair(){
    // pivoting bracket and mainbracket with servo
    union(){
        mainbracket();
        translate([10,3,servowidth()+3])
            rotate([-90,0,0])
                color("green")
                DS3218Servo();
        translate([58,-6,3])
            rotate([0,0,0])
                color("red")
                pivotingBracket();
    }
}
module gazeboLefthiptiltassy(){
    rotate([0,-90,0])
    LeftHipTilt();
        translate([-45,35,7])
            rotate([0,90,-90])
                color("red")
                pivotingBracket();
}
module gazeboRighthiptiltassy(){
    rotate([0,-90,0])
    RightHipTilt();
        translate([23,20,7])
            rotate([0,90,90])
                color("red")
                pivotingBracket();
}    

module gazeboLeftHipPivot(){
    union(){
        LeftHippivot();
        translate([-servowidth()+6,servolength()+9,3])
            rotate([0,0,-90])
                color("gray")
                DS3218Servo();
        translate([0,0,0])
                rotate([0,0,0])
                    color("green")
                    pivotbar(); 
    }
}
module gazeboRightHipPivot(){
    union(){
        RightHippivot();
        translate([+6,servolength()+9,23])
            rotate([0,180,90])
                color("gray")
                DS3218Servo(); 
        translate([0,0,0])
                rotate([0,0,0])
                    color("green")
                    pivotbar(); 
    }
}

module gazeboLeftAnkleRoll(){
    rotate([0,90,-90]){
        union(){
            color("red")
            mainbracket();
            translate([10,3,servowidth()+3])
                rotate([-90,0,0])
                    color("gray")
                    DS3218Servo();
            translate([58,3,33])
                rotate([-90,0,0])
                    pivotingBracket();
        }
    }
}
module gazeboRIghtAnkleTilt(){
    union(){
        translate([53,67,73])
            rotate([0,180,90]) color("red")
                Fservobox();
        translate([47.5,57,70])
            rotate([0,180,90])
                dummyservo();
        translate([28,7,47])
            rotate([0,90,0])
                pivotingBracket();
    }
}

module gazeboLeftAnkleTilt(){
    mirror([0,1,0])
        gazeboRIghtAnkleTilt();
}

module gazeboRightAnkleRoll(){
    mirror([0,1,0])
        gazeboLeftAnkleRoll();
}

module gazeboLeftFoot(){
    union(){
        foot();
        translate([48,61,24])
            rotate([90,180,0])
                color("gray")
                DS3218Servo();
    }
}
module gazeboRightFoot(){
    mirror([0,1,0])
        gazeboLeftFoot();
}
module gazeboServoBlock(){
    DS3218Servo();
}

module gazeboMyMiniGripper(){
    union(){
         fullbase();
    }
}
module gazeboRightShoulderCrank(){
    mirror([0,1,0])
        shouldercrank();
}
module gazeboLeftShoulderCrank(){
        shouldercrank();
}

module gazeboServoNbracket(){
    union(){
        DS3218Servo();
        translate([-10,23,-3])
            rotate([90,0,0])
                mainbracket();
    }
}
/*******************************************/        
//these are the tests for the pieces
/*******************************************/
/*************************************/
/******** useful ruler ***************/
//translate([0,0,0])
//    rotate([0,0,90])
//        rulerPt1mm();
/*************************************/
//pivotMount();
//piStandoff();
//tabs();
//cranktab(); 
//roundedCube(100,80,60);
//splineshaft();
//toothspike();
//chkcollett();
//armsim(); // the blank for the arm to subtract from objects
//armfit();   // check that the actual arm will fit into the space
//pivottrim(); // round off the ends of the pivots for radius space
//servosupport();
//checkmounts();
//PImounts(); // set the mounting pin locations for a raspberry pi.
//servomounts(); // set the mounting pins for the servo drivers
//piPlate();  // check PI post spacing spacing
//bno055plate();
//servoslotsim(); // the simulation of the servo neck used to make the holes for the shoulders


/****************************************************************/
/****************** actual robot parts  ********************/
/****************************************************************/
// actual robot parts.  Use these once you are sure all the various bits work with 
// the servos and electronics you are going to use.
// render only one of these at a time for export as an stl file.
                        
//mainbracket(1,0); // one for each limb segment holds the servo
//pivotingBracket(); // one of these for each limb segment affected by armsim
// the difference is used to verify the servo block spacing
//difference(){
// this union is needed for the covered view only.
//    union(){
//        body(); // modify the body for your designs processor & power control
// the translation and rotation are used to verify fit 
//    translate([178.7,0,50])
//        rotate([0,180,0])
//           bodycover();
//    } // only needed to close the union to slice the overall fitment test
// the difference cutblock to verify the support spacing for the servo supports
//    translate([-2,-.5,20])
//        cube([200,15,60]);}
// add in the shoulder bearing to check fit
//    translate([12.0,-10,11.4])
//        rotate([90,0,0])
//            color("blue")
//            shoulderBearing();
// add in the neck stim to check fit
//    translate([90,-50,23.6])
//        rotate([-90,0,0])
//            color("red")
//            stem(); 
//translate([46,204,50])
//    rotate([0,180,180]) color("red")
//        connectionBox(); // box for servo controllers and hip servos
//Box(50,50,50); // square head box
//pwrBatts();

/* test fit battery to contacts
translate([7,batdia()/2,batdia()/2])
    rotate([0,90,0])
        cylinder(batlength(),batdia()/2,batdia()/2,$fn=50);
        translate([4,batdia()/2,0])
                battcontact();
        translate([batlength()+10,batdia()/2+4,0])
            rotate([0,0,180])
                battcontact();
*/
/**********************************************************************/
/************  simulated assembly ************************************/
/*********************************************************************/
//translate([300,0,0])
//
//fullrobot_loose_assy();


/*********************************************************************
************* GAZEBO Models ******************************************/
//gazeboBody();
//gazeboHead();
//DS3218Servo();
//translate([6.1,servowidth()/2,44])
//    armsim();
//gazeboLeftFoot();
//gazeboRightFoot();
//gazeboLeftHipPivot();
//gazeboRightHipPivot();
//gazebobracketpair();
//gazeboLefthiptiltassy();
//gazeboRighthiptiltassy();
//gazeboLeftAnkleRoll();
//gazeboRightAnkleRoll();
//gazeboRIghtAnkleTilt();
//gazeboLeftAnkleTilt();
//gazeboMyMiniGripper();
//gazeboServoBlock();
//gazeboRightShoulderCrank();
//gazeboLeftShoulderCrank();
gazeboServoNbracket();
/*********************************************************************/
/* to build the robot you need the following:
    1 head (box(50,50,50) or as you have designed
    1 nectstem
    1 spinplatform
    3 platform clamps
    1 headtilt lever
    1 headtilt spacer
    2 sg90servoboxes
    2 short length of piano wire (to connect servo horns to spin and nod levers
    1 neck extension 
    1 neck closure
    1 body
    1 bodycover
    1 powerbox
    1 powerboxcover
    2 batterycovers
    1 connectionBox
    1 lefthiptilt
    1 rightHiptilt
    1 lefthippivot
    1 righthippivot
    2 pivotbar
    8 mainbrackets
    8 pivoting brackets
    2 miniclaw/servomounts
    2 miniclaw/pivotplates
    2 miniclaw/pivotplatecaps
    2 miniclaw/pivotcaps
    
    10 appropriately sized servos at least 15kgcm torque faster is better.
        (set the measurements to match your servo's.)
    The box will eventually be designed to hold batteries and computer(s) as needed.
    Note that each servo may draw more than 3A under load.  Don't be stingy with battery size, and then size the servos and batteries to work together.
    12 appropriately sized screws.  Holes are 3mm, so they would need to be threaded or
    you could use nuts on each screw except the long through holes for the leg brackets would need either threaded rod or 3mm filament as the pivot.
*/
