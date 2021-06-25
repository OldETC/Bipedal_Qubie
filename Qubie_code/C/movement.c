// qubie.c
// a bipedal robot driver

/* 
Copyright 2020 Howard L. Howell (Les) (LesH)

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

/**********************************************
 **  Servo allocations
 *********************************************/
#define left 0    // the Left side of the body being referenced
#define right 16  // the right side of the body being referenced.
// left side servos
#define leftshoulder   0
#define lefttopjoint   1
#define leftelbow      2
#define leftwrist      3
#define leftgrip       4
#define leftpelvis     5
#define lefthip        6
#define leftknee       7
#define leftfootrot    8
#define leftfootpitch  9
#define reserved0     10
#define reserved1     11
#define reserved2     12
#define reserved3     13
#define nod           14
#define turn          15
// right side is on second servo driver
#define rightshoulder  16 
#define righttopjoint  17
#define rightelbow     18
#define rightwrist     19
#define rightgrip      20
#define rightpelvis    21
#define righthip       22
#define rightknee      23
#define rightfootrot   24
#define rightfootpitch 25
#define reserved4      26
#define reserved5      27
#define reserved6      28
#define reserved7      29
#define reserved6      30
#define reserved7      31


/*****************************************************************************************************
 ***  NOTE!!! All servo control and positions are set in microseconds.  Angles in degrees are calculated
 ***  based on liner interpolation from the min, zero and max conditions.
 *****************************************************************************************************/

float step_hip_tilt=16; // the number of degrees of hip tilt to get the body center over that foot.
float max_step_hip=20;  // the degree swing of the hip joint for a full step
int stepcount;          // the number of steps in a specific direction
int steptarget;         // the target for the current direction
float reldir;           // the direction relative to the origiinal pose
int currentstep=0;      // the move is either -1 for left step, 0 for stopped (default), 1 for right step
int nextstep=0;         // prediction used to help control acceleration and balance
float mapposition[3];   // where the robot's left foot is on the map.  
float currentpose[32];  // facing direction as 0,5 for each arm, 5 for each leg, 2 for the head position;

/********************************************************************************************************
 **  servo starting positions
 ********************************************************************************************************/
float startpose[32]={1500,1450,1560, 1200, 1200, // left shoulder, bicep, elbow, wrist turn, grip neutral
		     1500,1520,1500,1450, 1450,  // left hip, thigh,knee, foot roll, foot pitch
		        0,   0,   0,   0,        // reserved
                      1200, 1200,                // head nod, turn
		      1500,1450,1560,1200,1200,  // right shoulder, bicep,elbow,wrist turn, grip neutral
		      1450,1460,1500,1450,1500,  // right hip, thigh, knee, foot roll, foot pitch
		         0,   0,   0,   0,   0,  // reserved
                       0};            // reserved
float servosetup[32]= {1500,1450,1560, 1200, 1200, // left shoulder, bicep, elbow, wrist turn, grip neutral
		     1500,1520,1500,1450, 1450,  // left hip, thigh,knee, foot roll, foot pitch
		        0,   0,   0,   0,        // reserved
                      1200, 1200,                // head nod, turn
		      1500,1450,1560,1200,1200,  // right shoulder, bicep,elbow,wrist turn, grip neutral
		      1450,1460,1500,1450,1500,  // right hip, thigh, knee, foot roll, foot pitch
		         0,   0,   0,   0,   0,  // reserved
                       0};            // reserved
/********************************************************************
 ** servo movement limits in degrees mandated by hardware design
 *******************************************************************/
float servomin[32]={ 500, 600, 600, 500, 500, // left shoulder, bicep, elbow, wrist turn, grip neutral
                    1388, 600, 700,1338,1117, // left hip, thigh,knee, foot roll, foot pitch
                       0,   0,   0,   0,      // reserved
                     500, 500,                // head nod, turn
                     500, 500, 600, 500, 500, // right shoulder, bicep,elbow,wrist turn, grip neutral
                    1338, 700, 600, 1338,1117,// right hip, thigh, knee, foot roll, foot pitch
		      0,  0,  0,  0,  0,  0,  // reserved
			};

float servomax[32]={2500,2300,2400,2500,2500,    // left shoulder, bicep, elbow, wrist turn, grip neutral
                    1611,2200,2200,1560,1780,    // left hip, thigh,knee, foot roll, foot pitch
                      0,  0,  0,  0,  0,    // reserved
                    1700,2200,                // head nod, turn
                    2500,2300,2500,2500,2500,    // right shoulder, bicep,elbow,wrist turn, grip neutral
                    1500,2200,2200,1560,1780,    // right hip, thigh, knee, foot roll, foot pitch
		      0,  0,  0,  0,  0,  0,// reserved
			};
/********************************************************************
 ** a step is made by tilting the body over the opposing foot, then 
 ** moving the foot forward and the opposing arm reward to maintain balance
 ** The step is complete when the opposing foot is moved rearward, lowering
 ** forward foot to the ground. As the opposing foot pushes off, the opposing arm 
 ** swings forward to continue the balance, the two hips rotate, moving the center
 ** of the body over the current foot as the opposing knee lifts the opposing foot
 ** and brings it forward.  The step is completed when the opposing foot is parallel
 ** to the step foot and the next step can start, or the body can be brought upright
 ** and both feet planted for a stopped position.  Note that acceleration MUST be 
 ** controlled for the next position to continue smoothly.
 *********************************************************************/

int startstep(foot, percent,speed){ // a full step is about 4", and so the percentage can be negative and is set to reduce or increase that, speed is in percent.
	// foot is either 0 or 16.  The pelvis is foot+5, the hip joint is foot+6, the knee is foot+7, footrotation is foot+8, foot pitch is foot+9
	// defining these this way allows the one function to perform both side steps
	// the start step is different from the moving step because the opposite foot is still directly under the body.  The stepping foot is 
	// lifted by tilting the body over the opposite foot.  angling the step side knee and hip to some degree lifting the foot off the floor.
	// then the knee joint is rotated back to 135 and the opposite arm is rotated to -step to help balance the robot.
	// This step is finished by setting the foot down by rotating the body back upright, moving the opposing arm back to neutral,
	// moving the opposing leg hip joint to the rear by the step size as the opposing pelvis rotates back to normal and the body moves over 
	// over the stepped leg.  The stepped pelvis may have to move a bit to manage this.
	if (0==foot) OPpelvis=rightpelvis;
	else OPpelvis=leftpelvis;
	if (16==foot) OPfoot=0;
	else OPfoot=16;
	set_servo(OPpelvis,120); // tilt the body over the opposite foot, lifting the step foot.
	sleep(0.04); // wait for the move
	set_servo(foot+6,120);   // move the hip joint to put the foot out by 15 degrees.  The knee is still straight.
	set_servo(foot+9,150); // pitch the foot to make it flat.
	sleep(0.04);
	set_servo(OPpelvis,135); // put the foot down by tilting the body back to neutral.
	set_servo(foot+5,120);  // rotate the pelvis to put the weight over the forward foot.
	sleep(0.04);
	set_servo(OPfoot+6,150); // flex opposite hip to pushoff
	set_servo(OPfoot+9,150); // flex the foot to push off
	sleep(0.04);
	set_servo(foot+6,135); // flex the foot and hip to move the body forward over the extended leg
	set_servo(foot+9,135);
	sleep(0.04); 
}


	


