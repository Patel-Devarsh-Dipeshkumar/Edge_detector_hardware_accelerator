`timescale 1ns / 1ps

module sobel_pipelined (
    input  wire        clk,
    input  wire        rst,
    input  wire [7:0]  p11, p12, p13,
    input  wire [7:0]  p21, p22, p23,
    input  wire [7:0]  p31, p32, p33,
    input  wire        valid_in,
    output reg  [7:0]  out_pixel,
    output reg         valid_out
);

    // --- Stage 1: compute Gx and Gy (registered) ---
    reg signed [10:0] gx_s1, gy_s1;
    reg valid_s1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gx_s1    <= 0;
            gy_s1    <= 0;
            valid_s1 <= 0;
        end else begin
            gx_s1    <= ($signed({1'b0, p13}) + ($signed({1'b0, p23}) << 1) + $signed({1'b0, p33}))
                      - ($signed({1'b0, p11}) + ($signed({1'b0, p21}) << 1) + $signed({1'b0, p31}));
            gy_s1    <= ($signed({1'b0, p31}) + ($signed({1'b0, p32}) << 1) + $signed({1'b0, p33}))
                      - ($signed({1'b0, p11}) + ($signed({1'b0, p12}) << 1) + $signed({1'b0, p13}));
            valid_s1 <= valid_in;
        end
    end

    // --- Stage 2: abs + sum + clamp (registered) ---
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_pixel <= 0;
            valid_out <= 0;
        end else begin
            automatic reg [10:0] abs_gx, abs_gy, sum;
            abs_gx    = (gx_s1 < 0) ? -gx_s1 : gx_s1;
            abs_gy    = (gy_s1 < 0) ? -gy_s1 : gy_s1;
            sum       = abs_gx + abs_gy;
            out_pixel <= (sum > 255) ? 8'hFF : sum[7:0];
            valid_out <= valid_s1;
        end
    end

endmodule
