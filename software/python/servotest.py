"""Simple test for a standard servo on channel 0 and a continuous rotation servo on channel 1."""
import time
from adafruit_servokit import ServoKit
from board import SCL, SDA
import busio

# Import the PCA9685 module.
from adafruit_pca9685 import PCA9685
# Create the I2C bus interface.
i2c_bus = busio.I2C(SCL, SDA)

# Create a simple PCA9685 class instance.
pca = PCA9685(i2c_bus)

# Set the PWM frequency to 60hz.
pca.frequency = 200
j=0
# Set channels to the number of servo channels on your kit.
# 8 for FeatherWing, 16 for Shield/HAT/Bonnet.
kit = ServoKit(channels=16)
pca.frequency=200;
kit.servo[0].set_pulse_width_range(500,2500)
kit.servo[0].actuation_range=270
kit.servo[1].set_pulse_width_range(500,2500)
kit.servo[1].actuation_range=270
kit.servo[2].set_pulse_width_range(500,2500)
kit.servo[2].actuation_range=270
kit.servo[3].set_pulse_width_range(500,2500)
kit.servo[3].actuation_range=270
kit.servo[4].set_pulse_width_range(500,2500)
kit.servo[4].actuation_range=270
kit.servo[5].set_pulse_width_range(500,2500)
kit.servo[5].actuation_range=270
kit.servo[6].set_pulse_width_range(500,2500)
kit.servo[6].actuation_range=270
#for i in range (40,140,6):
while True:
	print("value:")
	s=input()
	if s=="q":
		break
	j=int(s);
	print("j=",j,"\n")
	kit.servo[2].angle = j
	kit.servo[3].angle = j
	kit.servo[4].angle= j
	kit.servo[5].angle= j
	kit.servo[6].angle = j
	time.sleep(1)
"""for i in range (140,40,-6):
	j=j-15
	kit.servo[6].angle = i
	kit.servo[2].angle = i
	kit.servo[3].angle= i
	kit.servo[4].angle= j
	kit.servo[5].angle= j
	time.sleep(1)

"""
kit.servo[1].angle= 135
kit.servo[2].angle= 135
kit.servo[3].angle= 135
kit.servo[4].angle= 135
kit.servo[5].angle= 135
kit.servo[6].angle= 135

