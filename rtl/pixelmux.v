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

module pixelmux (
	input CLK_PIXEL,	// CLK_PIXEL[0]
	input PACLK,
	
	input [7:0] FIX_DATA,
	input [3:0] FIX_PAL,
	input FIX_FLAG,
	
	input [3:0] SPR_PLANE_A,
	input [3:0] SPR_PLANE_B,
	input [3:0] SPR_PLANE_C,
	input [3:0] SPR_PLANE_D,
	
	input [7:0] SPR_PAL_A,
	input [7:0] SPR_PAL_B,
	input [7:0] SPR_PAL_C,
	input [7:0] SPR_PAL_D,
	
	output [7:0] PAL_RAM_DOUT
);

	reg [3:0] SPR_COLOR;
	reg [7:0] SPR_PAL;
	wire [3:0] FIX_COLOR;
	reg [12:0] PAL_RAM_ADDR;
	wire FIX_OPAQUE;
	wire [3:0] MUX_COLOR;
	wire [7:0] MUX_PAL;

	wire [1:0] SPR_AB = {P6_13, CLK_PIXEL};
	
	always @(*)
	begin
		case (SPR_AB)
			2'b00:
				SPR_COLOR[1:0] <= {SPR_PLANE_A[1], SPR_PLANE_A[0]};	// K15
				SPR_COLOR[3:2] <= {SPR_PLANE_A[3], SPR_PLANE_A[2]};	// L15
				SPR_PAL[1:0] <= {SPR_PAL_A[1], SPR_PAL_A[0]};	// M15
				SPR_PAL[3:2] <= {SPR_PAL_A[3], SPR_PAL_A[2]};	// K13
				SPR_PAL[5:4] <= {SPR_PAL_A[5], SPR_PAL_A[4]};	// P15
				SPR_PAL[7:6] <= {SPR_PAL_A[7], SPR_PAL_A[6]};	// N15
			2'b01:
				SPR_COLOR[1:0] <= {SPR_PLANE_B[1], SPR_PLANE_B[0]};	// K15
				SPR_COLOR[3:2] <= {SPR_PLANE_B[3], SPR_PLANE_B[2]};	// L15
				SPR_PAL[1:0] <= {SPR_PAL_B[1], SPR_PAL_B[0]};	// M15
				SPR_PAL[3:2] <= {SPR_PAL_B[3], SPR_PAL_B[2]};	// K13
				SPR_PAL[5:4] <= {SPR_PAL_B[5], SPR_PAL_B[4]};	// P15
				SPR_PAL[7:6] <= {SPR_PAL_B[7], SPR_PAL_B[6]};	// N15
			2'b10:
				SPR_COLOR[1:0] <= {SPR_PLANE_C[1], SPR_PLANE_C[0]};	// K15
				SPR_COLOR[3:2] <= {SPR_PLANE_C[3], SPR_PLANE_C[2]};	// L15
				SPR_PAL[1:0] <= {SPR_PAL_C[1], SPR_PAL_C[0]};	// M15
				SPR_PAL[3:2] <= {SPR_PAL_C[3], SPR_PAL_C[2]};	// K13
				SPR_PAL[5:4] <= {SPR_PAL_C[5], SPR_PAL_C[4]};	// P15
				SPR_PAL[7:6] <= {SPR_PAL_C[7], SPR_PAL_C[6]};	// N15
			2'b11:
				SPR_COLOR[1:0] <= {SPR_PLANE_D[1], SPR_PLANE_D[0]};	// K15
				SPR_COLOR[3:2] <= {SPR_PLANE_D[3], SPR_PLANE_D[2]};	// L15
				SPR_PAL[1:0] <= {SPR_PAL_D[1], SPR_PAL_D[0]};	// M15
				SPR_PAL[3:2] <= {SPR_PAL_D[3], SPR_PAL_D[2]};	// K13
				SPR_PAL[5:4] <= {SPR_PAL_D[5], SPR_PAL_D[4]};	// P15
				SPR_PAL[7:6] <= {SPR_PAL_D[7], SPR_PAL_D[6]};	// N15
		endcase
	end

	// M4
	assign FIX_COLOR = CLK_PIXEL ? FIX_DATA[3:0] : FIX_DATA[7:4];	// order unknown
	
	// M6, N4
	assign FIX_OPAQUE = |{FIX_COLOR, FIX_FLAG};

	// J12
	assign MUX_COLOR = FIX_OPAQUE ? FIX_COLOR : SPR_COLOR;
	
	// H12, H9
	assign MUX_PAL = FIX_OPAQUE ? {4'b0000, FIX_PAL} : SPR_PAL;
	
	// H11, H10
	always @(posedge PACLK)
		PAL_RAM_ADDR <= {MUX_PAL, MUX_COLOR};
	
	pal_ram C9(PAL_RAM_ADDR, clk, 8'h00, 0, PAL_RAM_DOUT);

endmodule
