module Risc(
    // clock
    input clk,
    // reset
    input rst_n,
    // halt
    output reg halt,
    // instruction
    output wire[31:0] inst_if,
    output wire[31:0] inst_dof,
    output wire[31:0] inst_ex,
    output wire[31:0] inst_wb,
    // register content
    output wire[31:0] reg0,
    output wire[31:0] reg1,
    output wire[31:0] reg2,
    output wire[31:0] reg3,
    output wire[31:0] reg4,
    output wire[31:0] reg5,
    output wire[31:0] reg6,
    output wire[31:0] reg7,
    output wire[31:0] reg8,
    output wire[31:0] reg9,
    output wire[31:0] reg10,
    output wire[31:0] reg11,
    output wire[31:0] reg12,
    output wire[31:0] reg13,
    output wire[31:0] reg14,
    output wire[31:0] reg15,
    output wire[31:0] reg16,
    output wire[31:0] reg17,
    output wire[31:0] reg18,
    output wire[31:0] reg19,
    output wire[31:0] reg20,
    output wire[31:0] reg21,
    output wire[31:0] reg22,
    output wire[31:0] reg23,
    output wire[31:0] reg24,
    output wire[31:0] reg25,
    output wire[31:0] reg26,
    output wire[31:0] reg27,
    output wire[31:0] reg28,
    output wire[31:0] reg29,
    output wire[31:0] reg30,
    output wire[31:0] reg31
);

    // pipeline dff include:
    // 1. ALU output
    // 2. pc
    // 3. instruction
    // 4. rA, rB
    //
    // states:
    // IF -> ID -> EX -> WB
    // fetch
    // decode
    // execute or memory access
    // write back

    // --- signal ---

    // program counter
    wire[31:0] pc_plus_1;
    wire[31:0] pc_next;
    wire[31:0] pc_if;
    wire[31:0] pc_if_wait;
    wire[31:0] pc_dof;
    wire[31:0] pc_dof_plus_1;
    wire[31:0] pc_ex;

    // pipeline enable
    reg enable;
    reg enable_pipeline;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            enable <= 1'b0;
        end else begin
            enable <= 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            enable_pipeline <= 1'b0;
        end else begin
            if (enable == 1'b1) begin
                enable_pipeline <= 1'b1;
            end else begin
                enable_pipeline <= 1'b0;
            end
        end
    end

    // instruction
    wire[31:0] inst_next;
    wire[31:0] inst_dof_t;

    // branch
    wire[1:0] mc_pre;
    wire[1:0] mc;
    wire[31:0] raA;
    wire[31:0] brA;

    // pipeline
    wire[14:0] imm_dof_t;
    wire[6:0] op_dof_t;
    wire[4:0] dr_dof_t;
    wire[4:0] sa_dof_t;
    wire[4:0] sb_dof_t;
    wire[4:0] sh_dof_t;
    wire[3:0] fs_dof_t;
    wire[1:0] md_dof_t;
    wire[1:0] bs_dof_t;
    wire ps_dof_t;
    wire rw_dof_t;
    wire mw_dof_t;
    wire ma_dof_t;
    wire mb_dof_t;
    wire cs_dof_t;

    wire[14:0] imm_dof;
    wire[6:0] op_dof;
    wire[4:0] dr_dof;
    wire[4:0] sa_dof;
    wire[4:0] sb_dof;
    wire[4:0] sh_dof;
    wire[3:0] fs_dof;
    wire[1:0] md_dof;
    wire[1:0] bs_dof;
    wire ps_dof;
    wire rw_dof;
    wire mw_dof;
    wire ma_dof;
    wire mb_dof;
    wire cs_dof;

    wire[14:0] imm_ex;
    wire[6:0] op_ex;
    wire[4:0] dr_ex;
    wire[4:0] sa_ex;
    wire[4:0] sb_ex;
    wire[4:0] sh_ex;
    wire[3:0] fs_ex;
    wire[1:0] md_ex;
    wire[1:0] bs_ex;
    wire ps_ex;
    wire rw_ex;
    wire mw_ex;
    wire ma_ex;
    wire mb_ex;

    wire[31:0] constant;

    wire[4:0] dr_wb;
    wire[1:0] md_wb;
    wire rw_wb;

    // rA and rB
    wire[31:0] regA;
    wire[31:0] regB;

    // bus
    wire[31:0] busA_dof;
    wire[31:0] busA_ex;
    wire[31:0] busB_dof;
    wire[31:0] busB_ex;
    wire[31:0] busD;
    wire[31:0] busDF;

    // inst execute output
    wire[31:0] memout_ex;
    wire[31:0] memout_wb;
    wire[31:0] fout_ex;
    wire[31:0] fout_wb;
    wire overflow;
    wire overflow_wb;
    wire carryout;
    wire negative;
    wire negative_wb;
    wire zero;

    // data hazard stall
    wire ha = (~ma_dof) & (dr_ex == sa_dof) & rw_ex & (dr_ex != 5'b0);
    wire hb = (~mb_dof) & (dr_ex == sb_dof) & rw_ex & (dr_ex != 5'b0);
    wire branchTaken = mc != 2'b0;
    wire dhs = ha | hb | branchTaken;

    // debugging
    // always @(posedge clk) begin
    //     $display("pc_if  %d", pc_if);
    //     $display("pc_ifw %d, inst_if  %b", pc_if_wait, inst_if);
    //     $display("pc_dof %d, inst_dof %b", pc_dof, inst_dof);
    //     $display("pc_ex  %d, inst_ex  %b", pc_ex, inst_ex);
    //     $display("");
    // end

    // mux c for pc update
    assign mc[0] = ((ps_ex ^ zero) | bs_ex[1]) & bs_ex[0];
    assign mc[1] = bs_ex[1];
    assign pc_plus_1 = pc_if + 32'b1;
    assign brA = pc_ex + busB_ex + 32'b1;
    assign raA = busA_ex;

    DFlipFlop_2 mcPreDff(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(mc), .q(mc_pre));

    Mux32_41 muxC(
        .in0(pc_plus_1),
        .in1(brA),
        .in2(raA),
        .in3(brA),
        .sel(mc),
        .out(pc_next)
    );

    // --- register file ---

    RegisterFile registerFile(
        .clk(clk),
        .rst_n(rst_n),
        .raddr0(sa_dof),
        .raddr1(sb_dof),
        .waddr(dr_ex),
        .wen(rw_ex),
        .datain(busDF),
        .dataout0(regA),
        .dataout1(regB),
        .reg0(reg0),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .reg4(reg4),
        .reg5(reg5),
        .reg6(reg6),
        .reg7(reg7),
        .reg8(reg8),
        .reg9(reg9),
        .reg10(reg10),
        .reg11(reg11),
        .reg12(reg12),
        .reg13(reg13),
        .reg14(reg14),
        .reg15(reg15),
        .reg16(reg16),
        .reg17(reg17),
        .reg18(reg18),
        .reg19(reg19),
        .reg20(reg20),
        .reg21(reg21),
        .reg22(reg22),
        .reg23(reg23),
        .reg24(reg24),
        .reg25(reg25),
        .reg26(reg26),
        .reg27(reg27),
        .reg28(reg28),
        .reg29(reg29),
        .reg30(reg30),
        .reg31(reg31)
    );

    // --- instruction fetch ---

    DFlipFlop_32 pcIfDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(enable),
        .d(pc_next),
        .q(pc_if)
    );

    DFlipFlop_32 pcIfWaitDff(
        .clk(clk),
        .rst_n(rst_n),
        .load(enable),
        .d(pc_if),
        .q(pc_if_wait)
    );

    InstFetch instFetch(
        .clk(clk),
        .iclk(~clk),
        .pc(pc_if),
        .inst(inst_next)
    );

    assign inst_if = (mc == 2'b0 && mc_pre == 2'b0 && enable_pipeline == 1'b1) ? inst_next : 32'b0;

    // --- instruction decode ---

    DFlipFlop_32 instDofDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(1'b1),
        .d(inst_if),
        .q(inst_dof_t)
    );

    DFlipFlop_32 pcDofDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(1'b1),
        .d(pc_if_wait),
        .q(pc_dof)
    );

    assign inst_dof = (mc == 2'b0) ? inst_dof_t : 32'b0;

    InstDecode instDecode(
        .inst(inst_dof),
        .opcode(op_dof_t),
        .dr(dr_dof_t),
        .sa(sa_dof_t),
        .sb(sb_dof_t),
        .imm(imm_dof_t),
        .sh(sh_dof_t),
        .rw(rw_dof_t),
        .md(md_dof_t),
        .bs(bs_dof_t),
        .ps(ps_dof_t),
        .mw(mw_dof_t),
        .fs(fs_dof_t),
        .ma(ma_dof_t),
        .mb(mb_dof_t),
        .cs(cs_dof_t)
    );

    assign imm_dof = (mc == 2'b0) ? imm_dof_t : 15'b0;
    assign op_dof = (mc == 2'b0) ? op_dof_t : 7'b0;
    assign dr_dof = (mc == 2'b0) ? dr_dof_t : 5'b0;
    assign sa_dof = (mc == 2'b0) ? sa_dof_t : 5'b0;
    assign sb_dof = (mc == 2'b0) ? sb_dof_t : 5'b0;
    assign sh_dof = (mc == 2'b0) ? sh_dof_t : 5'b0;
    assign fs_dof = (mc == 2'b0) ? fs_dof_t : 4'b0;
    assign md_dof = (mc == 2'b0) ? md_dof_t : 2'b0;
    assign bs_dof = (mc == 2'b0) ? bs_dof_t : 2'b0;
    assign ps_dof = (mc == 2'b0) ? ps_dof_t : 1'b0;
    assign rw_dof = (mc == 2'b0) ? rw_dof_t : 1'b0;
    assign mw_dof = (mc == 2'b0) ? mw_dof_t : 1'b0;
    assign ma_dof = (mc == 2'b0) ? ma_dof_t : 1'b0;
    assign mb_dof = (mc == 2'b0) ? mb_dof_t : 1'b0;
    assign cs_dof = (mc == 2'b0) ? cs_dof_t : 1'b0;

    ConstantUnit constantUnit(.in(imm_dof), .cs(cs_dof), .out(constant));

    assign pc_dof_plus_1 = pc_dof + 1'b1;

    Mux32_31 muxA(
        .in0(regA),
        .in1(pc_dof_plus_1),
        .in2(busDF),
        .sel({ha, ma_dof}),
        .out(busA_dof)
    );

    Mux32_31 muxB(
        .in0(regB),
        .in1(constant),
        .in2(busDF),
        .sel({hb, mb_dof}),
        .out(busB_dof)
    );

    // --- execute ---

    DFlipFlop_32 pcExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(pc_dof), .q(pc_ex));
    DFlipFlop_32 instExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(inst_dof), .q(inst_ex));

    DFlipFlop_32 busAExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(busA_dof), .q(busA_ex));
    DFlipFlop_32 busBExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(busB_dof), .q(busB_ex));

    DFlipFlop_7 opExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(op_dof), .q(op_ex));
    DFlipFlop_5 drExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(dr_dof), .q(dr_ex));
    DFlipFlop_5 saExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sa_dof), .q(sa_ex));
    DFlipFlop_5 sbExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sb_dof), .q(sb_ex));
    DFlipFlop_5 shExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sh_dof), .q(sh_ex));
    DFlipFlop_4 fsExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(fs_dof), .q(fs_ex));
    DFlipFlop_2 mdExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(md_dof), .q(md_ex));
    DFlipFlop_2 bsExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(bs_dof), .q(bs_ex));
    DFlipFlop_1 psExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(ps_dof), .q(ps_ex));
    DFlipFlop_1 rwExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(rw_dof), .q(rw_ex));
    DFlipFlop_1 mwExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(mw_dof), .q(mw_ex));
    DFlipFlop_1 maExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(ma_dof), .q(ma_ex));
    DFlipFlop_1 mbExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(mb_dof), .q(mb_ex));

    InstExecute instExecute(
        .clk(clk),
        .dclk(~clk),
        .busA(busA_ex),
        .busB(busB_ex),
        .opcode(op_ex),
        .fs(fs_ex),
        .sh(sh_ex),
        .mw(mw_dof),
        .memaddr(busA_dof),
        .memdatain(busB_dof),
        .memout(memout_ex),
        .fout(fout_ex),
        .overflow(overflow),
        .carryout(carryout),
        .negative(negative),
        .zero(zero)
    );

    Mux32_31 muxDForwarding(
        .in0(fout_ex),
        .in1(memout_ex),
        .in2({31'b0, negative ^ overflow}),
        .sel(md_ex),
        .out(busDF)
    );

    // --- write back ---

    DFlipFlop_32 instWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(inst_ex), .q(inst_wb));
    DFlipFlop_32 foutWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(fout_ex), .q(fout_wb));
    DFlipFlop_32 memoutWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(memout_ex), .q(memout_wb));
    DFlipFlop_5 drWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(dr_ex), .q(dr_wb));
    DFlipFlop_2 mdWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(md_ex), .q(md_wb));
    DFlipFlop_1 rwWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(rw_ex), .q(rw_wb));
    DFlipFlop_1 ovWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(overflow), .q(overflow_wb));
    DFlipFlop_1 neWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(negative), .q(negative_wb));

    Mux32_31 muxD(
        .in0(fout_wb),
        .in1(memout_wb),
        .in2({31'b0, negative_wb ^ overflow_wb}),
        .sel(md_wb),
        .out(busD)
    );

    // --- pipeline halt ---
    // pipeline halt signal
    always @(posedge clk) begin
        if (inst_if == 32'hffffffff &&
            inst_dof == 32'hffffffff &&
            inst_ex == 32'hffffffff &&
            inst_wb == 32'hffffffff) begin
            halt = 1'b1;
        end else begin
            halt = 1'b0;
        end
    end
endmodule
