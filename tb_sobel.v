`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.12.2025 19:51:42
// Design Name: 
// Module Name: tb_sobel
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

module tb_sobel;

    parameter WIDTH = 100;
    parameter HEIGHT = 100;
    parameter IMG_SIZE = WIDTH * HEIGHT;

    reg [7:0] in_mem [0:IMG_SIZE-1];

    reg [7:0] p11, p12, p13;
    reg [7:0] p21, p22, p23;
    reg [7:0] p31, p32, p33;

    wire [7:0] out_pixel;

    integer row, col, file_id;

    sobel_calc uut (
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .out_pixel(out_pixel)
    );

    initial begin
        $readmemh("C:/Users/Devarsh/OneDrive/Documents/Desktop/Img_accelaratir/image.hex", in_mem);

        file_id = $fopen("C:/Users/Devarsh/OneDrive/Documents/Desktop/Img_accelaratir/output.hex", "w");
        if (file_id == 0) begin
            $display("Error: Could not open output file!");
            $stop;
        end

        for (row = 1; row < HEIGHT-1; row = row + 1) begin
            for (col = 1; col < WIDTH-1; col = col + 1) begin
                p11 = in_mem[(row-1)*WIDTH + (col-1)];
                p12 = in_mem[(row-1)*WIDTH + (col)];
                p13 = in_mem[(row-1)*WIDTH + (col+1)];

                p21 = in_mem[(row)*WIDTH + (col-1)];
                p22 = in_mem[(row)*WIDTH + (col)];
                p23 = in_mem[(row)*WIDTH + (col+1)];

                p31 = in_mem[(row+1)*WIDTH + (col-1)];
                p32 = in_mem[(row+1)*WIDTH + (col)];
                p33 = in_mem[(row+1)*WIDTH + (col+1)];

                #10;
                $fwrite(file_id, "%2h\n", out_pixel);
            end
        end

        $fclose(file_id);
        $display("------------------------------------------------");
        $display("SUCCESS: Image processed and saved to output.hex");
        $display("------------------------------------------------");
        $stop;
    end

endmodule

