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

LEFT=0x40
RIGHT=0x41

headnod=14
headturn=15

#creating the instances of the control software
# Set channels to the number of servo channels on your kit.
# 8 for FeatherWing, 16 for Shield/HAT/Bonnet.
# Set the PWM frequency to 200.
Left = ServoKit(channels=16,address=LEFT)
#Right= ServoKit(channels=16,address=RIGHT)

def setup():

    Left.PWMfrequency=200

    for i in range (0,15):
        Left.servo[i].set_pulse_width_range(500,2500)
        Left.servo[i].actuation_range=270
#        Right.servo[i].set_pulse_width_range(500,2500)
#        Right.servo[i].actuation_range=270
    # change the head and grip special ranges
#    Right.servo[headnod].actuation_range=180
#    Right.servo[headturn].actuation_range=180
    Left.servo[grip].actuation_range=70
#    Right.servo[grip].actuation_range=70
    #actuation limits due to hardware
    

setup()







