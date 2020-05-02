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

module linebuffers (
	input clk,	// unknown
	input nLATCH_X,
	input [7:0] SPR_PAL,
	
	input [3:0] GAD,
	input [3:0] GBD,
	
	input nRC_E_A, nW_E_A,
	input nRC_E_B, nW_E_B,
	
	input nRC_O_A, nW_O_A,
	input nRC_O_B, nW_O_B,
	
	output [11:0] E_A_DOUT,
	output [11:0] E_B_DOUT,
	output [11:0] O_A_DOUT,
	output [11:0] O_B_DOUT
)
	
	reg [7:0] SPR_PAL_REG;
	wire [11:0] E_A_DIN;
	wire [11:0] E_B_DIN;
	wire [11:0] O_A_DIN;
	wire [11:0] O_B_DIN;
	
	// G1
	always @(posedge nLATCH_X)
		SPR_PAL_REG <= SPR_PAL;
	
	assign E_A_DIN = nRC_E_A ? 8'h00 : {SPR_PAL_REG, GAD};	// GAD bit order is 1,0,2,3 on real HW
	assign E_B_DIN = nRC_E_B ? 8'h00 : {SPR_PAL_REG, GAD};
	assign O_A_DIN = nRC_O_A ? 8'h00 : {SPR_PAL_REG, GBD};	// GBD bit order is 1,0,2,3 on real HW
	assign O_B_DIN = nRC_O_B ? 8'h00 : {SPR_PAL_REG, GBD};
	
	pixel_ram BUFFER_E_A(addr, clk, E_A_DIN, ~nW_E_A, E_A_DOUT);	// M16, M17
	pixel_ram BUFFER_E_B(addr, clk, E_B_DIN, ~nW_E_B, E_B_DOUT);	// P16, P17
	pixel_ram BUFFER_O_A(addr, clk, O_A_DIN, ~nW_O_A, O_A_DOUT);	// L16, L17
	pixel_ram BUFFER_O_B(addr, clk, O_B_DIN, ~nW_O_B, O_B_DOUT);	// L18, L19

endmodule
