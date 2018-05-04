/*------------------------------------------------------------------------------
--   			5 bits weighted LFSR generator
Author:	Xiao Sha
Time:	2018/05/03
Descrption: In this LFSR, an xor gate is put between register 3 and 
			register 4. 5 output bits will be generated. The testbench will 
			store all the output in "Output" file.This file includes all the output bits
			working_counter means total output bits.
			counter sums the number of one in the output bits.

			Two control signals can be set. The first is Inv_sig and the other is W_sig.
			W_sig is a mux signal to choose the output bit. And Inv_sig will make an inversion
			to the output bits. You can change them by at the location labed by "******".

README:		In order to use this program, two command is needed.
			vlog LFSR_b.sv 
			vsim tb -c -do "run -all"
			Then check all the result in the output file.
------------------------------------------------------------------------------*/
module LFSR_a (clk, reset,initial_sig,W_sig, Inv_sig, LFSR_weight);
input clk; //clock cycle to shift register
input reset; //signal to reset the circuit
input [0:19] initial_sig; //the initial value for the LFSR
input [0:1] W_sig;
input Inv_sig;

output logic [0:4] LFSR_weight; //The output the value

logic reg1,reg2,reg3,reg4,reg5;	//the output register
logic reg6,reg7,reg8,reg9,reg10;	//the output register
logic reg11,reg12,reg13,reg14,reg15;	//the output register
logic reg16,reg17,reg18,reg19,reg20;	//the output register

logic reg1_out,reg2_out,reg3_out,reg4_out,reg5_out;	//the output register
logic reg6_out,reg7_out,reg8_out,reg9_out,reg10_out;	//the output register
logic reg11_out,reg12_out,reg13_out,reg14_out,reg15_out;	//the output register
logic reg16_out,reg17_out,reg18_out,reg19_out,reg20_out;	//the output register

logic [0:19] LFSR_reg; //The register after weighted

//five block to add weighed calculation by using
//and gates
assign reg4_out = reg4;
assign reg3_out = reg4_out & reg3;
assign reg2_out = reg3_out & reg2;
assign reg1_out = reg2_out & reg1;

assign reg8_out = reg8;
assign reg7_out = reg8_out & reg7;
assign reg6_out = reg7_out & reg6;
assign reg5_out = reg6_out & reg5;

assign reg12_out = reg12;
assign reg11_out = reg12_out & reg11;
assign reg10_out = reg11_out & reg10;
assign reg9_out = reg10_out & reg9;

assign reg16_out = reg16;
assign reg15_out = reg16_out & reg15;
assign reg14_out = reg15_out & reg14;
assign reg13_out = reg14_out & reg13;

assign reg20_out = reg20;
assign reg19_out = reg20_out & reg19;
assign reg18_out = reg19_out & reg18;
assign reg17_out = reg18_out & reg17;

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
	
	//use reg_out to combine the output 
	//If Inv_sig = 1, reverse the value.
	assign LFSR_reg = (Inv_sig == 0) ? {reg1_out,reg2_out,reg3_out,reg4_out,reg5_out,reg6_out,reg7_out,reg8_out,reg9_out,reg10_out,
	reg11_out,reg12_out,reg13_out,reg14_out,reg15_out,reg16_out,reg17_out,reg18_out,reg19_out,reg20_out} : 
	{~reg1_out,~reg2_out,~reg3_out,~reg4_out,~reg5_out,~reg6_out,~reg7_out,~reg8_out,~reg9_out,~reg10_out,
	~reg11_out,~reg12_out,~reg13_out,~reg14_out,~reg15_out,~reg16_out,~reg17_out,~reg18_out,~reg19_out,~reg20_out};

	//choose the value to output, according to the weight value
	always_comb begin
		if(W_sig == 2'd3) begin
			LFSR_weight = {LFSR_reg[0], LFSR_reg[4],LFSR_reg[8],LFSR_reg[12],LFSR_reg[16]};
		end // if(LFSR_weight == 0)
		else if(W_sig == 2'd2) begin
			LFSR_weight = {LFSR_reg[1], LFSR_reg[5],LFSR_reg[9],LFSR_reg[13],LFSR_reg[17]};
		end // if(LFSR_weight == 1)
		else if(W_sig == 2'd1) begin
			LFSR_weight = {LFSR_reg[2], LFSR_reg[6],LFSR_reg[10],LFSR_reg[14],LFSR_reg[18]};
		end // if(LFSR_weight == 2)
		else if(W_sig == 2'd0) begin
			LFSR_weight = {LFSR_reg[3], LFSR_reg[7],LFSR_reg[11],LFSR_reg[15],LFSR_reg[19]};
		end // if(LFSR_weight == 3)
	end // always_comb

endmodule

module tb ();
		//input signal
logic clk; //clock cycle to shift register
logic reset; //signal to reset the circuit
logic [0:19] initial_sig; //the initial value
logic [0:1] W_sig;
logic Inv_sig;
	//output signal
logic [0:4] LFSR_weight;
	
	//logic signal for simulation 
logic [0:63] counter; //The number of one
logic [0:63] working_counter; //The total number of bits has been generated
real percentage;

	initial clk = 0;
	always #5 clk = ~clk;

	//initialize the input value
	assign initial_sig = 20'h00001;

//*********************************************
//	CHANGE HERE
	//The input signal, you can change
	//W_sig ranges from 0 to 3, and Inv_sig
	//will be 0 or 1.
	assign W_sig = 2'd3;
	assign Inv_sig = 0; 

	//calling the module
	LFSR_a dut(clk, reset,initial_sig,W_sig, Inv_sig, LFSR_weight);

		//The counter will increase by the value of
		//LFSR_weight
	always_ff @(posedge clk) begin
		if(reset) begin
			counter <= 0;
			working_counter <= 0;
		end // if(reset)
		else begin
			counter += one_count(LFSR_weight);
			working_counter += 5;
		end // else
	end // always_ff @(posedge clk)

	initial begin
		@(posedge clk); #1; reset = 1;	//initial the circuit
		@(posedge  clk); #1; reset = 0; //close the initial

		#1000000;
		$fdisplay(filehandle,"The number is %d", counter);
		$fdisplay(filehandle,"The total number is %d", working_counter);
		$fclose(filehandle);	//close file
		$finish;
	end // initial

	//create a file
	integer filehandle = $fopen("Output");
	always @(posedge clk) begin
		if(reset != 1)
		$fdisplay(filehandle, "%b", LFSR_weight);
	end

  //////////////////////////////////////////////////////
  ///function to count one in bytes. It inputs one byte
  ///One_count will automatic increase if it finds bit 
  ///1;
    function logic[0:63] one_count(input logic [0:4] a);
      int i;
      begin 
      one_count = 64'b0;
      i = 0;
      while(i <5)
        begin
          one_count = one_count + {63'b0,a[i]};
          i ++;
        end
      end
  	endfunction
endmodule