`timescale 1ns / 1ps

module EX_MEM_Register(
    clk,
    rst,
    zero_EX,
    write_regf_EX,
    write_dmem_EX,
    read_dmem_EX,
    mem_to_reg_EX,
    is_branch_EX,
    
    zero_MEM,
    write_regf_MEM,
    write_dmem_MEM,
    read_dmem_MEM,
    mem_to_reg_MEM,
    is_branch_MEM,
    
    pc_temp_EX,
    alu_result_EX,
    regf_rdata2_EX,
    waddr_regf_EX,
    
    pc_temp_MEM,
    alu_result_MEM,
    regf_rdata2_MEM,
    waddr_regf_MEM
    );
    
    input clk;
    input rst;
    input zero_EX;
    input write_regf_EX;
    input write_dmem_EX;
    input read_dmem_EX;
    input mem_to_reg_EX;
    input is_branch_EX;
    
    output reg zero_MEM;
    output reg write_regf_MEM;
    output reg write_dmem_MEM;
    output reg read_dmem_MEM;
    output reg mem_to_reg_MEM;
    output reg is_branch_MEM;
    
    input [31:0] pc_temp_EX;
    input [31:0] alu_result_EX;
    input [31:0] regf_rdata2_EX;
    input [4:0] waddr_regf_EX;
    
    output reg [31:0] pc_temp_MEM;
    output reg [31:0] alu_result_MEM;
    output reg [31:0] regf_rdata2_MEM;
    output reg [4:0] waddr_regf_MEM;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            zero_MEM <= 1'b0;
            write_regf_MEM <= 1'b0;
            write_dmem_MEM <= 1'b0;
            read_dmem_MEM <= 1'b0;
            mem_to_reg_MEM <= 1'b0;
            is_branch_MEM <= 1'b0;
            
            pc_temp_MEM <= 32'd0;
            alu_result_MEM <= 32'd0;
            regf_rdata2_MEM <= 32'd0;
            waddr_regf_MEM <= 5'd0;
        end
        else begin 
            zero_MEM <= zero_EX;
            write_regf_MEM <= write_regf_EX;
            write_dmem_MEM <= write_dmem_EX;
            read_dmem_MEM <= read_dmem_EX;
            mem_to_reg_MEM <= mem_to_reg_EX;
            is_branch_MEM <= is_branch_EX;
            
            pc_temp_MEM <= pc_temp_EX;
            alu_result_MEM <= alu_result_EX;
            regf_rdata2_MEM <= regf_rdata2_EX;
            waddr_regf_MEM <= waddr_regf_EX;
        end
    end
    
endmodule
