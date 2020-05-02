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

module watchdog (
	input SNKCLK11,
	input nPSTRESET,
	input nWDKICK,
	output nWDRESET
)
	reg [3:0] L6_OUT;
	
	assign nSNKCLK11 = SNKCLK11;	// K7_A
	
	assign D15_A = nPSTRESET & ~nWDKICK;
	
	always @(posedge nSNKCLK11 or negedge PSTRESET or posedge D15_A)
		if (D15_A)
			L6_OUT <= 4'd0;	// MR
		else
			if (!PSTRESET)
				L6_OUT <= 4'b1000;
			else
				L6_OUT <= L6_OUT  1'b1;
	
	assign nWDRESET = ~L6_OUT[2];
	
endmodule
