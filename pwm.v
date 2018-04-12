//Verilog 50mhz PWM outpur module, with 6-bit duty-cycle resolution
//Tristan Woodrich
//4/9/2018

module pwm(
	input clk_50mhz,
	input [5:0] duty_cycle,
	
	output reg pwm_out);
	
	wire[25:0] active;
	reg [25:0] count;
	
	parameter period = 1; //time in seconds
	
	
	assign active = (50000000*period) * (duty_cycle/64); //50Mhz/64 = 781250
	
	
	always @(posedge clk_50mhz) begin
		count <= count + 1;
		
		if (count > (50000000*period)) count <= 0;
		
		else if (count > active) pwm_out <= 0; //output = 0 if active period is over
		else  pwm_out <= 1; //output = 1 if in active period

	end
endmodule
