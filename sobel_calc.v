`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2025 19:42:41
// Design Name: 
// Module Name: sobel_calc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sobel_calc(
    input  [7:0] p11, p12, p13,
    input  [7:0] p21, p22, p23,
    input  [7:0] p31, p32, p33,
    output reg [7:0] out_pixel
);

    reg signed [10:0] gx, gy;
    reg [10:0] abs_gx, abs_gy;
    reg [10:0] sum;

    always @(*) begin
        gx = (p13 + (p23 << 1) + p33) - (p11 + (p21 << 1) + p31);
        gy = (p31 + (p32 << 1) + p33) - (p11 + (p12 << 1) + p13);

        abs_gx = (gx < 0) ? -gx : gx;
        abs_gy = (gy < 0) ? -gy : gy;

        sum = abs_gx + abs_gy;

        if (sum > 255)
            out_pixel = 8'hFF;
        else
            out_pixel = sum[7:0];
    end

endmodule

endmodule