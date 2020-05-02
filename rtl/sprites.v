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

module sprites (
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
	wire [7:0] E4_OUT;
	wire [7:0] E5_OUT;
	wire [7:0] E2_OUT;
	reg [7:0] SPR_X;
	reg [7:0] SPR_PAL;
	wire [7:0] LINE_SHIFT;
	wire [8:0] LINE_ADD;
	reg HFLIP, nCROM_CE;
	reg [3:0] SPR_LINE;
	reg [3:0] SPR_LINE_REG;
	reg [4:0] SPR_MAP;
	reg H;
	reg EVEN, EVEN_W;
	wire [7:0] SPR_X_PLUS_A;
	wire [7:0] SPR_X_PLUS_B;
	
	assign nLATCH_X = ~(CLK_1_5M & LOAD);
	
	// X position and palette number
	spr_ram E4(SPRITERAM_A, clk, M68K_DATA[7:0], wren, E4_OUT);	// Is it M68K_DATA[15:8] ?
	
	// G3
	always @(posedge nLATCH_X)
		SPR_X <= E4_OUT;
	
	// G6
	always @(posedge CLK_6M_RAW)
		SPR_PAL <= E4_OUT;
	
	// F5
	always @(posedge F5_LE)
		E4_OUT_M68K <= E4_OUT;

	// Y position and tile number
	spr_ram E5(SPRITERAM_A, clk, M68K_DATA[7:0], wren, E5_OUT);	// Is it M68K_DATA[15:8] ?
	spr_ram E2(SPRITERAM_A, clk, M68K_DATA[7:0], wren, E2_OUT);	// Is it M68K_DATA[15:8] ?
	
	// G7
	always @(posedge CLK_6M_RAW)
		{HFLIP, nCROM_CE, CROM_ADDR[17:12]} <= E5_OUT;
	
	// E7
	always @(posedge E7_LE)	// unknown
		E5_OUT_M68K <= E5_OUT;
	
	// G8
	always @(posedge CLK_6M_RAW)
		CROM_ADDR[11:4] <= E2_OUT;
	
	// K1, L1
	assign LINE_SHIFT = HFLIP_unk ? CLK_LINE + 8'hFF : CLK_LINE + 8'h01;
	// H1, J1
	assign LINE_ADD = LINE_SHIFT + E5_OUT;
	
	assign P7_D = LINE_ADD[8] ^ E5_OUT[0];	// Really E5_OUT[0] ?
	
	always @(posedge nLATCH_X)
	begin
		SPR_LINE <= LINE_ADD[3:0];
		SPR_MAP[4:0] <= {P7_D, LINE_ADD[7:4]};
		H <= HFLIP;
		{EVEN, EVEN_W} <= {EVEN_W, E5_OUT[7]};	// Really E5_OUT[7] ?
	end
	
	always @(posedge CLK_1_5M)
		SPR_LINE_REG <= SPR_LINE;
	
	// M2
	CROM_ADDR[2:0] = VFLIP ? ~SPR_LINE_REG[3:1] : SPR_LINE_REG[3:1];
	CROM_ADDR_M1 = VFLIP ? ~SPR_LINE_REG[0] : SPR_LINE_REG[0];
	
	// Why are those two the same ?
	// P10, P11
	assign SPR_X_PLUS_A = SPR_X + {7'h00, ~D14_A};
	// N10, N11
	assign SPR_X_PLUS_B = SPR_X + {7'h00, ~D14_A};
	
	C74669 P13(SPR_X_PLUS_A[3:0], CLK_O_B_E_A, DU_O_B_E_A, nLOAD_X_A, ADDR_E_A[3:0]);
	C74669 P12(SPR_X_PLUS_A[7:4], CLK_O_B_E_A, DU_O_B_E_A, nLOAD_X_A, ADDR_E_A[7:4]);
	
	C74669 N13(SPR_X_PLUS_B[3:0], CLK_O_A_E_B, DU_O_A_E_B, nLOAD_X_B, ADDR_E_B[3:0]);
	C74669 N12(SPR_X_PLUS_B[7:4], CLK_O_A_E_B, DU_O_A_E_B, nLOAD_X_B, ADDR_E_B[7:4]);
	
	C74669 K12(SPR_X[3:0], CLK_O_B_E_A, DU_O_B_E_A, nLOAD_X_A, ADDR_O_B[3:0]);
	C74669 L13(SPR_X[7:4], CLK_O_B_E_A, DU_O_B_E_A, nLOAD_X_A, ADDR_O_B[7:4]);
	
	C74669 L12(SPR_X[3:0], CLK_O_A_E_B, DU_O_A_E_B, nLOAD_X_B, ADDR_O_A[3:0]);
	C74669 M13(SPR_X[7:4], CLK_O_A_E_B, DU_O_A_E_B, nLOAD_X_B, ADDR_O_A[7:4]);
endmodule
