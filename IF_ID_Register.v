`timescale 1ns / 1ps

module IF_ID_Register(
    clk,
    rst,
    
    // pipeline data signals
    pc_incr4_IF,
    inst_IF,
    
    pc_incr4_ID,
    inst_ID  
);

    input clk;
    input rst;
    input [31 : 0] pc_incr4_IF;
    input [31 : 0] inst_IF;
    
    output reg [31 : 0] pc_incr4_ID;
    output reg [31 : 0] inst_ID;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_incr4_ID <= 32'd0;
            inst_ID <= 32'd0;
        end
        else begin
            pc_incr4_ID <= pc_incr4_IF;
            inst_ID <= inst_IF;
        end
    end

endmodule
