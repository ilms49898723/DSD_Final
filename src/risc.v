module Risc(
    input clk,
    input rst_n,
    output halt
);

    parameter program_code = "01_gcd_plain-bin.dat";
    parameter program_data = "01_gcd_plain-data.dat";

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
    wire[31:0] pc_dof;
    wire[31:0] pc_ex;

    // instruction
    wire[31:0] inst_next;
    wire[31:0] inst_if;
    wire[31:0] inst_dof;

    // branch
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
    wire[31:0] busA;
    wire[31:0] busB;
    wire[31:0] busD;

    // inst execute output
    wire[31:0] memout;
    wire[31:0] fout;
    wire overflow;
    wire carryout;
    wire negative;
    wire zero;

    // data hazard stall
    wire ha = (~ma_dof) & (dr_ex == sa_dof) & rw_ex & (dr_ex != 5'b0);
    wire hb = (~mb_dof) & (dr_ex == sb_dof) & rw_ex & (dr_ex != 5'b0);
    wire branchTaken = mc != 2'b0;
    wire dhs = ha | hb | branchTaken;

    // mux c for pc update
    assign mc[0] = ((ps_ex ^ zero) | bs_ex[1]) & bs_ex[0];
    assign mc[1] = bs_ex[1];
    assign pc_plus_1 = pc_if + 32'b1;
    assign brA = pc_ex + busB;
    assign raA = busA;

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
        .waddr(dr_wb),
        .wen(rw_wb),
        .datain(busD),
        .dataout0(regA),
        .dataout1(regB)
    );

    // --- instruction fetch ---

    DFlipFlop #(.width(32)) pcIfDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(~dhs),
        .d(pc_next),
        .q(pc_if)
    );

    InstFetch #(
        .program_code(program_code)
    ) instFetch(
        .clk(clk),
        .pc(pc_if),
        .inst(inst_next)
    );

    assign inst_if = (mc == 2'b0) ? inst_next : 32'b0;

    DFlipFlop #(.width(32)) instDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(~dhs),
        .d(inst_if),
        .q(inst_dof)
    );

    // --- instruction decode ---

    DFlipFlop #(.width(32)) pcDofDFF(
        .clk(clk),
        .rst_n(rst_n),
        .load(~dhs),
        .d(pc_if),
        .q(pc_dof)
    );

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

    assign imm_dof = (dhs == 1'b0) ? imm_dof_t : 15'b0;
    assign op_dof = (dhs == 1'b0) ? op_dof_t : 7'b0;
    assign dr_dof = (dhs == 1'b0) ? dr_dof_t : 5'b0;
    assign sa_dof = (dhs == 1'b0) ? sa_dof_t : 5'b0;
    assign sb_dof = (dhs == 1'b0) ? sb_dof_t : 5'b0;
    assign sh_dof = (dhs == 1'b0) ? sh_dof_t : 5'b0;
    assign fs_dof = (dhs == 1'b0) ? fs_dof_t : 4'b0;
    assign md_dof = (dhs == 1'b0) ? md_dof_t : 2'b0;
    assign bs_dof = (dhs == 1'b0) ? bs_dof_t : 2'b0;
    assign ps_dof = (dhs == 1'b0) ? ps_dof_t : 1'b0;
    assign rw_dof = (dhs == 1'b0) ? rw_dof_t : 1'b0;
    assign mw_dof = (dhs == 1'b0) ? mw_dof_t : 1'b0;
    assign ma_dof = (dhs == 1'b0) ? ma_dof_t : 1'b0;
    assign mb_dof = (dhs == 1'b0) ? mb_dof_t : 1'b0;
    assign cs_dof = (dhs == 1'b0) ? cs_dof_t : 1'b0;

    ConstantUnit constantUnit(.in(imm_dof), .cs(cs_dof), .out(constant));

    Mux32_21 muxA(
        .in0(regA),
        .in1(pc_dof),
        .sel(ma_dof),
        .out(busA)
    );

    Mux32_21 muxB(
        .in0(regB),
        .in1(constant),
        .sel(mb_dof),
        .out(busB)
    );

    // --- execute ---

    DFlipFlop #(.width(7)) opExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(op_dof), .q(op_ex));
    DFlipFlop #(.width(5)) drExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(dr_dof), .q(dr_ex));
    DFlipFlop #(.width(5)) saExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sa_dof), .q(sa_ex));
    DFlipFlop #(.width(5)) sbExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sb_dof), .q(sb_ex));
    DFlipFlop #(.width(5)) shExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(sh_dof), .q(sh_ex));
    DFlipFlop #(.width(4)) fsExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(fs_dof), .q(fs_ex));
    DFlipFlop #(.width(2)) mdExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(md_dof), .q(md_ex));
    DFlipFlop #(.width(2)) bsExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(bs_dof), .q(bs_ex));
    DFlipFlop #(.width(1)) psExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(ps_dof), .q(ps_ex));
    DFlipFlop #(.width(1)) rwExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(rw_dof), .q(rw_ex));
    DFlipFlop #(.width(1)) mwExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(mw_dof), .q(mw_ex));
    DFlipFlop #(.width(1)) maExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(ma_dof), .q(ma_ex));
    DFlipFlop #(.width(1)) mbExDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(mb_dof), .q(mb_ex));

    InstExecute #(
        .program_data(program_data)
    ) instExecute(
        .clk(clk),
        .busA(busA),
        .busB(busB),
        .opcode(op_ex),
        .fs(fs_ex),
        .sh(sh_ex),
        .mw(mw_ex),
        .memout(memout),
        .fout(fout),
        .overflow(overflow),
        .carryout(carryout),
        .negative(negative),
        .zero(zero)
    );

    // --- write back ---

    DFlipFlop #(.width(5)) drWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(dr_ex), .q(dr_wb));
    DFlipFlop #(.width(2)) mdWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(md_ex), .q(md_wb));
    DFlipFlop #(.width(1)) rwWbDFF(.clk(clk), .rst_n(rst_n), .load(1'b1), .d(rw_ex), .q(rw_wb));

    Mux32_31 muxD(
        .in0(fout),
        .in1(memout),
        .in2({31'b0, negative ^ overflow}),
        .sel(md_wb),
        .out(busD)
    );

endmodule
