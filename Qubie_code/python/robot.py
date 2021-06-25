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
    [130,   105, 270, 500,  2500, 270], #  0 right shoulder
    [217,     9, 270, 500,  2500, 270], #  1 right bicep
    [135,     0, 270, 500,  2500, 270], #  2 right elbow
    [ 90,     0, 180, 500,  2500, 180], #  3 right wrist
    [ 70,    33, 100, 500,  2500, 180], #  4 right grip
    [142,   125, 144, 500,  2500, 270], #  5 right hip
    [135,   125, 144, 500,  2500, 270], #  6 right thigh
    [140,     0, 270, 500,  2500, 270], #  7 right knee
    [150,   125, 159, 500,  2500, 270], #  8 right foot roll
    [150,    92, 192, 500,  2500, 270], #  9 right foot pitch
    [  0,     0,   0,   0,     0,   0], # 10 reserved
    [  0,     0,   0,   0,     0,   0], # 11 reserved
    [  0,     0,   0,   0,     0,   0], # 12 reserved
    [ 90,     0, 180, 500,  2500, 180], # 13 head nod
    [ 90,     0, 180, 500,  2500, 180], # 14 head turn
    [  0,     0,   0,   0,     0,   0], # 15 reserved
    [135,   105, 270, 500,  2500, 270], # 16 left shoulder
    [ 45,     9, 270, 500,  2500, 270], # 17 left bicep
    [135,     0, 270, 500,  2500, 270], # 18 left elbow
    [ 90,     0, 180, 500,  2500, 180], # 19 left wrist
    [ 90,    20,  70, 500,  2500, 180], # 20 left grip
    [135,   125, 144, 500,  2500, 270], # 21 left hip
    [140,     0, 270, 500,  2500, 270], # 22 left thigh
    [130,     0, 270, 500,  2500, 270], # 23 left knee
    [130,   125, 159, 500,  2500, 270], # 24 left foot roll
    [122,    92, 192, 500,  2500, 270], # 25 left foot pitch
    [  0,     0,   0,   0,     0,   0], # 26 reserved
    [  0,     0,   0,   0,     0,   0], # 27 reserved
    [  0,     0,   0,   0,     0,   0], # 28 reserved
    [  0,     0,   0,   0,     0,   0], # 29 reserved
    [  0,     0,   0,   0,     0,   0], # 30 reserved
    [  0,     0,   0,   0,     0,   0], # 31 reserved
]

pose=[ # the settings of the servos at the current time
    130, #  0 right shoulder
    217, #  1 right bicep
    135, #  2 right elbow
     90, #  3 right wrist
     70, #  4 right grip
    140, #  5 right hip
    135, #  6 right thigh
    140, #  7 right knee
    150, #  8 right foot roll
    150, #  9 right foot pitch
      0, # 10 reserved
      0, # 11 reserved
      0, # 12 reserved
     90, # 13 head nod
     90, # 14 head turn
      0, # 15 reserved
    135, # 16 left shoulder
     45, # 17 left bicep
    135, # 18 left elbow
     90, # 19 left wrist
     90, # 20 left grip
    140, # 21 left hip
    140, # 22 left thigh
    130, # 23 left knee
    130, # 24 left foot roll
    122, # 25 left foot pitch
      0, # 26 reserved
      0, # 27 reserved
      0, # 28 reserved
      0, # 29 reserved
      0, # 30 reserved
      0, # 31 reserved
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

def startpose():
    Right.servo[shoulder].angle=ranges[shoulder][0]
    Right.servo[bicep].angle=ranges[bicep][0]
    Right.servo[elbow].angle=ranges[elbow][0]
    Right.servo[wrist].angle=ranges[wrist][0]
    Right.servo[grip].angle=ranges[grip][0]
    Right.servo[hip].angle=ranges[hip][0]
    Right.servo[thigh].angle=ranges[thigh][0]
    Right.servo[knee].angle=ranges[knee][0]
    Right.servo[ankleroll].angle=ranges[ankleroll][0]
    Right.servo[anklepitch].angle=ranges[anklepitch][0]

    Left.servo[shoulder].angle=ranges[shoulder+16][0]
    Left.servo[bicep].angle=ranges[bicep+16][0]
    Left.servo[elbow].angle=ranges[elbow+16][0]
    Left.servo[wrist].angle=ranges[wrist+16][0]
    Left.servo[grip].angle=ranges[grip+16][0]
    Left.servo[hip].angle=ranges[hip+16][0]
    Left.servo[thigh].angle=ranges[thigh+16][0]
    Left.servo[knee].angle=ranges[knee+16][0]
    Left.servo[ankleroll].angle=ranges[ankleroll+16][0]
    Left.servo[anklepitch].angle=ranges[anklepitch+16][0]

    Right.servo[headnod].angle=ranges[headnod][0]
    Right.servo[headturn].angle=ranges[headturn][0]


setup()
startpose()

