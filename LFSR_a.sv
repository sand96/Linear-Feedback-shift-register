/*------------------------------------------------------------------------------
--   			20 bits maximum-length LFSR generator
Author:	Xiao Sha
Time:	2018/05/03
Descrption: In this 20 bits LFSR, an xor gate is put between register 3 and 
			register 4. The testbench will store all the output in "Output" file
			which will store all the pseudorandom test vector and the iteration 
			number. The length is 2^20 - 1.

README:		In order to use this program, two command is needed.
			vlog LFSR_a.sv 
			vsim tb -c -do "run -all"
			Then check all the result in the output file.
------------------------------------------------------------------------------*/
//try again
module LFSR_a (clk, reset,initial_sig,LFSR_reg);
input clk; //clock cycle to shift register
input reset; //signal to reset the circuit
input [0:19] initial_sig; //the initial value for the LFSR

logic reg1,reg2,reg3,reg4,reg5;	//the output register
logic reg6,reg7,reg8,reg9,reg10;	//the output register
logic reg11,reg12,reg13,reg14,reg15;	//the output register
logic reg16,reg17,reg18,reg19,reg20;	//the output register

output [0:19] LFSR_reg;

	//update the front_reg but shift the left two bits to the left and 
	always_ff @(posedge clk) begin
		if(reset) begin
			reg1 <= initial_sig[0];
			reg2 <= initial_sig[1];
			reg3 <= initial_sig[2];
			reg4 <= initial_sig[3];
			reg5 <= initial_sig[4];
			reg6 <= initial_sig[5];
			reg7 <= initial_sig[6];
			reg8 <= initial_sig[7];
			reg9 <= initial_sig[8];
			reg10 <= initial_sig[9];
			reg11 <= initial_sig[10];
			reg12 <= initial_sig[11];
			reg13 <= initial_sig[12];
			reg14 <= initial_sig[13];
			reg15 <= initial_sig[14];
			reg16 <= initial_sig[15];
			reg17 <= initial_sig[16];
			reg18 <= initial_sig[17];
			reg19 <= initial_sig[18];
			reg20 <= initial_sig[19];
		end 
		else begin
			reg1 <= reg20;
			reg2 <= reg1;
			reg3 <= reg2;
			reg4 <= reg3 ^ reg20;
			reg5 <= reg4;
			reg6 <= reg5;
			reg7 <= reg6;
			reg8 <= reg7;
			reg9 <= reg8;
			reg10 <= reg9;
			reg11 <= reg10;
			reg12 <= reg11;
			reg13 <= reg12;
			reg14 <= reg13;
			reg15 <= reg14;
			reg16 <= reg15;
			reg17 <= reg16;
			reg18 <= reg17;
			reg19 <= reg18;
			reg20 <= reg19;
		end
	end
	assign LFSR_reg = {reg1,reg2,reg3,reg4,reg5, reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20};
endmodule

module tb ();
logic clk; //clock cycle to shift register
logic reset; //signal to reset the circuit
logic [0:19] initial_sig; //the initial value
logic [0:19] LFSR_reg;
logic [0:19] counter; 
logic [0:19]  counter_delay; //old value of counter to show whether the counter is a constant now
logic [0:1] flag; //flag for the first intialize
//logic [0:19] old_output; //the old value of output register 

	initial clk = 0;
	always #5 clk = ~clk;

	//initialize the input value
	assign initial_sig = 20'h00001;
	//using the module
	LFSR_a dut(clk, reset,initial_sig,LFSR_reg);


		//The counter will increase only when the LFSR_reg
		//refresh in this cycle. Otherwise, counter will keep 
		//constant.
	always_ff @(posedge clk) begin
		if(reset)
			counter <= 1;
		else if( (LFSR_reg != initial_sig) && (flag < 2))
			counter <= counter + 1; //initilize the counter
		else
			counter <= counter;
	end // always_ff @(posedge clk)

		//load the old value of counter input counter_delay
	always_ff @(posedge clk) begin
		counter_delay <= counter;
	end // always_ff @(posedge clk)

		//when LFSR_reg equals its intial value
		//install the increasing of flag
	always_ff @(posedge clk) begin
		if(reset)
			flag <= 0;
		else if(LFSR_reg == initial_sig && flag < 2)
			flag <= flag + 1;
		else 
			flag <= flag;
	end // always_ff @(posedge clk)



		//stop the display when the second iteration 
		//start to work
	always_ff @(posedge clk)begin
		if(flag < 2) begin
			$fdisplay(filehandle,"%b",LFSR_reg);
		end // if(counter_delay == counter)
	end // always_ff @(posedge clk)

		//create a file
	integer filehandle = $fopen("Output");

	initial begin
		@(posedge clk); #1; reset = 1;	//initial the circuit
		@(posedge  clk); #1; reset = 0; //close the initial

		#50000000;	//The working time
		$fdisplay(filehandle,"The iteration counter is %b",counter_delay);
		$fclose(filehandle);
		$finish;
	end // initial

		
endmodule