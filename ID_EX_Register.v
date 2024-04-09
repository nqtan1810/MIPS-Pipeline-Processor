`timescale 1ns / 1ps

module ID_EX_Register(
    clk,
    rst,
    reg_dst_ID,
    write_regf_ID,
    alu_src_ID,
    aluop_ID,
    write_dmem_ID,
    read_dmem_ID,
    mem_to_reg_ID,
    is_branch_ID,
    
    reg_dst_EX,
    write_regf_EX,
    alu_src_EX,
    aluop_EX,
    write_dmem_EX,
    read_dmem_EX,
    mem_to_reg_EX,
    is_branch_EX,
    
    pc_incr4_ID,
    regf_rdata1_ID,
    regf_rdata2_ID,
    imm_signed_ID,
    rt_ID,
    rd_ID,
    
    pc_incr4_EX,
    regf_rdata1_EX,
    regf_rdata2_EX,
    imm_signed_EX,
    rt_EX,
    rd_EX
);
    
    input clk;
    input rst;
    
    input reg_dst_ID;
    input write_regf_ID;
    input alu_src_ID;
    input [2:0] aluop_ID;
    input write_dmem_ID;
    input read_dmem_ID;
    input mem_to_reg_ID;
    input is_branch_ID;
    
    output reg reg_dst_EX;
    output reg write_regf_EX;
    output reg alu_src_EX;
    output reg [2:0] aluop_EX;
    output reg write_dmem_EX;
    output reg read_dmem_EX;
    output reg mem_to_reg_EX;
    output reg is_branch_EX;
    
    input [31:0] pc_incr4_ID;
    input [31:0] regf_rdata1_ID;
    input [31:0] regf_rdata2_ID;
    input [31:0] imm_signed_ID;
    input [4:0] rt_ID;
    input [4:0] rd_ID;
    
    output reg [31:0] pc_incr4_EX;
    output reg [31:0] regf_rdata1_EX;
    output reg [31:0] regf_rdata2_EX;
    output reg [31:0] imm_signed_EX;
    output reg [4:0] rt_EX;
    output reg [4:0] rd_EX;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            reg_dst_EX <= 1'b0;
            write_regf_EX <= 1'b0;
            alu_src_EX <= 1'b0;
            aluop_EX <= 3'b000;
            write_dmem_EX <= 1'b0;
            read_dmem_EX <= 1'b0;
            mem_to_reg_EX <= 1'b0;
            is_branch_EX <= 1'b0;
            
            pc_incr4_EX <= 32'd0;
            regf_rdata1_EX <= 32'd0;
            regf_rdata2_EX <= 32'd0;
            imm_signed_EX <= 32'd0;
            rt_EX <= 5'd0;
            rd_EX <= 5'd0;
        end
        else begin 
            reg_dst_EX <= reg_dst_ID;
            write_regf_EX <= write_regf_ID;
            alu_src_EX <= alu_src_ID;
            aluop_EX <= aluop_ID;
            write_dmem_EX <= write_dmem_ID;
            read_dmem_EX <= read_dmem_ID;
            mem_to_reg_EX <= mem_to_reg_ID;
            is_branch_EX <= is_branch_ID;
            
            pc_incr4_EX <= pc_incr4_ID;
            regf_rdata1_EX <= regf_rdata1_ID;
            regf_rdata2_EX <= regf_rdata2_ID;
            imm_signed_EX <= imm_signed_ID;
            rt_EX <= rt_ID;
            rd_EX <= rd_ID;
        end
    end

endmodule
