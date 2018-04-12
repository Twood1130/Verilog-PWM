//Ultra-sonic distance sensor interface
//Tristan Woodrich
//v1 external trigger version.
//April 10th, 2018

module usd_sensor(
	input clk_50mhz,
	input sensor_in,
	input trigger,
	
	output reg sensor_trigger,
	output reg [15:0] sensor_response);

	reg [4:0] sync_chain;
	reg [1:0] state;
	reg [25:0] counter;//counter set to allow a count of 50 million, to allow a full second timing

	
	parameter [1:0] RESET 	= 	2'b00, //state definitions
						 TRIGGER = 	2'b01,
						 TIME	=	2'b10;
					
	always @(posedge clk_50mhz) begin //Synchronizer chain
		sync_chain[2] <= sync_chain[1];
		sync_chain[1] <= sync_chain[0];
		sync_chain[0] <= sensor_in;
	end
	
	always @(posedge clk_50mhz) begin
	
		case (state)
		
			RESET: begin //reset counter and trigger output
				counter <= 0;
				sensor_trigger <= 0;
				if (trigger == 1) state <= TRIGGER;
			end
			
			TRIGGER: begin //sends a 10 microsecond pulse to the sensor
				if (counter >= 500) begin  //500 clocks to get 10
					sensor_trigger <= 0;
					if(sync_chain[2] == 1) begin //transition to time once the sensor begins returning a value
						state <= TIME;
						counter <= 0;
					end
				end
				else begin
					sensor_trigger <= 1;
					counter <= counter + 1;
				end
			end
			
			TIME: begin //increment the counter as long as the input signal is high.
				
				if (counter == 500000) begin //time out if 1/100th of a second goes by. (Distance > 3.43 meters)
					state <= RESET;
					sensor_response <= (counter/50); //return counter value. 
				end
				
				else if (sync_chain[2] == 1) begin
					counter <= counter + 1;
				end
		
				else begin //once signal goes low, output the counter value.
					sensor_response <= (counter/50);
					if (trigger == 0) state <= RESET;
				end
			end
			
		endcase
		
	end
endmodule