//================================================
//  University  : UIT - www.uit.edu.vn
//  Course name : System-on-Chip Design
//  Lab name    : lab3
//  File name   : tb.v
//  Author      : Pham Thanh Hung
//  Date        : Oct 21, 2017
//  Version     : 1.0
//-------------------------------------------------
// Modification History
//
//================================================
`timescale 1ns/100ps
module top_testbench(
output [31:0] _$1,
output [31:0] _$2,
output [31:0] _$3,
output [31:0] _$4,
output [31:0] _$5,
output [31:0] _$6,
output [31:0] _$7,
output [31:0] _$8,
output [31:0] _$9,
output [31:0] _$10,
output [31:0] _$11,
output [31:0] _$12,
output [31:0] _$13,
output branch
);

assign _$1 = DUT.regf[1];
assign _$2 = DUT.regf[2];
assign _$3 = DUT.regf[3];
assign _$4 = DUT.regf[4];
assign _$5 = DUT.regf[5];
assign _$6 = DUT.regf[6];
assign _$7 = DUT.regf[7];
assign _$8 = DUT.regf[8];
assign _$9 = DUT.regf[9];
assign _$10 = DUT.regf[10];
assign _$11 = DUT.regf[11];
assign _$12 = DUT.regf[12];
assign _$13 = DUT.regf[13];
assign branch = act_branch;

parameter CLK_LO = 10;

//clock gen
reg clk;
reg rst;
wire[31:0] prg_addr;
wire[31:0] prg_data;
wire[31:0] raddr;
wire[31:0] waddr;
wire[31:0] wdata;
wire we;
wire re;
wire[31:0] rdata;

//clock gen

initial begin
    clk=0;
end
always #(CLK_LO) clk = ~clk;

//reset gen
initial begin
    rst = 1;
    repeat(1) @(negedge clk);
    rst = 0;
end

//instantiate 
//--processor
pipeline_processor DUT(
//input
.clk(clk),
.rst(rst),
.prg_data(prg_data),
.dmem_rdata(rdata),
//output
.prg_addr(prg_addr),
.raddr_dmem(raddr),
.waddr_dmem(waddr),
.wdata_dmem(wdata),
.write_dmem(we),
.read_dmem(re)
);

//--data mem
ram ram(
//input
.wdata(wdata),
.we(we),
.re(re),
.waddr(waddr),
.raddr(raddr),
//output
.rdata(rdata)
);

//--instruction rom
rom rom(
//input
.addr(prg_addr),
//output
.data(prg_data)
);

initial begin
    repeat(500) @(posedge clk);
    $display("***********END SIMULATION***********");
    $finish();
end
// respectively to $1, $2 ... $12, $13
reg [31:0] r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13;    
reg act_branch;
//Monitor
initial begin
    @(negedge rst);
    //  lui $2, 5		# $2 = 5 << 16
    repeat(5) @(posedge clk);
    r2 = 5 << 16;
    if(DUT.regf[2] !== (r2)) begin
       $display("ERROR.Command 'lui $2, 5': EXP:%h, ACT:%h.", r2, DUT.regf[2]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'lui $2, 5': EXP:%h, ACT:%h.", $time, r2, DUT.regf[2]);
    end
    
    //  lui $3, 13		# $3 = 13 << 16
    repeat(1) @(posedge clk);
    r3 = 13 << 16;
    if(DUT.regf[3] !== (r3)) begin
       $display("ERROR.Command 'lui $3, 13': EXP:%h, ACT:%h.", r3, DUT.regf[3]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'lui $3, 13': EXP:%h, ACT:%h.", $time, r3, DUT.regf[3]);
    end
    
    //  addi $4, $0, 19		# $4 = 19
    repeat(1) @(posedge clk);
    r4 = 19;
    if(DUT.regf[4] !== (r4)) begin
       $display("ERROR.Command 'addi $4, $0, 19': EXP:%h, ACT:%h.", r4, DUT.regf[4]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'addi $4, $0, 19': EXP:%h, ACT:%h.", $time, r4, DUT.regf[4]);
    end
    
    //  addi $5, $0, 12		# $5 = 12
    repeat(1) @(posedge clk);
    r5 = 12;
    if(DUT.regf[5] !== (r5)) begin
       $display("ERROR.Command 'addi $5, $0, 12': EXP:%h, ACT:%h.", r5, DUT.regf[5]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'addi $5, $0, 12': EXP:%h, ACT:%h.", $time, r5, DUT.regf[5]);
    end
    
    // addi $13, $0, -356	# $13 = -356
    repeat(1) @(posedge clk);
    r13 = -356;
    if(DUT.regf[13] !== (r13)) begin
       $display("ERROR.Command 'addi $13, $0, -356': EXP:%h, ACT:%h.", r13, DUT.regf[13]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'addi $13, $0, -356': EXP:%h, ACT:%h.", $time, r13, DUT.regf[13]);
    end
    
    //  add $1, $2, $3		# $1 = (5 << 16) + (13 << 16)
    repeat(1) @(posedge clk);
    r1 = r2 + r3;
    if(DUT.regf[1] != (r1)) begin
       $display("[%0t] ERROR.Command 'add $1, $2, $3': EXP:%h, ACT:%h.", $time, r1, DUT.regf[1]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'add $1, $2, $3': EXP:%h, ACT:%h.", $time, r1, DUT.regf[1]);
    end
    
    //  sub $6, $3, $2		# $6 = (13 << 16) + (5 << 16)
    repeat(1) @(posedge clk);
    r6 = r3 - r2;
    if(DUT.regf[6] != (r6)) begin
       $display("[%0t] ERROR.Command 'sub $6, $3, $2': EXP:%h, ACT:%h.", $time, r6, DUT.regf[6]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'sub $6, $3, $2': EXP:%h, ACT:%h.", $time, r6, DUT.regf[6]);
    end
    
    //  sw $3, 0($5)		# [0(12)] = 13 << 16
    repeat(1) @(posedge clk);
    if(ram.mem[r5] != (r3)) begin
       $display("[%0t] ERROR.Command 'sw $3, 0($5)': EXP mem([0($5)]):%h, ACT mem([0($5)]):%h.", $time, r3, ram.mem[r5]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'sw $3, 0($5)': EXP mem([0($5)]):%h, ACT mem([0($5)]):%h.", $time, r3, ram.mem[r5]);
    end
    
    //  and $7, $2, $3		# $7 = (5 << 16) & (13 << 16)
    repeat(1) @(posedge clk);
    r7 = r2 & r3;
    if(DUT.regf[7] != (r7)) begin
       $display("[%0t] ERROR.Command 'and $7, $2, $3': EXP:%h, ACT:%h.", $time, r7, DUT.regf[7]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'and $7, $2, $3': EXP:%h, ACT:%h.", $time, r7, DUT.regf[7]);
    end
    
    //  or  $8, $2, $3		# $7 = (5 << 16) | (13 << 16)
    repeat(1) @(posedge clk);
    r8 = r2 | r3;
    if(DUT.regf[8] != (r8)) begin
       $display("[%0t] ERROR.Command 'or  $8, $2, $3': EXP:%h, ACT:%h.", $time, r8, DUT.regf[8]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'or  $8, $2, $3': EXP:%h, ACT:%h.", $time, r8, DUT.regf[8]);
    end
    
    //  slt $9, $2, $3		# $9 = (5 << 16) < (13 << 16)
    repeat(1) @(posedge clk);
    r9 = $signed(r2) < $signed(r3);
    if(DUT.regf[9] != (r9)) begin
       $display("[%0t] ERROR.Command 'slt $9, $2, $3': EXP:%h, ACT:%h.", $time, r9, DUT.regf[9]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'slt $9, $2, $3': EXP:%h, ACT:%h.", $time, r9, DUT.regf[9]);
    end
    
    //  slt $12, $13, $3		
    repeat(1) @(posedge clk);
    r12 = $signed(r13) < $signed(r3);
    if(DUT.regf[12] != (r12)) begin
       $display("[%0t] ERROR.Command 'slt $12, $13, $3': EXP:%h, ACT:%h.", $time, r12, DUT.regf[12]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'slt $12, $13, $3': EXP:%h, ACT:%h.", $time, r12, DUT.regf[12]);
    end
    
    //  lw $10, 0($5)		# $10 = $3 = [0(12)] = 13 << 16
    repeat(1) @(posedge clk);
    r10 = r3;
    if(DUT.regf[10] != r10) begin
       $display("[%0t] ERROR.Command 'lw $10, 0($5)': EXP:%h, ACT:%h.", $time, r10, DUT.regf[10]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'lw $10, 0($5)': EXP:%h, ACT:%h.", $time, r10, DUT.regf[10]);
    end
    
    //  sw $1, 0($5)		# [0(12)] = (5 << 16) + (13 << 16)
    repeat(1) @(posedge clk);
    if(ram.mem[r5] != (r1)) begin
       $display("[%0t] ERROR.Command 'sw $1, 0($5)': EXP mem([0($5)]):%h, ACT mem([0($5)]):%h.", $time, r1, ram.mem[r5]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'sw $1, 0($5)': EXP mem([0($5)]):%h, ACT mem([0($5)]):%h.", $time, r1, ram.mem[r5]);
    end
    
    //  addi $4, $0, 121		# $4 = 121
    repeat(1) @(posedge clk);
    act_branch = DUT.pc_src;
    r4 = 121;
    if(DUT.regf[4] !== (r4)) begin
       $display("ERROR.Command 'addi $4, $0, 121': EXP:%h, ACT:%h.", r4, DUT.regf[4]);
       $display("End by testcase");
       $finish();
    end else begin
        $display("[%0t] Command 'addi $4, $0, 121': EXP:%h, ACT:%h.", $time, r4, DUT.regf[4]);
    end
    
    //  beq $10, $3, Exit 	# Branch
    if(act_branch == 1) begin   // enable pc_src signal to choose pc + 4 + imm
        $display("[%0t] Command 'beq $10, $3, Exit': EXP(pc_src):%1b, ACT(pc_src):%1b.", $time, 1, act_branch);
    end else begin
        $display("[%0t] ERROR.Command 'beq $10, $3, Exit': EXP(pc_src):%1b, ACT(pc_src):%1b.", $time, 1, act_branch);
        $display("End by testcase");
        $finish();
    end
    repeat(1) @(posedge clk);   // 1 clock for branch and terminate the program
    
    $display("***************PASSED***************");
end
endmodule
