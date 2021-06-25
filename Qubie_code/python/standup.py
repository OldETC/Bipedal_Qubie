# standup.py
# by: les Howell
# make the robot stand up

from adafruit_servokit import ServoKit

# This relies on the Adafruit motor library available here:
# https://github.com/adafruit/Adafruit_CircuitPython_Motor
from adafruit_motor import servo

# Set the servo locations
# Board addresses.  
#The left side of the robot is plugged into the board addressed as 41
LEFT= 40
#The right side of the robot is plugged into the board addressed as 40
RIGHT=41


shoulder=0
bicep=1
elbow=2
wrist=3
gripper=4
hip=5
thigh=6
knee=7
footroll=8
footpitch=9

# head nod and turn are on the left driver board
nod=13
turn=15


# setup the driver
left=ServoKit(channels=16,address=LEFT)
right=ServoKit(channels=16,address=RIGHT)
left.frequency = 300
right.frequency = 300

# the range of each in microseconds
left.servo[shoulder].set_pulse_width_range=(500,2500)
left.servo[bicep].set_pulse_width_range=(500,2500)
left.servo[elbow].set_pulse_width_range=(500,2500)
left.servo[wrist].set_pulse_width_range=(500,2500)
left.servo[gripper].set_pulse_width_range=(500,2500)
left.servo[hip].set_pulse_width_range=(500,2500)
left.servo[thigh].set_pulse_width_range=(500,2500)
left.servo[knee].set_pulse_width_range=(500,2500)
left.servo[footroll].set_pulse_width_range=(500,2500)
left.servo[footpitch].set_pulse_width_range=(500,2500)

left.servo[nod].set_pulse_width_range=(500,2500)
left.servo[turn].set_pulse_width_range=(500,2500)

right.servo[shoulder].set_pulse_width_range=(500,2500)
right.servo[bicep].set_pulse_width_range=(500,2500)
right.servo[elbow].set_pulse_width_range=(500,2500)
right.servo[wrist].set_pulse_width_range=(500,2500)
right.servo[gripper].set_pulse_width_range=(500,2500)
right.servo[hip].set_pulse_width_range=(500,2500)
right.servo[thigh].set_pulse_width_range=(500,2500)
right.servo[knee].set_pulse_width_range=(500,2500)
right.servo[footroll].set_pulse_width_range=(500,2500)
right.servo[footpitch].set_pulse_width_range=(500,2500)

# Now set the full sweep range in degrees
left.servo[shoulder].actuation_range=(270)
left.servo[bicep].actuation_range=(270)
left.servo[elbow].actuation_range=(270)
left.servo[wrist].actuation_range=(270)
left.servo[gripper].actuation_range=(270)
left.servo[hip].actuation_range=(270)
left.servo[thigh].actuation_range=(270)
left.servo[knee].actuation_range=(270)
left.servo[footroll].actuation_range=(270)
left.servo[footpitch].actuation_range=(270)

left.servo[nod].actuation_range=(270)
left.servo[turn].actuation_range=(270)

right.servo[shoulder].actuation_range=(270)
right.servo[bicep].actuation_range=(270)
right.servo[elbow].actuation_range=(270)
right.servo[wrist].actuation_range=(270)
right.servo[gripper].actuation_range=(270)
right.servo[hip].actuation_range=(270)
right.servo[thigh].actuation_range=(270)
right.servo[knee].actuation_range=(270)
right.servo[footroll].actuation_range=(270)
right.servo[footpitch].actuation_range=(270)

# set the servos to the nominal position.  Note that it differs 
# for each servo depending on the joint, the joint position and 
# the available range of motion.

left.servo[shoulder].angle=(135)
left.servo[bicep].angle=(135)
left.servo[elbow].angle=(135)
left.servo[wrist].angle=(135)
left.servo[gripper].angle=(45)
left.servo[hip].angle=(135)
left.servo[thigh].angle=(135)
left.servo[knee].angle=(135)
left.servo[footroll].angle=(135)
left.servo[footpitch].angle=(135)

left.servo[nod].angle=(135)
left.servo[turn].angle=(135)

right.servo[shoulder].angle=(135)
right.servo[bicep].angle=(135)
right.servo[elbow].angle=(135)
right.servo[wrist].angle=(135)
right.servo[gripper].angle=(45)
right.servo[hip].angle=(135)
right.servo[thigh].angle=(135)
right.servo[knee].angle=(135)
right.servo[footroll].angle=(135)
right.servo[footpitch].angle=(135)

