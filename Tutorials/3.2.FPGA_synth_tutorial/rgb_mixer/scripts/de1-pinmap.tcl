set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS_INPUT_TRI_STATED"
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_ASDO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"

# Clock / Reset
set_location_assignment PIN_R22 -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
set_location_assignment PIN_R21 -to inc
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to inc
set_location_assignment PIN_T22 -to dec
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to dec

set_location_assignment PIN_L1 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk

set_location_assignment PIN_L22 -to led[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[0]
set_location_assignment PIN_L21 -to led[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led[1]
# GREEN LED
set_location_assignment PIN_U22 -to PWM0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM0
set_location_assignment PIN_U21 -to PWM1
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM1
set_location_assignment PIN_V22 -to PWM2
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to PWM2