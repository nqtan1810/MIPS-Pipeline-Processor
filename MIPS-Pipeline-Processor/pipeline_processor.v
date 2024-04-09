
//================================================
//  University  : UIT - www.uit.edu.vn
//  Course name : System-on-Chip Design
//  Lab name    : lab1
//  File name   : pipeline_processor.v
//  Author      : Pham Thanh Hung
//  Date        : Oct 21, 2017
//  Version     : 1.0
//-------------------------------------------------
// Modification History
//
//=================================================

`timescale 1ns / 1ps

module pipeline_processor(
//input
clk,
rst,
prg_data,
dmem_rdata,
//output
prg_addr,
raddr_dmem,
waddr_dmem,
wdata_dmem,
write_dmem,
read_dmem
);

parameter R_OP =  6'b00_0000;
parameter LW_OP =  6'b10_0011 ;
parameter SW_OP =  6'b10_1011;
parameter BEQ_OP =  6'b00_0100;
parameter ADDI_OP =  6'b00_1000;
parameter LUI_OP = 6'b00_1111;

parameter ADD_FUNC = 6'b10_0000;
parameter SUB_FUNC =  6'b10_0010;
parameter AND_FUNC =  6'b10_0100;
parameter OR_FUNC =  6'b10_0101;
parameter SLT_FUNC =  6'b10_1010;
//parameter ADDI_FUNC =  6'b00_1000;
//parameter LUI_FUNC =  6'b00_1111;

//input
input clk; //main clock
input rst; //reset
input [31:0] prg_data;
input [31:0] dmem_rdata; //data memory


//output
output [31:0] prg_addr;
output [31:0] raddr_dmem;//data memory
output [31:0] waddr_dmem;//data memory
output [31:0] wdata_dmem;//data memory
output write_dmem;//data memory
output read_dmem;//data memory


//User declaration
wire [31:0] inst; //instruction
wire [31:0] inst_ID;
//Register file declaration
reg [31:0] regf [0:31]; //32 registers

wire [4:0] raddr1_regf;
wire [4:0] raddr2_regf;
wire [4:0] waddr_regf;
wire [4:0] waddr_regf_MEM;
wire [4:0] waddr_regf_WB;

wire [31:0] wdata_regf;
reg [31:0] regf_rdata1;
wire [31:0] regf_rdata1_EX;
reg [31:0] regf_rdata2;
wire [31:0] regf_rdata2_EX;
wire [31:0] regf_rdata2_MEM;

reg write_regf;
wire write_regf_EX;
wire write_regf_MEM;
wire write_regf_WB;

//Data Memory Controller
wire [31:0] raddr_dmem;
wire [31:0] waddr_dmem;
wire [31:0] wdata_dmem;
wire [31:0] dmem_rdata;
wire [31:0] dmem_rdata_WB;

wire write_dmem;
reg write_dmem_ID;
wire write_dmem_EX;
wire write_dmem_MEM;
wire read_dmem;
reg read_dmem_ID;
wire read_dmem_EX;
wire read_dmem_MEM;

//ALU declaration
reg [2:0] aluop;
wire [2:0] aluop_EX;
wire [31:0] op1_alu;
wire [31:0] op2_alu;
reg [31:0] alu_result;
wire [31:0] alu_result_MEM;
wire [31:0] alu_result_WB;
reg zero;
wire zero_MEM;

//Data path declaration
reg [31:0] pc;
wire [31:0] pc_incr4;
wire [31:0] pc_incr4_ID;
wire [31:0] pc_incr4_EX;
wire [31:0] pc_temp;
wire [31:0] pc_temp_MEM;
wire [5:0] op;
wire [5:0] func;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rt_EX;
wire [4:0] rd;
wire [4:0] rd_EX;
wire [15:0] imm;
wire [31:0] imm_signed;
wire [31:0] imm_signed_EX;

//Control unit declaration
reg alu_src;
wire alu_src_EX;
//reg [2:0] alu_op;
//wire [2:0] alu_op_EX;
reg reg_dst;
wire reg_dst_EX;
reg mem_to_reg;
wire mem_to_reg_EX;
wire mem_to_reg_MEM;
wire mem_to_reg_WB;
wire pc_src;
reg is_branch;
wire is_branch_EX;
wire is_branch_MEM;

//=======================
// IF/ID Pipeline Registers
IF_ID_Register pipelined_if_reg(
    .clk(clk),
    .rst(rst),
    .pc_incr4_IF(pc_incr4),
    .inst_IF(inst),
    .pc_incr4_ID(pc_incr4_ID),
    .inst_ID(inst_ID)  
);
                
// ID/EX Pipeline Registers
ID_EX_Register pipelined_id_reg(
    .clk(clk),
    .rst(rst),
    .reg_dst_ID(reg_dst),
    .write_regf_ID(write_regf),
    .alu_src_ID(alu_src),
    .aluop_ID(aluop),
    .write_dmem_ID(write_dmem_ID),
    .read_dmem_ID(read_dmem_ID),
    .mem_to_reg_ID(mem_to_reg),
    .is_branch_ID(is_branch),
    
    .reg_dst_EX(reg_dst_EX),
    .write_regf_EX(write_regf_EX),
    .alu_src_EX(alu_src_EX),
    .aluop_EX(aluop_EX),
    .write_dmem_EX(write_dmem_EX),
    .read_dmem_EX(read_dmem_EX),
    .mem_to_reg_EX(mem_to_reg_EX),
    .is_branch_EX(is_branch_EX),
    
    .pc_incr4_ID(pc_incr4_ID),
    .regf_rdata1_ID(regf_rdata1),
    .regf_rdata2_ID(regf_rdata2),
    .imm_signed_ID(imm_signed),
    .rt_ID(rt),
    .rd_ID(rd),
    
    .pc_incr4_EX(pc_incr4_EX),
    .regf_rdata1_EX(regf_rdata1_EX),
    .regf_rdata2_EX(regf_rdata2_EX),
    .imm_signed_EX(imm_signed_EX),
    .rt_EX(rt_EX),
    .rd_EX(rd_EX)
);

EX_MEM_Register pipelined_mem_reg(
    .clk(clk),
    .rst(rst),
    .zero_EX(zero),
    .write_regf_EX(write_regf_EX),
    .write_dmem_EX(write_dmem_EX),
    .read_dmem_EX(read_dmem_EX),
    .mem_to_reg_EX(mem_to_reg_EX),
    .is_branch_EX(is_branch_EX),
    
    .zero_MEM(zero_MEM),
    .write_regf_MEM(write_regf_MEM),
    .write_dmem_MEM(write_dmem_MEM),
    .read_dmem_MEM(read_dmem_MEM),
    .mem_to_reg_MEM(mem_to_reg_MEM),
    .is_branch_MEM(is_branch_MEM),
    
    .pc_temp_EX(pc_temp),
    .alu_result_EX(alu_result),
    .regf_rdata2_EX(regf_rdata2_EX),
    .waddr_regf_EX(waddr_regf),
    
    .pc_temp_MEM(pc_temp_MEM),
    .alu_result_MEM(alu_result_MEM),
    .regf_rdata2_MEM(regf_rdata2_MEM),
    .waddr_regf_MEM(waddr_regf_MEM)
);

MEM_WB_Register pipelined_wb_reg(
    .clk(clk),
    .rst(rst),
    .write_regf_MEM(write_regf_MEM),
    .mem_to_reg_MEM(mem_to_reg_MEM),
    
    .write_regf_WB(write_regf_WB),
    .mem_to_reg_WB(mem_to_reg_WB),
    
    .dmem_rdata_MEM(dmem_rdata),
    .alu_result_MEM(alu_result_MEM),
    .waddr_regf_MEM(waddr_regf_MEM),
    
    .dmem_rdata_WB(dmem_rdata_WB),
    .alu_result_WB(alu_result_WB),
    .waddr_regf_WB(waddr_regf_WB)
);

//---------------------------
//Register File
//write to reg file
always @(*) begin
    if(write_regf_WB && waddr_regf_WB != 0) begin
        regf[waddr_regf_WB] <= wdata_regf;
    end
    //$writememb(PATH, regf);
end

always @(*) begin
    regf_rdata1 = (raddr1_regf != 0) ? regf[raddr1_regf] : 0;
    regf_rdata2 = (raddr2_regf != 0) ? regf[raddr2_regf] : 0;
end

//complete your code here

//---------------------------
//Data Mem
assign raddr_dmem = alu_result_MEM;
assign waddr_dmem = alu_result_MEM;
//assign regf_rdata2_EX = wdata_dmem;
assign wdata_dmem = regf_rdata2_MEM;
assign write_dmem = write_dmem_MEM;
assign read_dmem = read_dmem_MEM;


//---------------------------
//ALU operation
always @(*) begin
    casex (aluop_EX)
        3'b000: alu_result = op1_alu & op2_alu;
        3'b001: alu_result = op1_alu | op2_alu;
        3'b010: alu_result = op1_alu + op2_alu;
        3'b011: alu_result = op2_alu << 16;     // LUI
        3'b110: alu_result = op1_alu - op2_alu;
        3'b111: alu_result = $signed(op1_alu) < $signed(op2_alu);
        default: alu_result = 0;	
    endcase
    zero = (alu_result === 32'd0) ? 1'b1 : 1'b0;
end

//complete your code here

//---------------------------
// Data Path
assign inst = prg_data;
assign op = inst_ID[31:26];
assign func = inst_ID[5:0];
assign rs = inst_ID[25:21];
assign rt = inst_ID[20:16];
assign rd = inst_ID[15:11];
assign imm = inst_ID[15:0];
assign imm_signed = {{16{imm[15]}},imm[15:0]};

//To Reg File
assign raddr1_regf = rs;
assign raddr2_regf = rt;
assign wdata_regf = (mem_to_reg_WB) ? dmem_rdata_WB : alu_result_WB;
assign waddr_regf = (reg_dst_EX) ? rd_EX : rt_EX;

// To ALU
assign op1_alu = regf_rdata1_EX;
assign op2_alu = (alu_src_EX) ? imm_signed_EX : regf_rdata2_EX;

//PC
assign pc_src = (zero_MEM && is_branch_MEM) ? 1'b1 : 1'b0;
assign prg_addr = pc;
assign pc_incr4 = pc + 4;
assign pc_temp = pc_incr4_EX + (imm_signed_EX << 2);

always @(posedge clk or posedge rst) begin
    if(rst) begin
        pc <= 0;
    end
    else begin
        pc <= (pc_src) ? pc_temp_MEM : pc_incr4;
    end
end

// Control unit
always @(*) begin
    case(op)
        R_OP:      // R types
            case(func)
                ADD_FUNC: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b1100100000; // ADD
                SUB_FUNC: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b1101100000; // SUB
                AND_FUNC: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b1100000000; // AND
                OR_FUNC: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b1100010000; // OR
                SLT_FUNC: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b1101110000; // SLT
                default: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'bx0xxxx00x0;
            endcase
        LW_OP: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b0110100110; // LW
        SW_OP: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'bx0101010x0; // SW
        BEQ_OP: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'bx0011000x1; // BEQ
        ADDI_OP: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b0110100000; // ADDI
        LUI_OP: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'b0110110000; // LUI
        default: {reg_dst, write_regf, alu_src, aluop, write_dmem_ID, read_dmem_ID, mem_to_reg, is_branch} = 10'bx0xxxx00x0;
    endcase
end

//assign pc_src = (|alu_result[31:0] && is_branch) ? 1'b1 : 1'b0;

endmodule
