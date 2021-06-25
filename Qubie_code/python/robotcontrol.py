""" RobotControl.py
    the joints are assigned to two servo driver boards
    They start at the top of the chest.  
    shoulder, bicep, elbow, wrist, claw, hip, thigh, knee, ankelroll anklepitch.
    The head nod and turn are in to top two slots for the right side.
"""
""" Apache license"""
"""
Copyright 2020 H. L. Howell

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""
import time
from adafruit_servokit import ServoKit
from board import SCL, SDA
import busio
from adafruit_pca9685 import PCA9685
from array import *
#import numpy as nmp

#the global parameters for controlling the joints.
shoulder=0
bicep=1
elbow=2
wrist=3
grip=4
hip=5
thigh=6
knee=7
ankleroll=8
anklepitch=9

LEFT=0x41
RIGHT=0x40

headnod=13
headturn=14

#setup for working ranges for servos in degrees enforced by hardware design
# follows the servo numbers used for the joints
ranges= [
# default  min  max minPW maxPW range     el# side designation
    [135,   105, 270, 500,  2500, 270], #  0 right shoulder
    [217,     9, 270, 500,  2500, 270], #  1 right bicep
    [135,     0, 270, 500,  2500, 270], #  2 right elbow
    [135,     0, 180, 500,  2500, 180], #  3 right wrist
    [ 33,    33, 100, 500,  2500, 180], #  4 right grip
    [135,   125, 144, 500,  2500, 270], #  5 right hip
    [135,   125, 144, 500,  2500, 270], #  6 right thigh
    [135,     0, 270, 500,  2500, 270], #  7 right knee
    [135,   125, 159, 500,  2500, 270], #  8 right foot roll
    [135,    92, 192, 500,  2500, 270], #  9 right foot pitch
    [  0,     0,   0,   0,     0,   0], # 10 reserved
    [  0,     0,   0,   0,     0,   0], # 11 reserved
    [  0,     0,   0,   0,     0,   0], # 12 reserved
    [ 90,     0, 180, 500,  2500, 180], # 13 head nod
    [ 90,     0, 180, 500,  2500, 180], # 14 head turn
    [  0,     0,   0,   0,     0,   0], # 15 reserved
    [135,   105, 270, 500,  2500, 270], # 16 left shoulder
    [217,     9, 270, 500,  2500, 270], # 17 left bicep
    [135,     0, 270, 500,  2500, 270], # 18 left elbow
    [135,     0, 180, 500,  2500, 180], # 19 left wrist
    [ 20,     0,  75, 500,  2500, 180], # 20 left grip
    [135,   125, 144, 500,  2500, 270], # 21 left hip
    [135,     0, 270, 500,  2500, 270], # 22 left thigh
    [135,     0, 270, 500,  2500, 270], # 23 left knee
    [135,   125, 159, 500,  2500, 270], # 24 left foot roll
    [135,    92, 192, 500,  2500, 270], # 25 left foot pitch
    [  0,     0,   0,   0,     0,   0], # 26 reserved
    [  0,     0,   0,   0,     0,   0], # 27 reserved
    [  0,     0,   0,   0,     0,   0], # 28 reserved
    [  0,     0,   0,   0,     0,   0], # 29 reserved
    [  0,     0,   0,   0,     0,   0], # 30 reserved
    [  0,     0,   0,   0,     0,   0], # 31 reserved
]

#creating the instances of the control software
# Set channels to the number of servo channels on your kit.
# 8 for FeatherWing, 16 for Shield/HAT/Bonnet.
# Set the PWM frequency to 200.
Left = ServoKit(channels=16,address=LEFT)
Right= ServoKit(channels=16,address=RIGHT)

def setup():

    Left.PWMfrequency=200
    j=0;
# setup the PCA code for the servo controlls.
    for i in range (0,15):
        Right.servo[i].set_pulse_width_range(ranges[j][3],ranges[j][4])
        Right.servo[i].actuation_range=ranges[j][5]
        Left.servo[i].set_pulse_width_range(ranges[j+16][3],ranges[j+16][4])
        Left.servo[i].actuation_range=ranges[j+16][5]
        j=j+1
#        print ('j=',j,'\n')

setup()
#right shoulder
#Right.servo[shoulder].angle=135


#print ('anklepitch=',anklepitch,anklepitch+16,'\n');
jnum=0
while 1:
    side=input('side:')
    if side=='q':
        break
    joint=input('joint:')
    if joint=='q':
       break
    elif joint=='shoulder':
        jnum=0
    elif joint=='bicep':
        jnum=1
    elif joint== 'elbow': 
        jnum=2
    elif joint=='wrist': 
        jnum=3
    elif joint=='grip': 
        jnum=4
    elif joint=='hip': 
        jnum=5
    elif joint=='thigh': 
        jnum=6
    elif joint=='knee': 
        jnum=7
    elif joint=='ankleroll': 
        jnum=8
    elif joint=='anklepitch': 
        jnum=9
        print("jnum:",jnum,"\n")
    elif joint=='nod':
        jnum=13
        side='right'
    elif joint =='turn':
        jnum=14
        side='right'
    else:
        break
    angle=input ('angle:')
    if angle=='q':
       break
    if side=='right':
        Right.servo[jnum].angle=int(angle)
        print ("moved Right\n")
    elif side=='left':
        Left.servo[jnum].angle=int(angle)
        print ("moved Left\n")
    print ("side:",side,"jnum:",jnum,"angle:",angle,"\n")
