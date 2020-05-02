
module cos (
	input   [9:0] x,
	output  [7:0] y
);

wire [7:0] qcos[0:255] = '{
	8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 
	8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 
	8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 8'b01111111, 
	8'b01111110, 8'b01111110, 8'b01111110, 8'b01111110, 8'b01111110, 8'b01111110, 8'b01111110, 8'b01111110, 
	8'b01111101, 8'b01111101, 8'b01111101, 8'b01111101, 8'b01111101, 8'b01111101, 8'b01111100, 8'b01111100, 
	8'b01111100, 8'b01111100, 8'b01111100, 8'b01111011, 8'b01111011, 8'b01111011, 8'b01111011, 8'b01111010, 
	8'b01111010, 8'b01111010, 8'b01111010, 8'b01111010, 8'b01111001, 8'b01111001, 8'b01111001, 8'b01111001, 
	8'b01111000, 8'b01111000, 8'b01111000, 8'b01110111, 8'b01110111, 8'b01110111, 8'b01110111, 8'b01110110, 
	8'b01110110, 8'b01110110, 8'b01110101, 8'b01110101, 8'b01110101, 8'b01110100, 8'b01110100, 8'b01110100, 
	8'b01110011, 8'b01110011, 8'b01110011, 8'b01110010, 8'b01110010, 8'b01110010, 8'b01110001, 8'b01110001, 
	8'b01110001, 8'b01110000, 8'b01110000, 8'b01101111, 8'b01101111, 8'b01101111, 8'b01101110, 8'b01101110, 
	8'b01101101, 8'b01101101, 8'b01101101, 8'b01101100, 8'b01101100, 8'b01101011, 8'b01101011, 8'b01101010, 
	8'b01101010, 8'b01101010, 8'b01101001, 8'b01101001, 8'b01101000, 8'b01101000, 8'b01100111, 8'b01100111, 
	8'b01100110, 8'b01100110, 8'b01100101, 8'b01100101, 8'b01100100, 8'b01100100, 8'b01100011, 8'b01100011, 
	8'b01100010, 8'b01100010, 8'b01100001, 8'b01100001, 8'b01100000, 8'b01100000, 8'b01011111, 8'b01011111, 
	8'b01011110, 8'b01011110, 8'b01011101, 8'b01011101, 8'b01011100, 8'b01011100, 8'b01011011, 8'b01011011, 
	8'b01011010, 8'b01011001, 8'b01011001, 8'b01011000, 8'b01011000, 8'b01010111, 8'b01010111, 8'b01010110, 
	8'b01010101, 8'b01010101, 8'b01010100, 8'b01010100, 8'b01010011, 8'b01010010, 8'b01010010, 8'b01010001, 
	8'b01010001, 8'b01010000, 8'b01001111, 8'b01001111, 8'b01001110, 8'b01001110, 8'b01001101, 8'b01001100, 
	8'b01001100, 8'b01001011, 8'b01001010, 8'b01001010, 8'b01001001, 8'b01001000, 8'b01001000, 8'b01000111, 
	8'b01000111, 8'b01000110, 8'b01000101, 8'b01000101, 8'b01000100, 8'b01000011, 8'b01000011, 8'b01000010, 
	8'b01000001, 8'b01000001, 8'b01000000, 8'b00111111, 8'b00111110, 8'b00111110, 8'b00111101, 8'b00111100, 
	8'b00111100, 8'b00111011, 8'b00111010, 8'b00111010, 8'b00111001, 8'b00111000, 8'b00111000, 8'b00110111, 
	8'b00110110, 8'b00110101, 8'b00110101, 8'b00110100, 8'b00110011, 8'b00110011, 8'b00110010, 8'b00110001, 
	8'b00110000, 8'b00110000, 8'b00101111, 8'b00101110, 8'b00101101, 8'b00101101, 8'b00101100, 8'b00101011, 
	8'b00101010, 8'b00101010, 8'b00101001, 8'b00101000, 8'b00100111, 8'b00100111, 8'b00100110, 8'b00100101, 
	8'b00100100, 8'b00100100, 8'b00100011, 8'b00100010, 8'b00100001, 8'b00100001, 8'b00100000, 8'b00011111, 
	8'b00011110, 8'b00011110, 8'b00011101, 8'b00011100, 8'b00011011, 8'b00011011, 8'b00011010, 8'b00011001, 
	8'b00011000, 8'b00011000, 8'b00010111, 8'b00010110, 8'b00010101, 8'b00010100, 8'b00010100, 8'b00010011, 
	8'b00010010, 8'b00010001, 8'b00010001, 8'b00010000, 8'b00001111, 8'b00001110, 8'b00001101, 8'b00001101, 
	8'b00001100, 8'b00001011, 8'b00001010, 8'b00001010, 8'b00001001, 8'b00001000, 8'b00000111, 8'b00000110, 
	8'b00000110, 8'b00000101, 8'b00000100, 8'b00000011, 8'b00000010, 8'b00000010, 8'b00000001, 8'b00000000
}; 

wire ival = ^x[9:8];
assign y = qcos[x[7:0] ^ {8{x[8]}}] ^ {~ival,{7{ival}}};

endmodule

