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

module fix (
	input CLK_A,
	input [11:1] M68K_ADDR,	// Range unknown
	input [7:0] M68K_DATA,	// Is it 15:8 ?
	input [7:0] FIX_RAM_DOUT,
	input [7:1] CLK_PIXEL,
	input [7:0] CLK_LINE,
	input nFIXBANK_WR,
	
	output reg [3:0] FIX_PAL,
	output reg FIX_FLAG
);

	reg [5:0] FIX_BANK;
	reg [7:0] FIX_TILE_NUMBER;
	reg [7:0] FIX_ROM_DOUT_W1;
	reg [7:0] FIX_ROM_DOUT_W2;

	// M11, M10, M9
	wire [10:0] FIX_RAM_ADDRESS = CLK_B ? M68K_ADDR : {CLK_PIXEL[7:3], CLK_LINE[7:3], CLK_PIXEL[2]};

	fix_ram N9(FIX_RAM_ADDRESS, clk, M68K_DATA_IN, wren, FIX_RAM_DOUT);

	always @(posedge CLK_PIXEL[2])
		FIX_TILE_NUMBER <= FIX_RAM_DOUT;		// J7

	always @(posedge nFIXBANK_WR)
		FIX_BANK <= M68K_DATA[5:0];	// unknown

	fix_rom L3({FIX_BANK[2:0], FIX_TILE_NUMBER, CLK_PIXEL[2:1], CLK_LINE[2:0]}, clk, 8'h00, 0, FIX_ROM_DOUT);

	always @(posedge CLK_A)
	begin
		FIX_ROM_DOUT_W1 <= FIX_ROM_DOUT;		// L5
		FIX_ROM_DOUT_W2 <= FIX_ROM_DOUT_W1;	// M5
	end

	always @(posedge clk)	// unknown
		{FIX_FLAG, FIX_PAL} <= FIX_RAM_DOUT[4:0];		// J6
	
endmodule
