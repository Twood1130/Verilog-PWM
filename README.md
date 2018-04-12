# Verilog-PWM
Various verilog modules for PWM output and interfacing

pwm.v: A simple module used to establish a PWM output on a GPIO pin. To use set the period parameter to the time in seconds you want to be your period.
      If you want 1 microsecond for example, set period to .000001. The period cannot be less than the clock period of the module.
      The duty cycle is a 6 bit precision input, and can be changed on the fly.
      
usd_sensor.v: A module for interfacing with a HC_SRO4 Ultrasonic distance sensor. The current version requires an external trigger to measure distance.
              module is untested as of 4/12/18.
              
              
