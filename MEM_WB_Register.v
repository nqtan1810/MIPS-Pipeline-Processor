`timescale 1ns / 1ps

module MEM_WB_Register(
    clk,
    rst,
    write_regf_MEM,
    mem_to_reg_MEM,
    
    write_regf_WB,
    mem_to_reg_WB,
    
    dmem_rdata_MEM,
    alu_result_MEM,
    waddr_regf_MEM,
    
    dmem_rdata_WB,
    alu_result_WB,
    waddr_regf_WB
    );
    
    input clk;
    input rst;
    input write_regf_MEM;
    input mem_to_reg_MEM;
    
    output reg write_regf_WB;
    output reg mem_to_reg_WB;
    
    input [31:0] dmem_rdata_MEM;
    input [31:0] alu_result_MEM;
    input [4:0] waddr_regf_MEM;
    
    output reg [31:0] dmem_rdata_WB;
    output reg [31:0] alu_result_WB;
    output reg [4:0] waddr_regf_WB;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            write_regf_WB <= 1'b0;
            mem_to_reg_WB <= 1'b0;
            
            dmem_rdata_WB <= 32'd0;
            alu_result_WB <= 32'd0;
            waddr_regf_WB <= 32'd0;
        end
        else begin 
            write_regf_WB <= write_regf_MEM;
            mem_to_reg_WB <= mem_to_reg_MEM;
            
            dmem_rdata_WB <= dmem_rdata_MEM;
            alu_result_WB <= alu_result_MEM;
            waddr_regf_WB <= waddr_regf_MEM;
        end
    end
    
endmodule
