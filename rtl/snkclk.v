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

module snkclk (
	input CLK_IN,
	input IN3,	// Reset ?
	output HSYNC,
	output [6:0] PIXEL,
	output [7:0] LINE
)

	reg [8:0] COUNT;
	reg [7:0] LINE;
	
	always @(posedge CLK_IN or negedge IN3)
		if (IN3)
			COUNT <= 8'h00;
		else
			COUNT <= COUNT + 1'b1;

	assign PIN40 = COUNT[0];
	assign PIN39 = COUNT[1];
	assign PIN38 = COUNT[2];
	assign PIN37 = COUNT[3];
	assign PIN36 = COUNT[4];
	assign PIN35 = COUNT[5];
	assign PIN34 = COUNT[6];
	assign PIN33 = COUNT[7];
	
	// 1 line = 384px
	
	always @(posedge LINE_CLK)
		LINE <= LINE + 1'b1;
	
	assign PIN19 = LINE[0];
	assign PIN18 = LINE[1];
	assign PIN17 = LINE[2];
	assign PIN16 = LINE[3];
	assign PIN15 = LINE[4];
	assign PIN14 = LINE[5];
	assign PIN13 = LINE[6];
	assign PIN12 = LINE[7];
	
endmodule
