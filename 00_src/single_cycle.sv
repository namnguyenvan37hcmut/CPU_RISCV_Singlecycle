// singlecycle.sv - Top-level module for single-cycle RV32I processor
`define RESET_PERIOD 100
`define CLK_PERIOD   2
`define FINISH       40_000
module singlecycle (
    input wire i_clk,
    input wire i_reset, // Low-active reset
    output wire [31:0] o_pc_debug,
    output wire o_insn_vld,
    output wire [31:0] o_io_ledr,
    output wire [31:0] o_io_ledg,
    output wire [6:0] o_io_hex0,
    output wire [6:0] o_io_hex1,
    output wire [6:0] o_io_hex2,
    output wire [6:0] o_io_hex3,
    output wire [6:0] o_io_hex4,
    output wire [6:0] o_io_hex5,
    output wire [6:0] o_io_hex6,
    output wire [6:0] o_io_hex7,
    output wire [31:0] o_io_lcd,
    input wire [31:0] i_io_sw
);
    wire [31:0] pc, pc_next, pc_four, instr;
    wire [31:0] rs1_data, rs2_data, imm, operand_a, operand_b;
    wire [31:0] alu_data, ld_data, wb_data;
    wire pc_sel, rd_wren, br_un, br_less, br_equal, br_taken;
    wire opa_sel, opb_sel;
    wire [3:0] alu_op;
    wire mem_wren;
    wire [1:0] wb_sel;
    wire [2:0] funct3;
    reg [31:0] pc_reg;
    assign pc = pc_reg;
    assign o_pc_debug = pc;
 // Adder for pc + 4 unrolled without +
wire [32:0] carry;
wire [31:0] add_result;
assign carry[0] = 1'b0; // cin = 0
wire [31:0] b_in = 32'd4;

// Bit 0
assign add_result[0] = pc[0] ^ b_in[0] ^ carry[0];
assign carry[1] = (pc[0] & b_in[0]) | (pc[0] & carry[0]) | (b_in[0] & carry[0]);

// Bit 1
assign add_result[1] = pc[1] ^ b_in[1] ^ carry[1];
assign carry[2] = (pc[1] & b_in[1]) | (pc[1] & carry[1]) | (b_in[1] & carry[1]);

// Bit 2
assign add_result[2] = pc[2] ^ b_in[2] ^ carry[2];
assign carry[3] = (pc[2] & b_in[2]) | (pc[2] & carry[2]) | (b_in[2] & carry[2]);

// Bit 3
assign add_result[3] = pc[3] ^ b_in[3] ^ carry[3];
assign carry[4] = (pc[3] & b_in[3]) | (pc[3] & carry[3]) | (b_in[3] & carry[3]);

// Bit 4
assign add_result[4] = pc[4] ^ b_in[4] ^ carry[4];
assign carry[5] = (pc[4] & b_in[4]) | (pc[4] & carry[4]) | (b_in[4] & carry[4]);

// Bit 5
assign add_result[5] = pc[5] ^ b_in[5] ^ carry[5];
assign carry[6] = (pc[5] & b_in[5]) | (pc[5] & carry[5]) | (b_in[5] & carry[5]);

// Bit 6
assign add_result[6] = pc[6] ^ b_in[6] ^ carry[6];
assign carry[7] = (pc[6] & b_in[6]) | (pc[6] & carry[6]) | (b_in[6] & carry[6]);

// Bit 7
assign add_result[7] = pc[7] ^ b_in[7] ^ carry[7];
assign carry[8] = (pc[7] & b_in[7]) | (pc[7] & carry[7]) | (b_in[7] & carry[7]);

// Bit 8
assign add_result[8] = pc[8] ^ b_in[8] ^ carry[8];
assign carry[9] = (pc[8] & b_in[8]) | (pc[8] & carry[8]) | (b_in[8] & carry[8]);

// Bit 9
assign add_result[9] = pc[9] ^ b_in[9] ^ carry[9];
assign carry[10] = (pc[9] & b_in[9]) | (pc[9] & carry[9]) | (b_in[9] & carry[9]);

// Bit 10
assign add_result[10] = pc[10] ^ b_in[10] ^ carry[10];
assign carry[11] = (pc[10] & b_in[10]) | (pc[10] & carry[10]) | (b_in[10] & carry[10]);

// Bit 11
assign add_result[11] = pc[11] ^ b_in[11] ^ carry[11];
assign carry[12] = (pc[11] & b_in[11]) | (pc[11] & carry[11]) | (b_in[11] & carry[11]);

// Bit 12
assign add_result[12] = pc[12] ^ b_in[12] ^ carry[12];
assign carry[13] = (pc[12] & b_in[12]) | (pc[12] & carry[12]) | (b_in[12] & carry[12]);

// Bit 13
assign add_result[13] = pc[13] ^ b_in[13] ^ carry[13];
assign carry[14] = (pc[13] & b_in[13]) | (pc[13] & carry[13]) | (b_in[13] & carry[13]);

// Bit 14
assign add_result[14] = pc[14] ^ b_in[14] ^ carry[14];
assign carry[15] = (pc[14] & b_in[14]) | (pc[14] & carry[14]) | (b_in[14] & carry[14]);

// Bit 15
assign add_result[15] = pc[15] ^ b_in[15] ^ carry[15];
assign carry[16] = (pc[15] & b_in[15]) | (pc[15] & carry[15]) | (b_in[15] & carry[15]);

// Bit 16
assign add_result[16] = pc[16] ^ b_in[16] ^ carry[16];
assign carry[17] = (pc[16] & b_in[16]) | (pc[16] & carry[16]) | (b_in[16] & carry[16]);

// Bit 17
assign add_result[17] = pc[17] ^ b_in[17] ^ carry[17];
assign carry[18] = (pc[17] & b_in[17]) | (pc[17] & carry[17]) | (b_in[17] & carry[17]);

// Bit 18
assign add_result[18] = pc[18] ^ b_in[18] ^ carry[18];
assign carry[19] = (pc[18] & b_in[18]) | (pc[18] & carry[18]) | (b_in[18] & carry[18]);

// Bit 19
assign add_result[19] = pc[19] ^ b_in[19] ^ carry[19];
assign carry[20] = (pc[19] & b_in[19]) | (pc[19] & carry[19]) | (b_in[19] & carry[19]);

// Bit 20
assign add_result[20] = pc[20] ^ b_in[20] ^ carry[20];
assign carry[21] = (pc[20] & b_in[20]) | (pc[20] & carry[20]) | (b_in[20] & carry[20]);

// Bit 21
assign add_result[21] = pc[21] ^ b_in[21] ^ carry[21];
assign carry[22] = (pc[21] & b_in[21]) | (pc[21] & carry[21]) | (b_in[21] & carry[21]);

// Bit 22
assign add_result[22] = pc[22] ^ b_in[22] ^ carry[22];
assign carry[23] = (pc[22] & b_in[22]) | (pc[22] & carry[22]) | (b_in[22] & carry[22]);

// Bit 23
assign add_result[23] = pc[23] ^ b_in[23] ^ carry[23];
assign carry[24] = (pc[23] & b_in[23]) | (pc[23] & carry[23]) | (b_in[23] & carry[23]);

// Bit 24
assign add_result[24] = pc[24] ^ b_in[24] ^ carry[24];
assign carry[25] = (pc[24] & b_in[24]) | (pc[24] & carry[24]) | (b_in[24] & carry[24]);

// Bit 25
assign add_result[25] = pc[25] ^ b_in[25] ^ carry[25];
assign carry[26] = (pc[25] & b_in[25]) | (pc[25] & carry[25]) | (b_in[25] & carry[25]);

// Bit 26
assign add_result[26] = pc[26] ^ b_in[26] ^ carry[26];
assign carry[27] = (pc[26] & b_in[26]) | (pc[26] & carry[26]) | (b_in[26] & carry[26]);

// Bit 27
assign add_result[27] = pc[27] ^ b_in[27] ^ carry[27];
assign carry[28] = (pc[27] & b_in[27]) | (pc[27] & carry[27]) | (b_in[27] & carry[27]);

// Bit 28
assign add_result[28] = pc[28] ^ b_in[28] ^ carry[28];
assign carry[29] = (pc[28] & b_in[28]) | (pc[28] & carry[28]) | (b_in[28] & carry[28]);

// Bit 29
assign add_result[29] = pc[29] ^ b_in[29] ^ carry[29];
assign carry[30] = (pc[29] & b_in[29]) | (pc[29] & carry[29]) | (b_in[29] & carry[29]);

// Bit 30
assign add_result[30] = pc[30] ^ b_in[30] ^ carry[30];
assign carry[31] = (pc[30] & b_in[30]) | (pc[30] & carry[30]) | (b_in[30] & carry[30]);

// Bit 31
assign add_result[31] = pc[31] ^ b_in[31] ^ carry[31];
assign carry[32] = (pc[31] & b_in[31]) | (pc[31] & carry[31]) | (b_in[31] & carry[31]);

assign pc_four = add_result;
    always @(posedge i_clk or negedge i_reset) begin
        if (!i_reset) pc_reg <= 32'h00000000;
        else pc_reg <= pc_next;
    end
    instr_mem instr_mem_inst (
        .i_addr(pc[12:2]), // 2 KiB, word address (2048 / 4 = 512 words)
        .o_rdata(instr)
    );
    regfile regfile_inst (
        .i_clk(i_clk),
        .i_reset(~i_reset),
        .i_rs1_addr(instr[19:15]),
        .i_rs2_addr(instr[24:20]),
        .o_rs1_data(rs1_data),
        .o_rs2_data(rs2_data),
        .i_rd_addr(instr[11:7]),
        .i_rd_data(wb_data),
        .i_rd_wren(rd_wren)
    );
    imm_gen imm_gen_inst (
        .i_instr(instr),
        .o_imm(imm)
    );
    brc brc_inst (
        .i_rs1_data(rs1_data),
        .i_rs2_data(rs2_data),
        .i_br_un(br_un),
        .o_br_less(br_less),
        .o_br_equal(br_equal)
    );
    alu alu_inst (
        .i_op_a(operand_a),
        .i_op_b(operand_b),
        .i_alu_op(alu_op),
        .o_alu_data(alu_data)
    );
    lsu lsu_inst (
        .i_clk(i_clk),
        .i_reset(~i_reset),
        .i_lsu_addr(alu_data),
        .i_st_data(rs2_data),
        .i_lsu_wren(mem_wren),
        .i_f3(funct3),
        .o_ld_data(ld_data),
        .o_io_ledr(o_io_ledr),
        .o_io_ledg(o_io_ledg),
        .o_io_hex0(o_io_hex0),
        .o_io_hex1(o_io_hex1),
        .o_io_hex2(o_io_hex2),
        .o_io_hex3(o_io_hex3),
        .o_io_hex4(o_io_hex4),
        .o_io_hex5(o_io_hex5),
        .o_io_hex6(o_io_hex6),
        .o_io_hex7(o_io_hex7),
        .o_io_lcd(o_io_lcd),
        .i_io_sw(i_io_sw)
    );
    control_unit control_inst (
        .i_instr(instr),
        .i_br_less(br_less),
        .i_br_equal(br_equal),
        .o_pc_sel(pc_sel),
        .o_rd_wren(rd_wren),
        .o_br_un(br_un),
        .o_br_taken(br_taken),
        .o_opa_sel(opa_sel),
        .o_opb_sel(opb_sel),
        .o_alu_op(alu_op),
        .o_mem_wren(mem_wren),
        .o_wb_sel(wb_sel),
        .o_insn_vld(o_insn_vld),
        .o_f3(funct3)
    );
    assign operand_a = opa_sel ? rs1_data : pc;
    assign operand_b = opb_sel ? imm : rs2_data;
    assign wb_data = (wb_sel == 2'b00) ? alu_data :
                     (wb_sel == 2'b01) ? ld_data :
                     (wb_sel == 2'b10) ? pc_four : 32'b0;
assign pc_next = pc_sel ? 

    ((instr[6:0] == 7'b1100111) ? (alu_data & 32'hFFFFFFFE) : alu_data) : 

    pc_four;

endmodule
// alu.sv
module alu (
    input wire [31:0] i_op_a,
    input wire [31:0] i_op_b,
    input wire [3:0] i_alu_op,
    output wire [31:0] o_alu_data
);
    // Adder/Subtractor unrolled
    wire is_sub = (i_alu_op == 4'b0001) | (i_alu_op == 4'b0010) | (i_alu_op == 4'b0011);
    wire [31:0] b_in = is_sub ? ~i_op_b : i_op_b;
    wire cin = is_sub ? 1'b1 : 1'b0;
    wire [32:0] carry;
    wire [31:0] add_result;
    assign carry[0] = cin;
    assign add_result[0] = i_op_a[0] ^ b_in[0] ^ carry[0];
    assign carry[1] = (i_op_a[0] & b_in[0]) | (i_op_a[0] & carry[0]) | (b_in[0] & carry[0]);
    assign add_result[1] = i_op_a[1] ^ b_in[1] ^ carry[1];
    assign carry[2] = (i_op_a[1] & b_in[1]) | (i_op_a[1] & carry[1]) | (b_in[1] & carry[1]);
    assign add_result[2] = i_op_a[2] ^ b_in[2] ^ carry[2];
    assign carry[3] = (i_op_a[2] & b_in[2]) | (i_op_a[2] & carry[2]) | (b_in[2] & carry[2]);
    assign add_result[3] = i_op_a[3] ^ b_in[3] ^ carry[3];
    assign carry[4] = (i_op_a[3] & b_in[3]) | (i_op_a[3] & carry[3]) | (b_in[3] & carry[3]);
    assign add_result[4] = i_op_a[4] ^ b_in[4] ^ carry[4];
    assign carry[5] = (i_op_a[4] & b_in[4]) | (i_op_a[4] & carry[4]) | (b_in[4] & carry[4]);
    assign add_result[5] = i_op_a[5] ^ b_in[5] ^ carry[5];
    assign carry[6] = (i_op_a[5] & b_in[5]) | (i_op_a[5] & carry[5]) | (b_in[5] & carry[5]);
    assign add_result[6] = i_op_a[6] ^ b_in[6] ^ carry[6];
    assign carry[7] = (i_op_a[6] & b_in[6]) | (i_op_a[6] & carry[6]) | (b_in[6] & carry[6]);
    assign add_result[7] = i_op_a[7] ^ b_in[7] ^ carry[7];
    assign carry[8] = (i_op_a[7] & b_in[7]) | (i_op_a[7] & carry[7]) | (b_in[7] & carry[7]);
    assign add_result[8] = i_op_a[8] ^ b_in[8] ^ carry[8];
    assign carry[9] = (i_op_a[8] & b_in[8]) | (i_op_a[8] & carry[8]) | (b_in[8] & carry[8]);
    assign add_result[9] = i_op_a[9] ^ b_in[9] ^ carry[9];
    assign carry[10] = (i_op_a[9] & b_in[9]) | (i_op_a[9] & carry[9]) | (b_in[9] & carry[9]);
    assign add_result[10] = i_op_a[10] ^ b_in[10] ^ carry[10];
    assign carry[11] = (i_op_a[10] & b_in[10]) | (i_op_a[10] & carry[10]) | (b_in[10] & carry[10]);
    assign add_result[11] = i_op_a[11] ^ b_in[11] ^ carry[11];
    assign carry[12] = (i_op_a[11] & b_in[11]) | (i_op_a[11] & carry[11]) | (b_in[11] & carry[11]);
    assign add_result[12] = i_op_a[12] ^ b_in[12] ^ carry[12];
    assign carry[13] = (i_op_a[12] & b_in[12]) | (i_op_a[12] & carry[12]) | (b_in[12] & carry[12]);
    assign add_result[13] = i_op_a[13] ^ b_in[13] ^ carry[13];
    assign carry[14] = (i_op_a[13] & b_in[13]) | (i_op_a[13] & carry[13]) | (b_in[13] & carry[13]);
    assign add_result[14] = i_op_a[14] ^ b_in[14] ^ carry[14];
    assign carry[15] = (i_op_a[14] & b_in[14]) | (i_op_a[14] & carry[14]) | (b_in[14] & carry[14]);
    assign add_result[15] = i_op_a[15] ^ b_in[15] ^ carry[15];
    assign carry[16] = (i_op_a[15] & b_in[15]) | (i_op_a[15] & carry[15]) | (b_in[15] & carry[15]);
    assign add_result[16] = i_op_a[16] ^ b_in[16] ^ carry[16];
    assign carry[17] = (i_op_a[16] & b_in[16]) | (i_op_a[16] & carry[16]) | (b_in[16] & carry[16]);
    assign add_result[17] = i_op_a[17] ^ b_in[17] ^ carry[17];
    assign carry[18] = (i_op_a[17] & b_in[17]) | (i_op_a[17] & carry[17]) | (b_in[17] & carry[17]);
    assign add_result[18] = i_op_a[18] ^ b_in[18] ^ carry[18];
    assign carry[19] = (i_op_a[18] & b_in[18]) | (i_op_a[18] & carry[18]) | (b_in[18] & carry[18]);
    assign add_result[19] = i_op_a[19] ^ b_in[19] ^ carry[19];
    assign carry[20] = (i_op_a[19] & b_in[19]) | (i_op_a[19] & carry[19]) | (b_in[19] & carry[19]);
    assign add_result[20] = i_op_a[20] ^ b_in[20] ^ carry[20];
    assign carry[21] = (i_op_a[20] & b_in[20]) | (i_op_a[20] & carry[20]) | (b_in[20] & carry[20]);
    assign add_result[21] = i_op_a[21] ^ b_in[21] ^ carry[21];
    assign carry[22] = (i_op_a[21] & b_in[21]) | (i_op_a[21] & carry[21]) | (b_in[21] & carry[21]);
    assign add_result[22] = i_op_a[22] ^ b_in[22] ^ carry[22];
    assign carry[23] = (i_op_a[22] & b_in[22]) | (i_op_a[22] & carry[22]) | (b_in[22] & carry[22]);
    assign add_result[23] = i_op_a[23] ^ b_in[23] ^ carry[23];
    assign carry[24] = (i_op_a[23] & b_in[23]) | (i_op_a[23] & carry[23]) | (b_in[23] & carry[23]);
    assign add_result[24] = i_op_a[24] ^ b_in[24] ^ carry[24];
    assign carry[25] = (i_op_a[24] & b_in[24]) | (i_op_a[24] & carry[24]) | (b_in[24] & carry[24]);
    assign add_result[25] = i_op_a[25] ^ b_in[25] ^ carry[25];
    assign carry[26] = (i_op_a[25] & b_in[25]) | (i_op_a[25] & carry[25]) | (b_in[25] & carry[25]);
    assign add_result[26] = i_op_a[26] ^ b_in[26] ^ carry[26];
    assign carry[27] = (i_op_a[26] & b_in[26]) | (i_op_a[26] & carry[26]) | (b_in[26] & carry[26]);
    assign add_result[27] = i_op_a[27] ^ b_in[27] ^ carry[27];
    assign carry[28] = (i_op_a[27] & b_in[27]) | (i_op_a[27] & carry[27]) | (b_in[27] & carry[27]);
    assign add_result[28] = i_op_a[28] ^ b_in[28] ^ carry[28];
    assign carry[29] = (i_op_a[28] & b_in[28]) | (i_op_a[28] & carry[28]) | (b_in[28] & carry[28]);
    assign add_result[29] = i_op_a[29] ^ b_in[29] ^ carry[29];
    assign carry[30] = (i_op_a[29] & b_in[29]) | (i_op_a[29] & carry[29]) | (b_in[29] & carry[29]);
    assign add_result[30] = i_op_a[30] ^ b_in[30] ^ carry[30];
    assign carry[31] = (i_op_a[30] & b_in[30]) | (i_op_a[30] & carry[30]) | (b_in[30] & carry[30]);
    assign add_result[31] = i_op_a[31] ^ b_in[31] ^ carry[31];
    assign carry[32] = (i_op_a[31] & b_in[31]) | (i_op_a[31] & carry[31]) | (b_in[31] & carry[31]);
    wire borrow = ~carry[32];
    // Barrel Shifter implementation without shift operators
    wire [4:0] shift_amt = i_op_b[4:0];
    reg [31:0] shift_result;
    wire sign_bit = i_op_a[31];
    // Common barrel shifter stages for right shifts (SRL/SRA)
    wire [31:0] stage0 = i_op_a;
    wire [31:0] stage1 = shift_amt[0] ? { (i_alu_op == 4'b1010 ? sign_bit : 1'b0), stage0[31:1] } : stage0;
    wire [31:0] stage2 = shift_amt[1] ? { {(2){(i_alu_op == 4'b1010 ? sign_bit : 1'b0)}}, stage1[31:2] } : stage1;
    wire [31:0] stage3 = shift_amt[2] ? { {(4){(i_alu_op == 4'b1010 ? sign_bit : 1'b0)}}, stage2[31:4] } : stage2;
    wire [31:0] stage4 = shift_amt[3] ? { {(8){(i_alu_op == 4'b1010 ? sign_bit : 1'b0)}}, stage3[31:8] } : stage3;
    wire [31:0] srl_sra_result = shift_amt[4] ? { {(16){(i_alu_op == 4'b1010 ? sign_bit : 1'b0)}}, stage4[31:16] } : stage4;
    // For left shift (SLL), reverse input, do right shift logical, then reverse output
    wire [31:0] reversed_in;
    assign reversed_in[0] = i_op_a[31];
    assign reversed_in[1] = i_op_a[30];
    assign reversed_in[2] = i_op_a[29];
    assign reversed_in[3] = i_op_a[28];
    assign reversed_in[4] = i_op_a[27];
    assign reversed_in[5] = i_op_a[26];
    assign reversed_in[6] = i_op_a[25];
    assign reversed_in[7] = i_op_a[24];
    assign reversed_in[8] = i_op_a[23];
    assign reversed_in[9] = i_op_a[22];
    assign reversed_in[10] = i_op_a[21];
    assign reversed_in[11] = i_op_a[20];
    assign reversed_in[12] = i_op_a[19];
    assign reversed_in[13] = i_op_a[18];
    assign reversed_in[14] = i_op_a[17];
    assign reversed_in[15] = i_op_a[16];
    assign reversed_in[16] = i_op_a[15];
    assign reversed_in[17] = i_op_a[14];
    assign reversed_in[18] = i_op_a[13];
    assign reversed_in[19] = i_op_a[12];
    assign reversed_in[20] = i_op_a[11];
    assign reversed_in[21] = i_op_a[10];
    assign reversed_in[22] = i_op_a[9];
    assign reversed_in[23] = i_op_a[8];
    assign reversed_in[24] = i_op_a[7];
    assign reversed_in[25] = i_op_a[6];
    assign reversed_in[26] = i_op_a[5];
    assign reversed_in[27] = i_op_a[4];
    assign reversed_in[28] = i_op_a[3];
    assign reversed_in[29] = i_op_a[2];
    assign reversed_in[30] = i_op_a[1];
    assign reversed_in[31] = i_op_a[0];
    wire [31:0] sll_stage1 = shift_amt[0] ? { 1'b0, reversed_in[31:1] } : reversed_in;
    wire [31:0] sll_stage2 = shift_amt[1] ? { {(2){1'b0}}, sll_stage1[31:2] } : sll_stage1;
    wire [31:0] sll_stage3 = shift_amt[2] ? { {(4){1'b0}}, sll_stage2[31:4] } : sll_stage2;
    wire [31:0] sll_stage4 = shift_amt[3] ? { {(8){1'b0}}, sll_stage3[31:8] } : sll_stage3;
    wire [31:0] sll_reversed = shift_amt[4] ? { {(16){1'b0}}, sll_stage4[31:16] } : sll_stage4;
    wire [31:0] sll_result;
    assign sll_result[0] = sll_reversed[31];
    assign sll_result[1] = sll_reversed[30];
    assign sll_result[2] = sll_reversed[29];
    assign sll_result[3] = sll_reversed[28];
    assign sll_result[4] = sll_reversed[27];
    assign sll_result[5] = sll_reversed[26];
    assign sll_result[6] = sll_reversed[25];
    assign sll_result[7] = sll_reversed[24];
    assign sll_result[8] = sll_reversed[23];
    assign sll_result[9] = sll_reversed[22];
    assign sll_result[10] = sll_reversed[21];
    assign sll_result[11] = sll_reversed[20];
    assign sll_result[12] = sll_reversed[19];
    assign sll_result[13] = sll_reversed[18];
    assign sll_result[14] = sll_reversed[17];
    assign sll_result[15] = sll_reversed[16];
    assign sll_result[16] = sll_reversed[15];
    assign sll_result[17] = sll_reversed[14];
    assign sll_result[18] = sll_reversed[13];
    assign sll_result[19] = sll_reversed[12];
    assign sll_result[20] = sll_reversed[11];
    assign sll_result[21] = sll_reversed[10];
    assign sll_result[22] = sll_reversed[9];
    assign sll_result[23] = sll_reversed[8];
    assign sll_result[24] = sll_reversed[7];
    assign sll_result[25] = sll_reversed[6];
    assign sll_result[26] = sll_reversed[5];
    assign sll_result[27] = sll_reversed[4];
    assign sll_result[28] = sll_reversed[3];
    assign sll_result[29] = sll_reversed[2];
    assign sll_result[30] = sll_reversed[1];
    assign sll_result[31] = sll_reversed[0];
    always @(*) begin
        case (i_alu_op)
            4'b0000, 4'b0001: shift_result = add_result; // ADD/SUB
            4'b0010: shift_result = {{31{1'b0}}, (i_op_a[31] != i_op_b[31]) ? i_op_a[31] : borrow}; // SLT
            4'b0011: shift_result = {{31{1'b0}}, borrow}; // SLTU
            4'b0100: shift_result = i_op_a ^ i_op_b; // XOR
            4'b0110: shift_result = i_op_a | i_op_b; // OR
            4'b0111: shift_result = i_op_a & i_op_b; // AND
            4'b1000: shift_result = sll_result; // SLL
            4'b1001, 4'b1010: shift_result = srl_sra_result; // SRL/SRA
            4'b1100: shift_result = i_op_b; // LUI: directly output i_op_b (which is imm << 12 in datapath)
            default: shift_result = 32'b0;
        endcase
    end
    assign o_alu_data = shift_result;
endmodule
    
  
    
    
       
// brc.sv
module brc (
    input wire [31:0] i_rs1_data,
    input wire [31:0] i_rs2_data,
    input wire i_br_un,
    output wire o_br_less,
    output wire o_br_equal
);

    // X? lý so sánh b?ng (Equal)
    assign o_br_equal = (i_rs1_data == i_rs2_data);

    // Th?c hi?n phép tr?: i_rs1_data - i_rs2_data = i_rs1_data + (~i_rs2_data) + 1
    wire [31:0] b_in = ~i_rs2_data; // S? bù 1 c?a i_rs2_data (B)
    wire cin = 1'b1; // Carry-in (C_in) kh?i t?o cho phép tr? (+1)
    
    
    wire [32:0] carry;
    wire [31:0] diff; // K?t qu? c?a phép tr? (Sum - không dùng cho logic so sánh)

    assign carry[0] = cin;
    // A=i_rs1_data, B=b_in, Cin=carry[i], Cout=carry[i+1]

    // Bit 0
    assign diff[0] = i_rs1_data[0] ^ b_in[0] ^ carry[0];
    assign carry[1] = (i_rs1_data[0] & b_in[0]) | (i_rs1_data[0] & carry[0]) | (b_in[0] & carry[0]);

    // Bit 1
    assign diff[1] = i_rs1_data[1] ^ b_in[1] ^ carry[1];
    assign carry[2] = (i_rs1_data[1] & b_in[1]) | (i_rs1_data[1] & carry[1]) | (b_in[1] & carry[1]);

    // Bit 2
    assign diff[2] = i_rs1_data[2] ^ b_in[2] ^ carry[2];
    assign carry[3] = (i_rs1_data[2] & b_in[2]) | (i_rs1_data[2] & carry[2]) | (b_in[2] & carry[2]);

    // Bit 3
    assign diff[3] = i_rs1_data[3] ^ b_in[3] ^ carry[3];
    assign carry[4] = (i_rs1_data[3] & b_in[3]) | (i_rs1_data[3] & carry[3]) | (b_in[3] & carry[3]);

    // Bit 4
    assign diff[4] = i_rs1_data[4] ^ b_in[4] ^ carry[4];
    assign carry[5] = (i_rs1_data[4] & b_in[4]) | (i_rs1_data[4] & carry[4]) | (b_in[4] & carry[4]);

    // Bit 5
    assign diff[5] = i_rs1_data[5] ^ b_in[5] ^ carry[5];
    assign carry[6] = (i_rs1_data[5] & b_in[5]) | (i_rs1_data[5] & carry[5]) | (b_in[5] & carry[5]);

    // Bit 6
    assign diff[6] = i_rs1_data[6] ^ b_in[6] ^ carry[6];
    assign carry[7] = (i_rs1_data[6] & b_in[6]) | (i_rs1_data[6] & carry[6]) | (b_in[6] & carry[6]);

    // Bit 7
    assign diff[7] = i_rs1_data[7] ^ b_in[7] ^ carry[7];
    assign carry[8] = (i_rs1_data[7] & b_in[7]) | (i_rs1_data[7] & carry[7]) | (b_in[7] & carry[7]);
    
    // Bit 8
    assign diff[8] = i_rs1_data[8] ^ b_in[8] ^ carry[8];
    assign carry[9] = (i_rs1_data[8] & b_in[8]) | (i_rs1_data[8] & carry[8]) | (b_in[8] & carry[8]);

    // Bit 9
    assign diff[9] = i_rs1_data[9] ^ b_in[9] ^ carry[9];
    assign carry[10] = (i_rs1_data[9] & b_in[9]) | (i_rs1_data[9] & carry[9]) | (b_in[9] & carry[9]);

    // Bit 10
    assign diff[10] = i_rs1_data[10] ^ b_in[10] ^ carry[10];
    assign carry[11] = (i_rs1_data[10] & b_in[10]) | (i_rs1_data[10] & carry[10]) | (b_in[10] & carry[10]);

    // Bit 11
    assign diff[11] = i_rs1_data[11] ^ b_in[11] ^ carry[11];
    assign carry[12] = (i_rs1_data[11] & b_in[11]) | (i_rs1_data[11] & carry[11]) | (b_in[11] & carry[11]);

    // Bit 12
    assign diff[12] = i_rs1_data[12] ^ b_in[12] ^ carry[12];
    assign carry[13] = (i_rs1_data[12] & b_in[12]) | (i_rs1_data[12] & carry[12]) | (b_in[12] & carry[12]);

    // Bit 13
    assign diff[13] = i_rs1_data[13] ^ b_in[13] ^ carry[13];
    assign carry[14] = (i_rs1_data[13] & b_in[13]) | (i_rs1_data[13] & carry[13]) | (b_in[13] & carry[13]);

    // Bit 14
    assign diff[14] = i_rs1_data[14] ^ b_in[14] ^ carry[14];
    assign carry[15] = (i_rs1_data[14] & b_in[14]) | (i_rs1_data[14] & carry[14]) | (b_in[14] & carry[14]);

    // Bit 15
    assign diff[15] = i_rs1_data[15] ^ b_in[15] ^ carry[15];
    assign carry[16] = (i_rs1_data[15] & b_in[15]) | (i_rs1_data[15] & carry[15]) | (b_in[15] & carry[15]);

    // Bit 16
    assign diff[16] = i_rs1_data[16] ^ b_in[16] ^ carry[16];
    assign carry[17] = (i_rs1_data[16] & b_in[16]) | (i_rs1_data[16] & carry[16]) | (b_in[16] & carry[16]);

    // Bit 17
    assign diff[17] = i_rs1_data[17] ^ b_in[17] ^ carry[17];
    assign carry[18] = (i_rs1_data[17] & b_in[17]) | (i_rs1_data[17] & carry[17]) | (b_in[17] & carry[17]);

    // Bit 18
    assign diff[18] = i_rs1_data[18] ^ b_in[18] ^ carry[18];
    assign carry[19] = (i_rs1_data[18] & b_in[18]) | (i_rs1_data[18] & carry[18]) | (b_in[18] & carry[18]);

    // Bit 19
    assign diff[19] = i_rs1_data[19] ^ b_in[19] ^ carry[19];
    assign carry[20] = (i_rs1_data[19] & b_in[19]) | (i_rs1_data[19] & carry[19]) | (b_in[19] & carry[19]);

    // Bit 20
    assign diff[20] = i_rs1_data[20] ^ b_in[20] ^ carry[20];
    assign carry[21] = (i_rs1_data[20] & b_in[20]) | (i_rs1_data[20] & carry[20]) | (b_in[20] & carry[20]);

    // Bit 21
    assign diff[21] = i_rs1_data[21] ^ b_in[21] ^ carry[21];
    assign carry[22] = (i_rs1_data[21] & b_in[21]) | (i_rs1_data[21] & carry[21]) | (b_in[21] & carry[21]);

    // Bit 22
    assign diff[22] = i_rs1_data[22] ^ b_in[22] ^ carry[22];
    assign carry[23] = (i_rs1_data[22] & b_in[22]) | (i_rs1_data[22] & carry[22]) | (b_in[22] & carry[22]);

    // Bit 23
    assign diff[23] = i_rs1_data[23] ^ b_in[23] ^ carry[23];
    assign carry[24] = (i_rs1_data[23] & b_in[23]) | (i_rs1_data[23] & carry[23]) | (b_in[23] & carry[23]);

    // Bit 24
    assign diff[24] = i_rs1_data[24] ^ b_in[24] ^ carry[24];
    assign carry[25] = (i_rs1_data[24] & b_in[24]) | (i_rs1_data[24] & carry[24]) | (b_in[24] & carry[24]);

    // Bit 25
    assign diff[25] = i_rs1_data[25] ^ b_in[25] ^ carry[25];
    assign carry[26] = (i_rs1_data[25] & b_in[25]) | (i_rs1_data[25] & carry[25]) | (b_in[25] & carry[25]);

    // Bit 26
    assign diff[26] = i_rs1_data[26] ^ b_in[26] ^ carry[26];
    assign carry[27] = (i_rs1_data[26] & b_in[26]) | (i_rs1_data[26] & carry[26]) | (b_in[26] & carry[26]);

    // Bit 27
    assign diff[27] = i_rs1_data[27] ^ b_in[27] ^ carry[27];
    assign carry[28] = (i_rs1_data[27] & b_in[27]) | (i_rs1_data[27] & carry[27]) | (b_in[27] & carry[27]);

    // Bit 28
    assign diff[28] = i_rs1_data[28] ^ b_in[28] ^ carry[28];
    assign carry[29] = (i_rs1_data[28] & b_in[28]) | (i_rs1_data[28] & carry[28]) | (b_in[28] & carry[28]);

    // Bit 29
    assign diff[29] = i_rs1_data[29] ^ b_in[29] ^ carry[29];
    assign carry[30] = (i_rs1_data[29] & b_in[29]) | (i_rs1_data[29] & carry[29]) | (b_in[29] & carry[29]);

    // Bit 30
    assign diff[30] = i_rs1_data[30] ^ b_in[30] ^ carry[30];
    assign carry[31] = (i_rs1_data[30] & b_in[30]) | (i_rs1_data[30] & carry[30]) | (b_in[30] & carry[30]);

    // Bit 31 (Bit cu?i cùng)
    assign diff[31] = i_rs1_data[31] ^ b_in[31] ^ carry[31];
    assign carry[32] = (i_rs1_data[31] & b_in[31]) | (i_rs1_data[31] & carry[31]) | (b_in[31] & carry[31]);

    // --- K?t thúc 32 l?n ??nh ngh?a m?ch c?ng toàn ph?n th? công ---

    // Bit borrow (n?u carry[32] = 0 thì borrow = 1)
    wire borrow = ~carry[32]; 

    // X? lý so sánh nh? h?n (Less Than)
    assign o_br_less = i_br_un ? borrow : 
                       (i_rs1_data[31] != i_rs2_data[31]) ? i_rs1_data[31] : 
                       borrow; 

endmodule
// regfile.sv
module regfile (
input wire i_clk,
input wire i_reset,
input wire [4:0] i_rs1_addr,
input wire [4:0] i_rs2_addr,
output wire [31:0] o_rs1_data,
output wire [31:0] o_rs2_data,
input wire [4:0] i_rd_addr,
input wire [31:0] i_rd_data,
input wire i_rd_wren
);
reg [31:0] registers [0:31];
initial begin
registers[0] = 32'b0;
registers[1] = 32'b0;
registers[2] = 32'b0;
registers[3] = 32'b0;
registers[4] = 32'b0;
registers[5] = 32'b0;
registers[6] = 32'b0;
registers[7] = 32'b0;
registers[8] = 32'b0;
registers[9] = 32'b0;
registers[10] = 32'b0;
registers[11] = 32'b0;
registers[12] = 32'b0;
registers[13] = 32'b0;
registers[14] = 32'b0;
registers[15] = 32'b0;
registers[16] = 32'b0;
registers[17] = 32'b0;
registers[18] = 32'b0;
registers[19] = 32'b0;
registers[20] = 32'b0;
registers[21] = 32'b0;
registers[22] = 32'b0;
registers[23] = 32'b0;
registers[24] = 32'b0;
registers[25] = 32'b0;
registers[26] = 32'b0;
registers[27] = 32'b0;
registers[28] = 32'b0;
registers[29] = 32'b0;
registers[30] = 32'b0;
registers[31] = 32'b0;
end
always @(posedge i_clk) begin
if (i_reset) begin
registers[0] <= 32'b0;
registers[1] <= 32'b0;
registers[2] <= 32'b0;
registers[3] <= 32'b0;
registers[4] <= 32'b0;
registers[5] <= 32'b0;
registers[6] <= 32'b0;
registers[7] <= 32'b0;
registers[8] <= 32'b0;
registers[9] <= 32'b0;
registers[10] <= 32'b0;
registers[11] <= 32'b0;
registers[12] <= 32'b0;
registers[13] <= 32'b0;
registers[14] <= 32'b0;
registers[15] <= 32'b0;
registers[16] <= 32'b0;
registers[17] <= 32'b0;
registers[18] <= 32'b0;
registers[19] <= 32'b0;
registers[20] <= 32'b0;
registers[21] <= 32'b0;
registers[22] <= 32'b0;
registers[23] <= 32'b0;
registers[24] <= 32'b0;
registers[25] <= 32'b0;
registers[26] <= 32'b0;
registers[27] <= 32'b0;
registers[28] <= 32'b0;
registers[29] <= 32'b0;
registers[30] <= 32'b0;
registers[31] <= 32'b0;
end else if (i_rd_wren && i_rd_addr != 0) begin
registers[i_rd_addr] <= i_rd_data;
end
end
assign o_rs1_data = (i_rs1_addr == 0) ? 32'b0 : registers[i_rs1_addr];
assign o_rs2_data = (i_rs2_addr == 0) ? 32'b0 : registers[i_rs2_addr];
endmodule

// instr_mem.sv
module instr_mem (
    input wire [10:0] i_addr, // 2 KiB, 512 words
    output wire [31:0] o_rdata
);
    reg [31:0] mem [0:2047];
    initial $readmemh("../02_test/dump/mem.dump", mem); // Load from spec file
    assign o_rdata = mem[i_addr];
endmodule
// imm_gen.sv
module imm_gen (
    input wire [31:0] i_instr,
    output wire [31:0] o_imm
);
    wire [6:0] opcode = i_instr[6:0];
    reg [31:0] imm;
    always @(*) begin
        case (opcode)
            7'b0000011, 7'b0010011, 7'b1100111: imm = {{20{i_instr[31]}}, i_instr[31:20]}; // I-type
            7'b0100011: imm = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]}; // S-type
            7'b1100011: imm = {{19{i_instr[31]}}, i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}; // B-type
            7'b0010111, 7'b0110111: imm = {i_instr[31:12], 12'b0}; // U-type
            7'b1101111: imm = {{11{i_instr[31]}}, i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0}; // J-type
            default: imm = 32'b0;
        endcase
    end
    assign o_imm = imm;
endmodule
// lsu.sv
 module lsu (
    input wire i_clk,
    input wire i_reset,
    input wire [31:0] i_lsu_addr,
    input wire [31:0] i_st_data,
    input wire i_lsu_wren,
    input wire [2:0] i_f3,
    output wire [31:0] o_ld_data,
    output reg [31:0] o_io_ledr,
    output reg [31:0] o_io_ledg,
    output reg [6:0] o_io_hex0,
    output reg [6:0] o_io_hex1,
    output reg [6:0] o_io_hex2,
    output reg [6:0] o_io_hex3,
    output reg [6:0] o_io_hex4,
    output reg [6:0] o_io_hex5,
    output reg [6:0] o_io_hex6,
    output reg [6:0] o_io_hex7,
    output reg [31:0] o_io_lcd,
    input wire [31:0] i_io_sw
);

reg [31:0] dmem [0:511]; // 2 KiB


// Tính toán ??a ch? cho unaligned access
wire [31:0] addr_trunc = i_lsu_addr & 32'hFFFFFFFC; // Word hi?n t?i (c?n l?)
wire [31:0] addr_next = addr_trunc + 4;             // Word ti?p theo
wire [1:0] byte_off = i_lsu_addr[1:0];
wire eff_half_off = i_lsu_addr[1];

wire is_mem = ~|i_lsu_addr[31:11];
wire [8:0] mem_idx = is_mem ? addr_trunc[10:2] : 9'b0;     // Index word hi?n t?i
wire [8:0] mem_idx_next = is_mem ? addr_next[10:2] : 9'b0; // Index word ti?p theo

// Byte mask logic
reg [3:0] bmask;
reg [3:0] bmask_next; // For cross-boundary writes
always @(*) begin
    bmask = 4'b0000;
    bmask_next = 4'b0000;
    case (i_f3)
        3'b000, 3'b100: begin // Byte
            case (byte_off)
                2'b00: bmask = 4'b0001;
                2'b01: bmask = 4'b0010;
                2'b10: bmask = 4'b0100;
                2'b11: bmask = 4'b1000;
            endcase
        end
        3'b001,3'b101: begin // Half
            case (byte_off)
                2'b00: bmask = 4'b0011;
                2'b01: bmask = 4'b0110;
                2'b10: bmask = 4'b1100;
                2'b11: begin
                    bmask = 4'b1000; // Current word: byte 3
                    bmask_next = 4'b0001;
                end
            endcase
        end
        3'b010: bmask = 4'b1111;
        default: bmask = 4'b0000;
    endcase
end

reg [31:0] st_data_aligned;  // 
reg [31:0] st_data_aligned_next; // For cross-boundary

always @(*) begin
    st_data_aligned = 32'b0;
    st_data_aligned_next = 32'b0;
    case (i_f3)
        3'b000, 3'b100: begin  // Byte
            case (byte_off)
                2'b00: st_data_aligned = {24'b0, i_st_data[7:0]};
                2'b01: st_data_aligned = {16'b0, i_st_data[7:0], 8'b0};
                2'b10: st_data_aligned = {8'b0, i_st_data[7:0], 16'b0};
                2'b11: st_data_aligned = {i_st_data[7:0], 24'b0};
            endcase
        end
        3'b001, 3'b101: begin  // Half
            case (byte_off)
                2'b00: st_data_aligned = {16'b0, i_st_data[15:0]};
                2'b01: st_data_aligned = {8'b0, i_st_data[15:0], 8'b0};
                2'b10: st_data_aligned = {i_st_data[15:0], 16'b0};
                2'b11: begin
                    st_data_aligned = {i_st_data[7:0], 24'b0}; // Low byte in current [31:24]
                    st_data_aligned_next = {24'b0, i_st_data[15:8]}; // High byte in next [7:0]
                end
            endcase
        end
        3'b010: st_data_aligned = i_st_data;  // Word
        default: st_data_aligned = 32'b0;
    endcase
end

// Reset and write logic
always @(posedge i_clk) begin
    if (i_reset) begin
        dmem[0] <= 32'b0;
        dmem[1] <= 32'b0;
        dmem[2] <= 32'b0;
        dmem[3] <= 32'b0;
        dmem[4] <= 32'b0;
        dmem[5] <= 32'b0;
        dmem[6] <= 32'b0;
        dmem[7] <= 32'b0;
        dmem[8] <= 32'b0;
        dmem[9] <= 32'b0;
        dmem[10] <= 32'b0;
        dmem[11] <= 32'b0;
        dmem[12] <= 32'b0;
        dmem[13] <= 32'b0;
        dmem[14] <= 32'b0;
        dmem[15] <= 32'b0;
        dmem[16] <= 32'b0;
        dmem[17] <= 32'b0;
        dmem[18] <= 32'b0;
        dmem[19] <= 32'b0;
        dmem[20] <= 32'b0;
        dmem[21] <= 32'b0;
        dmem[22] <= 32'b0;
        dmem[23] <= 32'b0;
        dmem[24] <= 32'b0;
        dmem[25] <= 32'b0;
        dmem[26] <= 32'b0;
        dmem[27] <= 32'b0;
        dmem[28] <= 32'b0;
        dmem[29] <= 32'b0;
        dmem[30] <= 32'b0;
        dmem[31] <= 32'b0;
        dmem[32] <= 32'b0;
        dmem[33] <= 32'b0;
        dmem[34] <= 32'b0;
        dmem[35] <= 32'b0;
        dmem[36] <= 32'b0;
        dmem[37] <= 32'b0;
        dmem[38] <= 32'b0;
        dmem[39] <= 32'b0;
        dmem[40] <= 32'b0;
        dmem[41] <= 32'b0;
        dmem[42] <= 32'b0;
        dmem[43] <= 32'b0;
        dmem[44] <= 32'b0;
        dmem[45] <= 32'b0;
        dmem[46] <= 32'b0;
        dmem[47] <= 32'b0;
        dmem[48] <= 32'b0;
        dmem[49] <= 32'b0;
        dmem[50] <= 32'b0;
        dmem[51] <= 32'b0;
        dmem[52] <= 32'b0;
        dmem[53] <= 32'b0;
        dmem[54] <= 32'b0;
        dmem[55] <= 32'b0;
        dmem[56] <= 32'b0;
        dmem[57] <= 32'b0;
        dmem[58] <= 32'b0;
        dmem[59] <= 32'b0;
        dmem[60] <= 32'b0;
        dmem[61] <= 32'b0;
        dmem[62] <= 32'b0;
        dmem[63] <= 32'b0;
        dmem[64] <= 32'b0;
        dmem[65] <= 32'b0;
        dmem[66] <= 32'b0;
        dmem[67] <= 32'b0;
        dmem[68] <= 32'b0;
        dmem[69] <= 32'b0;
        dmem[70] <= 32'b0;
        dmem[71] <= 32'b0;
        dmem[72] <= 32'b0;
        dmem[73] <= 32'b0;
        dmem[74] <= 32'b0;
        dmem[75] <= 32'b0;
        dmem[76] <= 32'b0;
        dmem[77] <= 32'b0;
        dmem[78] <= 32'b0;
        dmem[79] <= 32'b0;
        dmem[80] <= 32'b0;
        dmem[81] <= 32'b0;
        dmem[82] <= 32'b0;
        dmem[83] <= 32'b0;
        dmem[84] <= 32'b0;
        dmem[85] <= 32'b0;
        dmem[86] <= 32'b0;
        dmem[87] <= 32'b0;
        dmem[88] <= 32'b0;
        dmem[89] <= 32'b0;
        dmem[90] <= 32'b0;
        dmem[91] <= 32'b0;
        dmem[92] <= 32'b0;
        dmem[93] <= 32'b0;
        dmem[94] <= 32'b0;
        dmem[95] <= 32'b0;
        dmem[96] <= 32'b0;
        dmem[97] <= 32'b0;
        dmem[98] <= 32'b0;
        dmem[99] <= 32'b0;
        dmem[100] <= 32'b0;
        dmem[101] <= 32'b0;
        dmem[102] <= 32'b0;
        dmem[103] <= 32'b0;
        dmem[104] <= 32'b0;
        dmem[105] <= 32'b0;
        dmem[106] <= 32'b0;
        dmem[107] <= 32'b0;
        dmem[108] <= 32'b0;
        dmem[109] <= 32'b0;
        dmem[110] <= 32'b0;
        dmem[111] <= 32'b0;
        dmem[112] <= 32'b0;
        dmem[113] <= 32'b0;
        dmem[114] <= 32'b0;
        dmem[115] <= 32'b0;
        dmem[116] <= 32'b0;
        dmem[117] <= 32'b0;
        dmem[118] <= 32'b0;
        dmem[119] <= 32'b0;
        dmem[120] <= 32'b0;
        dmem[121] <= 32'b0;
        dmem[122] <= 32'b0;
        dmem[123] <= 32'b0;
        dmem[124] <= 32'b0;
        dmem[125] <= 32'b0;
        dmem[126] <= 32'b0;
        dmem[127] <= 32'b0;
        dmem[128] <= 32'b0;
        dmem[129] <= 32'b0;
        dmem[130] <= 32'b0;
        dmem[131] <= 32'b0;
        dmem[132] <= 32'b0;
        dmem[133] <= 32'b0;
        dmem[134] <= 32'b0;
        dmem[135] <= 32'b0;
        dmem[136] <= 32'b0;
        dmem[137] <= 32'b0;
        dmem[138] <= 32'b0;
        dmem[139] <= 32'b0;
        dmem[140] <= 32'b0;
        dmem[141] <= 32'b0;
        dmem[142] <= 32'b0;
        dmem[143] <= 32'b0;
        dmem[144] <= 32'b0;
        dmem[145] <= 32'b0;
        dmem[146] <= 32'b0;
        dmem[147] <= 32'b0;
        dmem[148] <= 32'b0;
        dmem[149] <= 32'b0;
        dmem[150] <= 32'b0;
        dmem[151] <= 32'b0;
        dmem[152] <= 32'b0;
        dmem[153] <= 32'b0;
        dmem[154] <= 32'b0;
        dmem[155] <= 32'b0;
        dmem[156] <= 32'b0;
        dmem[157] <= 32'b0;
        dmem[158] <= 32'b0;
        dmem[159] <= 32'b0;
        dmem[160] <= 32'b0;
        dmem[161] <= 32'b0;
        dmem[162] <= 32'b0;
        dmem[163] <= 32'b0;
        dmem[164] <= 32'b0;
        dmem[165] <= 32'b0;
        dmem[166] <= 32'b0;
        dmem[167] <= 32'b0;
        dmem[168] <= 32'b0;
        dmem[169] <= 32'b0;
        dmem[170] <= 32'b0;
        dmem[171] <= 32'b0;
        dmem[172] <= 32'b0;
        dmem[173] <= 32'b0;
        dmem[174] <= 32'b0;
        dmem[175] <= 32'b0;
        dmem[176] <= 32'b0;
        dmem[177] <= 32'b0;
        dmem[178] <= 32'b0;
        dmem[179] <= 32'b0;
        dmem[180] <= 32'b0;
        dmem[181] <= 32'b0;
        dmem[182] <= 32'b0;
        dmem[183] <= 32'b0;
        dmem[184] <= 32'b0;
        dmem[185] <= 32'b0;
        dmem[186] <= 32'b0;
        dmem[187] <= 32'b0;
        dmem[188] <= 32'b0;
        dmem[189] <= 32'b0;
        dmem[190] <= 32'b0;
        dmem[191] <= 32'b0;
        dmem[192] <= 32'b0;
        dmem[193] <= 32'b0;
        dmem[194] <= 32'b0;
        dmem[195] <= 32'b0;
        dmem[196] <= 32'b0;
        dmem[197] <= 32'b0;
        dmem[198] <= 32'b0;
        dmem[199] <= 32'b0;
        dmem[200] <= 32'b0;
        dmem[201] <= 32'b0;
        dmem[202] <= 32'b0;
        dmem[203] <= 32'b0;
        dmem[204] <= 32'b0;
        dmem[205] <= 32'b0;
        dmem[206] <= 32'b0;
        dmem[207] <= 32'b0;
        dmem[208] <= 32'b0;
        dmem[209] <= 32'b0;
        dmem[210] <= 32'b0;
        dmem[211] <= 32'b0;
        dmem[212] <= 32'b0;
        dmem[213] <= 32'b0;
        dmem[214] <= 32'b0;
        dmem[215] <= 32'b0;
        dmem[216] <= 32'b0;
        dmem[217] <= 32'b0;
        dmem[218] <= 32'b0;
        dmem[219] <= 32'b0;
        dmem[220] <= 32'b0;
        dmem[221] <= 32'b0;
        dmem[222] <= 32'b0;
        dmem[223] <= 32'b0;
        dmem[224] <= 32'b0;
        dmem[225] <= 32'b0;
        dmem[226] <= 32'b0;
        dmem[227] <= 32'b0;
        dmem[228] <= 32'b0;
        dmem[229] <= 32'b0;
        dmem[230] <= 32'b0;
        dmem[231] <= 32'b0;
        dmem[232] <= 32'b0;
        dmem[233] <= 32'b0;
        dmem[234] <= 32'b0;
        dmem[235] <= 32'b0;
        dmem[236] <= 32'b0;
        dmem[237] <= 32'b0;
        dmem[238] <= 32'b0;
        dmem[239] <= 32'b0;
        dmem[240] <= 32'b0;
        dmem[241] <= 32'b0;
        dmem[242] <= 32'b0;
        dmem[243] <= 32'b0;
        dmem[244] <= 32'b0;
        dmem[245] <= 32'b0;
        dmem[246] <= 32'b0;
        dmem[247] <= 32'b0;
        dmem[248] <= 32'b0;
        dmem[249] <= 32'b0;
        dmem[250] <= 32'b0;
        dmem[251] <= 32'b0;
        dmem[252] <= 32'b0;
        dmem[253] <= 32'b0;
        dmem[254] <= 32'b0;
        dmem[255] <= 32'b0;
        dmem[256] <= 32'b0;
        dmem[257] <= 32'b0;
        dmem[258] <= 32'b0;
        dmem[259] <= 32'b0;
        dmem[260] <= 32'b0;
        dmem[261] <= 32'b0;
        dmem[262] <= 32'b0;
        dmem[263] <= 32'b0;
        dmem[264] <= 32'b0;
        dmem[265] <= 32'b0;
        dmem[266] <= 32'b0;
        dmem[267] <= 32'b0;
        dmem[268] <= 32'b0;
        dmem[269] <= 32'b0;
        dmem[270] <= 32'b0;
        dmem[271] <= 32'b0;
        dmem[272] <= 32'b0;
        dmem[273] <= 32'b0;
        dmem[274] <= 32'b0;
        dmem[275] <= 32'b0;
        dmem[276] <= 32'b0;
        dmem[277] <= 32'b0;
        dmem[278] <= 32'b0;
        dmem[279] <= 32'b0;
        dmem[280] <= 32'b0;
        dmem[281] <= 32'b0;
        dmem[282] <= 32'b0;
        dmem[283] <= 32'b0;
        dmem[284] <= 32'b0;
        dmem[285] <= 32'b0;
        dmem[286] <= 32'b0;
        dmem[287] <= 32'b0;
        dmem[288] <= 32'b0;
        dmem[289] <= 32'b0;
        dmem[290] <= 32'b0;
        dmem[291] <= 32'b0;
        dmem[292] <= 32'b0;
        dmem[293] <= 32'b0;
        dmem[294] <= 32'b0;
        dmem[295] <= 32'b0;
        dmem[296] <= 32'b0;
        dmem[297] <= 32'b0;
        dmem[298] <= 32'b0;
        dmem[299] <= 32'b0;
        dmem[300] <= 32'b0;
        dmem[301] <= 32'b0;
        dmem[302] <= 32'b0;
        dmem[303] <= 32'b0;
        dmem[304] <= 32'b0;
        dmem[305] <= 32'b0;
        dmem[306] <= 32'b0;
        dmem[307] <= 32'b0;
        dmem[308] <= 32'b0;
        dmem[309] <= 32'b0;
        dmem[310] <= 32'b0;
        dmem[311] <= 32'b0;
        dmem[312] <= 32'b0;
        dmem[313] <= 32'b0;
        dmem[314] <= 32'b0;
        dmem[315] <= 32'b0;
        dmem[316] <= 32'b0;
        dmem[317] <= 32'b0;
        dmem[318] <= 32'b0;
        dmem[319] <= 32'b0;
        dmem[320] <= 32'b0;
        dmem[321] <= 32'b0;
        dmem[322] <= 32'b0;
        dmem[323] <= 32'b0;
        dmem[324] <= 32'b0;
        dmem[325] <= 32'b0;
        dmem[326] <= 32'b0;
        dmem[327] <= 32'b0;
        dmem[328] <= 32'b0;
        dmem[329] <= 32'b0;
        dmem[330] <= 32'b0;
        dmem[331] <= 32'b0;
        dmem[332] <= 32'b0;
        dmem[333] <= 32'b0;
        dmem[334] <= 32'b0;
        dmem[335] <= 32'b0;
        dmem[336] <= 32'b0;
        dmem[337] <= 32'b0;
        dmem[338] <= 32'b0;
        dmem[339] <= 32'b0;
        dmem[340] <= 32'b0;
        dmem[341] <= 32'b0;
        dmem[342] <= 32'b0;
        dmem[343] <= 32'b0;
        dmem[344] <= 32'b0;
        dmem[345] <= 32'b0;
        dmem[346] <= 32'b0;
        dmem[347] <= 32'b0;
        dmem[348] <= 32'b0;
        dmem[349] <= 32'b0;
        dmem[350] <= 32'b0;
        dmem[351] <= 32'b0;
        dmem[352] <= 32'b0;
        dmem[353] <= 32'b0;
        dmem[354] <= 32'b0;
        dmem[355] <= 32'b0;
        dmem[356] <= 32'b0;
        dmem[357] <= 32'b0;
        dmem[358] <= 32'b0;
        dmem[359] <= 32'b0;
        dmem[360] <= 32'b0;
        dmem[361] <= 32'b0;
        dmem[362] <= 32'b0;
        dmem[363] <= 32'b0;
        dmem[364] <= 32'b0;
        dmem[365] <= 32'b0;
        dmem[366] <= 32'b0;
        dmem[367] <= 32'b0;
        dmem[368] <= 32'b0;
        dmem[369] <= 32'b0;
        dmem[370] <= 32'b0;
        dmem[371] <= 32'b0;
        dmem[372] <= 32'b0;
        dmem[373] <= 32'b0;
        dmem[374] <= 32'b0;
        dmem[375] <= 32'b0;
        dmem[376] <= 32'b0;
        dmem[377] <= 32'b0;
        dmem[378] <= 32'b0;
        dmem[379] <= 32'b0;
        dmem[380] <= 32'b0;
        dmem[381] <= 32'b0;
        dmem[382] <= 32'b0;
        dmem[383] <= 32'b0;
        dmem[384] <= 32'b0;
        dmem[385] <= 32'b0;
        dmem[386] <= 32'b0;
        dmem[387] <= 32'b0;
        dmem[388] <= 32'b0;
        dmem[389] <= 32'b0;
        dmem[390] <= 32'b0;
        dmem[391] <= 32'b0;
        dmem[392] <= 32'b0;
        dmem[393] <= 32'b0;
        dmem[394] <= 32'b0;
        dmem[395] <= 32'b0;
        dmem[396] <= 32'b0;
        dmem[397] <= 32'b0;
        dmem[398] <= 32'b0;
        dmem[399] <= 32'b0;
        dmem[400] <= 32'b0;
        dmem[401] <= 32'b0;
        dmem[402] <= 32'b0;
        dmem[403] <= 32'b0;
        dmem[404] <= 32'b0;
        dmem[405] <= 32'b0;
        dmem[406] <= 32'b0;
        dmem[407] <= 32'b0;
        dmem[408] <= 32'b0;
        dmem[409] <= 32'b0;
        dmem[410] <= 32'b0;
        dmem[411] <= 32'b0;
        dmem[412] <= 32'b0;
        dmem[413] <= 32'b0;
        dmem[414] <= 32'b0;
        dmem[415] <= 32'b0;
        dmem[416] <= 32'b0;
        dmem[417] <= 32'b0;
        dmem[418] <= 32'b0;
        dmem[419] <= 32'b0;
        dmem[420] <= 32'b0;
        dmem[421] <= 32'b0;
        dmem[422] <= 32'b0;
        dmem[423] <= 32'b0;
        dmem[424] <= 32'b0;
        dmem[425] <= 32'b0;
        dmem[426] <= 32'b0;
        dmem[427] <= 32'b0;
        dmem[428] <= 32'b0;
        dmem[429] <= 32'b0;
        dmem[430] <= 32'b0;
        dmem[431] <= 32'b0;
        dmem[432] <= 32'b0;
        dmem[433] <= 32'b0;
        dmem[434] <= 32'b0;
        dmem[435] <= 32'b0;
        dmem[436] <= 32'b0;
        dmem[437] <= 32'b0;
        dmem[438] <= 32'b0;
        dmem[439] <= 32'b0;
        dmem[440] <= 32'b0;
        dmem[441] <= 32'b0;
        dmem[442] <= 32'b0;
        dmem[443] <= 32'b0;
        dmem[444] <= 32'b0;
        dmem[445] <= 32'b0;
        dmem[446] <= 32'b0;
        dmem[447] <= 32'b0;
        dmem[448] <= 32'b0;
        dmem[449] <= 32'b0;
        dmem[450] <= 32'b0;
        dmem[451] <= 32'b0;
        dmem[452] <= 32'b0;
        dmem[453] <= 32'b0;
        dmem[454] <= 32'b0;
        dmem[455] <= 32'b0;
        dmem[456] <= 32'b0;
        dmem[457] <= 32'b0;
        dmem[458] <= 32'b0;
        dmem[459] <= 32'b0;
        dmem[460] <= 32'b0;
        dmem[461] <= 32'b0;
        dmem[462] <= 32'b0;
        dmem[463] <= 32'b0;
        dmem[464] <= 32'b0;
        dmem[465] <= 32'b0;
        dmem[466] <= 32'b0;
        dmem[467] <= 32'b0;
        dmem[468] <= 32'b0;
        dmem[469] <= 32'b0;
        dmem[470] <= 32'b0;
        dmem[471] <= 32'b0;
        dmem[472] <= 32'b0;
        dmem[473] <= 32'b0;
        dmem[474] <= 32'b0;
        dmem[475] <= 32'b0;
        dmem[476] <= 32'b0;
        dmem[477] <= 32'b0;
        dmem[478] <= 32'b0;
        dmem[479] <= 32'b0;
        dmem[480] <= 32'b0;
        dmem[481] <= 32'b0;
        dmem[482] <= 32'b0;
        dmem[483] <= 32'b0;
        dmem[484] <= 32'b0;
        dmem[485] <= 32'b0;
        dmem[486] <= 32'b0;
        dmem[487] <= 32'b0;
        dmem[488] <= 32'b0;
        dmem[489] <= 32'b0;
        dmem[490] <= 32'b0;
        dmem[491] <= 32'b0;
        dmem[492] <= 32'b0;
        dmem[493] <= 32'b0;
        dmem[494] <= 32'b0;
        dmem[495] <= 32'b0;
        dmem[496] <= 32'b0;
        dmem[497] <= 32'b0;
        dmem[498] <= 32'b0;
        dmem[499] <= 32'b0;
        dmem[500] <= 32'b0;
        dmem[501] <= 32'b0;
        dmem[502] <= 32'b0;
        dmem[503] <= 32'b0;
        dmem[504] <= 32'b0;
        dmem[505] <= 32'b0;
        dmem[506] <= 32'b0;
        dmem[507] <= 32'b0;
        dmem[508] <= 32'b0;
        dmem[509] <= 32'b0;
        dmem[510] <= 32'b0;
        dmem[511] <= 32'b0;
        o_io_ledr <= 32'b0;
        o_io_ledg <= 32'b0;
        o_io_hex0 <= 7'b1111111;
        o_io_hex1 <= 7'b1111111;
        o_io_hex2 <= 7'b1111111;
        o_io_hex3 <= 7'b1111111;
        o_io_hex4 <= 7'b1111111;
        o_io_hex5 <= 7'b1111111;
        o_io_hex6 <= 7'b1111111;
        o_io_hex7 <= 7'b1111111;
        o_io_lcd <= 32'b0;
    end else if (i_lsu_wren) begin
        if (is_mem) begin
    // st_data_aligned thay i_st_data
    if (bmask[0]) dmem[mem_idx][7:0] <= st_data_aligned[7:0];
    if (bmask[1]) dmem[mem_idx][15:8] <= st_data_aligned[15:8];
    if (bmask[2]) dmem[mem_idx][23:16] <= st_data_aligned[23:16];
    if (bmask[3]) dmem[mem_idx][31:24] <= st_data_aligned[31:24];
    
// xu li vuot ranh gioi Word (Cross-boundary)
        if (bmask_next != 4'b0000) begin
        if (bmask_next[0]) dmem[mem_idx_next][7:0]   <= st_data_aligned_next[7:0];
        if (bmask_next[1]) dmem[mem_idx_next][15:8]  <= st_data_aligned_next[15:8];
        if (bmask_next[2]) dmem[mem_idx_next][23:16] <= st_data_aligned_next[23:16];
        if (bmask_next[3]) dmem[mem_idx_next][31:24] <= st_data_aligned_next[31:24];
    end
        end else begin
            case (i_lsu_addr[31:12])
                20'h10000: o_io_ledr <= i_st_data; // 0x10000000 Red LEDs
                20'h10001: o_io_ledg <= i_st_data; // 0x10001000 Green LEDs
           20'h10002: begin // 0x10002000 HEX3-0
                    //  SW (Word Write)
                    if (i_f3 == 3'b010) begin
                        o_io_hex0 <= i_st_data[6:0];
                        o_io_hex1 <= i_st_data[14:8];
                        o_io_hex2 <= i_st_data[22:16];
                        o_io_hex3 <= i_st_data[30:24];
                    //  SH (Halfword Write)
                    end else if (i_f3 == 3'b001 || i_f3 == 3'b101) begin
                        case (byte_off)
                            2'b00: begin // Ghi  HEX0 va HEX1 (Byte 0, 1)
                                o_io_hex0 <= i_st_data[6:0];
                                o_io_hex1 <= i_st_data[14:8];
                            end
                            2'b10: begin // Ghi vao HEX2 va HEX3 (Byte 2, 3)
                                o_io_hex2 <= i_st_data[6:0];
                                o_io_hex3 <= i_st_data[14:8];
                            end
                        endcase
                    //  SB (Byte Write)
                    end else if (i_f3 == 3'b000 || i_f3 == 3'b100) begin
                        case (byte_off)
                            2'b00: o_io_hex0 <= i_st_data[6:0]; //  HEX0 (Byte 0)
                            2'b01: o_io_hex1 <= i_st_data[6:0]; //  HEX1 (Byte 1)
                            2'b10: o_io_hex2 <= i_st_data[6:0]; //  HEX2 (Byte 2)
                            2'b11: o_io_hex3 <= i_st_data[6:0]; //  HEX3 (Byte 3)
                        endcase
                    end
                end
                
                20'h10003: begin // 0x10003000 HEX7-4
                    // Lenh SW (Word Write)
                    if (i_f3 == 3'b010) begin
                        o_io_hex4 <= i_st_data[6:0];
                        o_io_hex5 <= i_st_data[14:8];
                        o_io_hex6 <= i_st_data[22:16];
                        o_io_hex7 <= i_st_data[30:24];
                    //  SH (Halfword Write)
                    end else if (i_f3 == 3'b001 || i_f3 == 3'b101) begin
                        case (byte_off)
                            2'b00: begin // ghi HEX4 va HEX5 (Byte 0, 1)
                                o_io_hex4 <= i_st_data[6:0];
                                o_io_hex5 <= i_st_data[14:8];
                            end
                            2'b10: begin // Ghi  HEX6 va HEX7 (Byte 2, 3)
                                o_io_hex6 <= i_st_data[6:0];
                                o_io_hex7 <= i_st_data[14:8];
                            end
                        endcase
                    // lenh SB (Byte Write)
                    end else if (i_f3 == 3'b000 || i_f3 == 3'b100) begin
                        case (byte_off)
                            2'b00: o_io_hex4 <= i_st_data[6:0]; // HEX4 (Byte 0)
                            2'b01: o_io_hex5 <= i_st_data[6:0]; //  HEX5 (Byte 1)
                            2'b10: o_io_hex6 <= i_st_data[6:0]; //  HEX6 (Byte 2)
                            2'b11: o_io_hex7 <= i_st_data[6:0]; // HEX7 (Byte 3)
                        endcase
                    end
                end
                20'h10004: o_io_lcd <= i_st_data; // 0x10004000 LCD
                default: ;
            endcase
        end
    end
end

// Read logic v?i h? tr? unaligned access
reg [31:0] raw_data_current, raw_data_next;
reg [31:0] combined_data;

always @(*) begin
    if (is_mem) begin
        raw_data_current = dmem[mem_idx];
        raw_data_next = dmem[mem_idx_next];
        
        // K?t h?p d? li?u t? 2 word liên ti?p cho unaligned access
        case (byte_off)
            2'b00: combined_data = raw_data_current; // Aligned
            2'b01: combined_data = {raw_data_next[7:0], raw_data_current[31:8]};
            2'b10: combined_data = {raw_data_next[15:0], raw_data_current[31:16]};
            2'b11: combined_data = {raw_data_next[23:0], raw_data_current[31:24]};
        endcase
    end else begin
        // Ph?n IO gi? nguyên
        case (i_lsu_addr[31:12])
            20'h10000: combined_data = o_io_ledr;
            20'h10001: combined_data = o_io_ledg;
            20'h10002: combined_data = {1'b0, o_io_hex3, 1'b0, o_io_hex2, 1'b0, o_io_hex1, 1'b0, o_io_hex0};
            20'h10003: combined_data = {1'b0, o_io_hex7, 1'b0, o_io_hex6, 1'b0, o_io_hex5, 1'b0, o_io_hex4};
            20'h10004: combined_data = o_io_lcd;
            20'h10010: combined_data = i_io_sw;
            default: combined_data = 32'b0;
        endcase
    end
end

// Extract byte và half-word t? combined_data
reg [7:0] byte_data;
reg [15:0] half_data;
always @(*) begin
    byte_data = combined_data[7:0];
    half_data = combined_data[15:0];
end

// Output assignment
assign o_ld_data = (i_f3 == 3'b000) ? {{24{byte_data[7]}}, byte_data} : // LB
                   (i_f3 == 3'b001) ? {{16{half_data[15]}}, half_data} : // LH
                   (i_f3 == 3'b010) ? combined_data : // LW
                   (i_f3 == 3'b100) ? {24'b0, byte_data} : // LBU
                   (i_f3 == 3'b101) ? {16'b0, half_data} : // LHU
                   32'b0;

endmodule

module control_unit (
    input wire [31:0] i_instr,
    input wire i_br_less,
    input wire i_br_equal,
    output wire o_pc_sel,
    output wire o_rd_wren,
    output wire o_br_un,
    output wire o_br_taken,
    output wire o_opa_sel,
    output wire o_opb_sel,
    output wire [3:0] o_alu_op,
    output wire o_mem_wren,
    output wire [1:0] o_wb_sel,
    output wire o_insn_vld,
    output wire [2:0] o_f3
);
    wire [6:0] opcode = i_instr[6:0];
    wire [2:0] funct3 = i_instr[14:12];
    wire [6:0] funct7 = i_instr[31:25];
    assign o_f3 = funct3;
    assign o_br_taken = (funct3 == 3'b000 & i_br_equal) | // BEQ
                        (funct3 == 3'b001 & ~i_br_equal) | // BNE
                        (funct3 == 3'b100 & i_br_less) | // BLT
                        (funct3 == 3'b101 & ~i_br_less) | // BGE
                        (funct3 == 3'b110 & i_br_less) | // BLTU
                        (funct3 == 3'b111 & ~i_br_less); // BGEU
    assign o_br_un = (funct3[2:1] == 2'b11);
    reg pc_sel, rd_wren, opa_sel, opb_sel, mem_wren;
    reg [3:0] alu_op;
    reg [1:0] wb_sel;
    reg insn_vld;
    always @(*) begin
        pc_sel = 1'b0;
        rd_wren = 1'b0;
        opa_sel = 1'b0;
        opb_sel = 1'b0;
        alu_op = 4'b0000;
        mem_wren = 1'b0;
        wb_sel = 2'b00;
        insn_vld = 1'b1;
        case (opcode)
            7'b0110011: begin // R-type
                rd_wren = 1'b1;
                opa_sel = 1'b1;
                opb_sel = 1'b0;
                case (funct3)
                    3'b000: alu_op = (funct7[5]) ? 4'b0001 : 4'b0000; // SUB/ADD
                    3'b010: alu_op = 4'b0010; // SLT
                    3'b011: alu_op = 4'b0011; // SLTU
                    3'b100: alu_op = 4'b0100; // XOR
                    3'b110: alu_op = 4'b0110; // OR
                    3'b111: alu_op = 4'b0111; // AND
                    3'b001: alu_op = 4'b1000; // SLL
                    3'b101: alu_op = (funct7[5]) ? 4'b1010 : 4'b1001; // SRA/SRL
                    default: insn_vld = 1'b0;
                endcase
            end
            7'b0010011: begin // I-type ALU
                rd_wren = 1'b1;
                opa_sel = 1'b1;
                opb_sel = 1'b1;
                case (funct3)
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b010: alu_op = 4'b0010; // SLTI
                    3'b011: alu_op = 4'b0011; // SLTIU
                    3'b100: alu_op = 4'b0100; // XORI
                    3'b110: alu_op = 4'b0110; // ORI
                    3'b111: alu_op = 4'b0111; // ANDI
                    3'b001: alu_op = 4'b1000; // SLLI
                    3'b101: alu_op = (funct7[5]) ? 4'b1010 : 4'b1001; // SRAI/SRLI
                    default: insn_vld = 1'b0;
                endcase
            end
            7'b0000011: begin // Load
                rd_wren = 1'b1;
                opa_sel = 1'b1;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
                wb_sel = 2'b01;
            end
            7'b0100011: begin // Store
                opa_sel = 1'b1;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
                mem_wren = 1'b1;
            end
            7'b1100011: begin // Branch
                opa_sel = 1'b0;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
                pc_sel = o_br_taken;
            end
            7'b0110111: begin // LUI
                rd_wren = 1'b1;
                opa_sel = 1'b0;
                opb_sel = 1'b1;
                alu_op = 4'b1100; // Use new op for LUI
            end
            7'b0010111: begin // AUIPC
                rd_wren = 1'b1;
                opa_sel = 1'b0;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
            end
            7'b1101111: begin // JAL
                rd_wren = 1'b1;
                opa_sel = 1'b0;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
                pc_sel = 1'b1;
                wb_sel = 2'b10;
            end
            7'b1100111: begin // JALR
                rd_wren = 1'b1;
                opa_sel = 1'b1;
                opb_sel = 1'b1;
                alu_op = 4'b0000;
                pc_sel = 1'b1;
                wb_sel = 2'b10;
            end
// Trong control_unit.sv, thêm case này:

7'b1110011: begin // SYSTEM (EBREAK, ECALL, etc.)

    rd_wren = 1'b0;

    opa_sel = 1'b0;

    opb_sel = 1'b0;

    alu_op = 4'b0000;

    mem_wren = 1'b0;

    wb_sel = 2'b00;

    pc_sel = 1'b0;  // Continue to next instruction

    insn_vld = 1'b1; // Mark as valid NOP

end
            default: insn_vld = 1'b0;
        endcase
    end
    assign o_pc_sel = pc_sel;
    assign o_rd_wren = rd_wren;
    assign o_opa_sel = opa_sel;
    assign o_opb_sel = opb_sel;
    assign o_alu_op = alu_op;
    assign o_mem_wren = mem_wren;
    assign o_wb_sel = wb_sel;
    assign o_insn_vld = insn_vld;
endmodule






           
