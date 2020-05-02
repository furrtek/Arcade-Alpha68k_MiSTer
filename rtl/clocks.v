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

module clocks (
	input CLK_24M,
	input [1:0] PIXEL_CLK,
	output CLK_12M_RAW,
	output CLK_6M_RAW,
	output CLK_1_5M_RAW,
	output CLK_6M,
	output PACLK,
	output CLK12MCT0,
	output CLK_A,
	output CLK_B
)
	
	// L8
	assign CLK_A = PIXEL_CLK[0];
	assign CLK_B = PIXEL_CLK[1];
	
	reg [3:0] M8_OUT;
	
	// M8 reset value unknwon, don't care ?
	always @(posedge CLK_24M)
		M8_OUT <= M8_OUT + 1'b1;
	
	assign CLK_12M_RAW = M8_OUT[0];
	assign CLK_6M_RAW = M8_OUT[1];
	assign CLK_1_5M_RAW = M8_OUT[3];
	
	// H13
	assign CLK_6M = CLK_6M_RAW;
	assign PACLK = CLK_6MB;
	assign CLK12MCT0 = CLK_12M_RAW;
	
endmodule
