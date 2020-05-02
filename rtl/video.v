//============================================================================
//  SNK Alpha68k for MiSTer
//
//  Copyright (C) 2020 Sean 'Furrtek' Gonsalves
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module video (
	input clk,	// unknown
	input CLK_1_5M,
	input LOAD,
	input wren,	// unknown
	input CLK_6M_RAW,
	output nLATCH_X,
	input [12:0] SPRITERAM_A,	// Maybe only [11:0]
	input [15:0] M68K_DATA,
	output [7:0] E4_OUT_M68K,
	output [7:0] E5_OUT_M68K,
	//output [7:0] E2_OUT_M68K,
	
	output reg [17:0] CROM_ADDR,
	output reg CROM_ADDR_M1,
	
	output [7:0] ADDR_E_A,
	output [7:0] ADDR_E_B,
	output [7:0] ADDR_O_A,
	output [7:0] ADDR_O_B
)

	// G2
	assign SPR_X_CLEAR = DISP_HFLIP ? 8'h7F : 8'h00;
	
	assign P7_C = SNKCLK22 ^ SNKCLK20;
	
	// K8_A
	assign nSPR_X_CLEAR_EN = !&{LOAD, PIXEL_CLK[2:0], P7_C};
	
	
	// K2
	assign K2_1 = P7_B ? 1'b1 : nLATCH_X;
	assign K2_2 = P7_B ? nLATCH_X : 1'b1;
	assign K2_3 = P7_B ? nSPR_X_CLEAR_EN : 1'b1;
	assign K2_4 = P7_B ? 1'b1 : nSPR_X_CLEAR_EN;
	
	// K5_B
	assign nLOAD_X_B = K2_1 & K2_3;
	// K5_C
	assign nLOAD_X_A = K2_2 & K2_4;
	
	// P7_B
	assign P7_B = LINE_CLK[0] ^ ~SP85N_13;
	
	
	// H5, H6, H7
	// 12'h000 unknown, probably 68k addr
	assign SPRITERAM_A = CLK_A ? 12'h000 : {G4_OUT[2:1], PIXEL_CLK[6:3], ~PIXEL_CLK[2], G4_OUT[0]};
	
	assign G4_OUT = CLK_1_5_RAW ? 4'h0 : {1'b0, SNKCLK20, SNKCLK23, SPR_MAP_A[4]};
	assign H4_OUT = CLK_1_5_RAW ? {2'b00, SNKCLK20, SNKCLK23} : SPR_MAP_A[3:0];

	
	// J13_D
	assign LOAD = CLK_6M & PIXEL_CLK[0];
	
	always @(posedge CLK_6M)
		J10_B_Q <= PIXEL_CLK[1];
	
	always @(posedge CLK_6M)
		J10_A_nQ <= ~J10_B;
	
	assign OR1 = J10_B_Q | J10_A_nQ | c2_D;
	
	// K9_D
	assign CLK_6MB = ~CLK_6M_RAW;
	
	always @(posedge CLK_A or negedge CLK_6MB)
		if (!CLK_6MB)
			M7_A_Q <= 1'b0;
		else
			M7_A_Q <= 1'b1;
	
	always @(posedge CLK_6M)
		J11_A_Q <= CLK_A;
	
	
	
	wire [1:0] J5_OUT;
	reg J8_A_nQ;
	reg BFLIP;
	wire [3:0] M12_OUT;
	wire [3:0] N6_OUT;
	
	always @(posedge PIXEL_CLK[1])
		J8_A_nQ <= ~SNKCLK20;
	
	assign K5_A = ~SNKCLK22 & J8_A_nQ;
	
	assign J5_OUT = K5_A ? {~CLK12MCT0, ~CLK12MCT0} : {1'b1, CLK_A};
	
	
	always @(posedge PIXEL_CLK[1])
		BFLIP <= LINE_0F;
	
	assign nBFLIP = ~BFLIP;
	
	assign DU_O_B_E_A = ~&{nBFLIP, HFLIP_unk};
	assign DU_O_A_E_B = ~&{BFLIP, HFLIP_unk};
	
	
	assign M12_OUT = nBFLIP ?
							{J5_OUT[0], ~CLK12MCT0, J5_OUT[0], 1'b0} :
							{~CLK12MCT0, J5_OUT[0], 1'b0, J5_OUT[0]};
	
	assign P6_B = ~&{DOTB, CLK12MCT0};
	assign P6_A = ~&{DOTA, CLK12MCT0};
	
	assign N6_OUT = nBFLIP ?
							{J5_OUT[1], P6_A, J5_OUT[1], P6_B} :
							{P6_A, J5_OUT[1], P6_B, J5_OUT[1]};
	
	assign nW_O_A = N6_OUT[0];
	assign nW_O_B = N6_OUT[1];
	assign nW_E_A = N6_OUT[2];
	assign nW_E_B = N6_OUT[3];
	
	assign RC_E_A = nW_E_A | M12_OUT[0];
	assign RC_E_B = nW_E_B | M12_OUT[1];
	assign RC_O_A = nW_O_A | M12_OUT[0];
	assign RC_O_B = nW_O_B | M12_OUT[1];
	
	assign CLK_O_A_E_B = M12_OUT[2];
	assign CLK_O_B_E_A = M12_OUT[3];
	
endmodule
