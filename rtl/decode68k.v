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

module decode68k (
	input nUDS, nLDS,
	input [22:1] M68K_ADDR,
	input M68K_RW,
	
	output nVRAM_SEL,
	output nSPRRAM_SEL,
	output nMCU_SEL,

	output nSHAREDRAM_WR_L,
	output nSOUND_WR,
	output nOUTPUT_WR,
	output nROM_RD_L,
	output nSHAREDRAM_RD,
	output nINPUT_RD_L,
	output nDIP2_RD,

	output nSHAREDRAM_WR_U,
	output nFIXBANK_WR,
	output nROM_RD_U,
	output nSHAREDRAM_RD,
	output nINPUT_RD_U,
	output nDIP2_RD,

	output nWD_KICK,
);

	wire [7:0] C15_OUT;
	wire [7:0] F1_OUT;
	wire [7:0] M3_OUT;
	wire [7:0] B15_OUT;

	assign nVRAM_SEL = C15_OUT[1];
	assign nSPRRAM_SEL = C15_OUT[2];
	assign nMCU_SEL = C15_OUT[3];

	assign nSHAREDRAM_WR_L = F1_OUT[1];
	assign nSOUND_WR = F1_OUT[2];
	assign nOUTPUT_WR = F1_OUT[2];
	assign nROM_RD_L = F1_OUT[4];
	assign nSHAREDRAM_RD = F1_OUT[5];
	assign nINPUT_RD_L = F1_OUT[6];
	assign nDIP2_RD = F1_OUT[7];

	assign nSHAREDRAM_WR_U = M3_OUT[1];
	assign nFIXBANK_WR = M3_OUT[2];
	assign nROM_RD_U = M3_OUT[4];
	assign nSHAREDRAM_RD = M3_OUT[5];
	assign nINPUT_RD_U = M3_OUT[6];
	assign nDIP2_RD = M3_OUT[7];

	assign nWD_KICK = B15_OUT[5];

	C74138 C15(M68K_ADDR[22:20], 1, nLDS & nUDS, 0, C15_OUT);

	C74138 F1({M68K_RW, M68K_ADDR[19:18]}, 1, C15_OUT[0], nLDS, F1_OUT);
	C74138 M3({M68K_RW, M68K_ADDR[19:18]}, 1, C15_OUT[0], nUDS, M3_OUT);

	C74138 B15(M68K_ADDR[17:15], 1, M3_OUT[7], 0, B15_OUT);	// E1 unknown

endmodule
