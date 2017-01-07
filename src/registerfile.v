module RegisterFile(
    input clk,
    input rst_n,
    input[4:0] raddr0,
    input[4:0] raddr1,
    input[4:0] waddr,
    input wen,
    input[31:0] datain,
    output[31:0] dataout0,
    output[31:0] dataout1,
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

    wire[31:0] regs[0:31];

    assign dataout0 = regs[raddr0];
    assign dataout1 = regs[raddr1];

    assign reg0 = regs[0];
    assign reg1 = regs[1];
    assign reg2 = regs[2];
    assign reg3 = regs[3];
    assign reg4 = regs[4];
    assign reg5 = regs[5];
    assign reg6 = regs[6];
    assign reg7 = regs[7];
    assign reg8 = regs[8];
    assign reg9 = regs[9];
    assign reg10 = regs[10];
    assign reg11 = regs[11];
    assign reg12 = regs[12];
    assign reg13 = regs[13];
    assign reg14 = regs[14];
    assign reg15 = regs[15];
    assign reg16 = regs[16];
    assign reg17 = regs[17];
    assign reg18 = regs[18];
    assign reg19 = regs[19];
    assign reg20 = regs[20];
    assign reg21 = regs[21];
    assign reg22 = regs[22];
    assign reg23 = regs[23];
    assign reg24 = regs[24];
    assign reg25 = regs[25];
    assign reg26 = regs[26];
    assign reg27 = regs[27];
    assign reg28 = regs[28];
    assign reg29 = regs[29];
    assign reg30 = regs[30];
    assign reg31 = regs[31];

    reg[31:0] load;
    wire[31:0] rload;
    assign rload = (wen == 1'b1) ? load : 32'b0;

    DFlipFlop #(.width(32)) regDff0(.clk(clk), .rst_n(rst_n), .load(rload[0]), .d(datain), .q(regs[0]));
    DFlipFlop #(.width(32)) regDff1(.clk(clk), .rst_n(rst_n), .load(rload[1]), .d(datain), .q(regs[1]));
    DFlipFlop #(.width(32)) regDff2(.clk(clk), .rst_n(rst_n), .load(rload[2]), .d(datain), .q(regs[2]));
    DFlipFlop #(.width(32)) regDff3(.clk(clk), .rst_n(rst_n), .load(rload[3]), .d(datain), .q(regs[3]));
    DFlipFlop #(.width(32)) regDff4(.clk(clk), .rst_n(rst_n), .load(rload[4]), .d(datain), .q(regs[4]));
    DFlipFlop #(.width(32)) regDff5(.clk(clk), .rst_n(rst_n), .load(rload[5]), .d(datain), .q(regs[5]));
    DFlipFlop #(.width(32)) regDff6(.clk(clk), .rst_n(rst_n), .load(rload[6]), .d(datain), .q(regs[6]));
    DFlipFlop #(.width(32)) regDff7(.clk(clk), .rst_n(rst_n), .load(rload[7]), .d(datain), .q(regs[7]));
    DFlipFlop #(.width(32)) regDff8(.clk(clk), .rst_n(rst_n), .load(rload[8]), .d(datain), .q(regs[8]));
    DFlipFlop #(.width(32)) regDff9(.clk(clk), .rst_n(rst_n), .load(rload[9]), .d(datain), .q(regs[9]));
    DFlipFlop #(.width(32)) regDff10(.clk(clk), .rst_n(rst_n), .load(rload[10]), .d(datain), .q(regs[10]));
    DFlipFlop #(.width(32)) regDff11(.clk(clk), .rst_n(rst_n), .load(rload[11]), .d(datain), .q(regs[11]));
    DFlipFlop #(.width(32)) regDff12(.clk(clk), .rst_n(rst_n), .load(rload[12]), .d(datain), .q(regs[12]));
    DFlipFlop #(.width(32)) regDff13(.clk(clk), .rst_n(rst_n), .load(rload[13]), .d(datain), .q(regs[13]));
    DFlipFlop #(.width(32)) regDff14(.clk(clk), .rst_n(rst_n), .load(rload[14]), .d(datain), .q(regs[14]));
    DFlipFlop #(.width(32)) regDff15(.clk(clk), .rst_n(rst_n), .load(rload[15]), .d(datain), .q(regs[15]));
    DFlipFlop #(.width(32)) regDff16(.clk(clk), .rst_n(rst_n), .load(rload[16]), .d(datain), .q(regs[16]));
    DFlipFlop #(.width(32)) regDff17(.clk(clk), .rst_n(rst_n), .load(rload[17]), .d(datain), .q(regs[17]));
    DFlipFlop #(.width(32)) regDff18(.clk(clk), .rst_n(rst_n), .load(rload[18]), .d(datain), .q(regs[18]));
    DFlipFlop #(.width(32)) regDff19(.clk(clk), .rst_n(rst_n), .load(rload[19]), .d(datain), .q(regs[19]));
    DFlipFlop #(.width(32)) regDff20(.clk(clk), .rst_n(rst_n), .load(rload[20]), .d(datain), .q(regs[20]));
    DFlipFlop #(.width(32)) regDff21(.clk(clk), .rst_n(rst_n), .load(rload[21]), .d(datain), .q(regs[21]));
    DFlipFlop #(.width(32)) regDff22(.clk(clk), .rst_n(rst_n), .load(rload[22]), .d(datain), .q(regs[22]));
    DFlipFlop #(.width(32)) regDff23(.clk(clk), .rst_n(rst_n), .load(rload[23]), .d(datain), .q(regs[23]));
    DFlipFlop #(.width(32)) regDff24(.clk(clk), .rst_n(rst_n), .load(rload[24]), .d(datain), .q(regs[24]));
    DFlipFlop #(.width(32)) regDff25(.clk(clk), .rst_n(rst_n), .load(rload[25]), .d(datain), .q(regs[25]));
    DFlipFlop #(.width(32)) regDff26(.clk(clk), .rst_n(rst_n), .load(rload[26]), .d(datain), .q(regs[26]));
    DFlipFlop #(.width(32)) regDff27(.clk(clk), .rst_n(rst_n), .load(rload[27]), .d(datain), .q(regs[27]));
    DFlipFlop #(.width(32)) regDff28(.clk(clk), .rst_n(rst_n), .load(rload[28]), .d(datain), .q(regs[28]));
    DFlipFlop #(.width(32)) regDff29(.clk(clk), .rst_n(rst_n), .load(rload[29]), .d(datain), .q(regs[29]));
    DFlipFlop #(.width(32)) regDff30(.clk(clk), .rst_n(rst_n), .load(rload[30]), .d(datain), .q(regs[30]));
    DFlipFlop #(.width(32)) regDff31(.clk(clk), .rst_n(rst_n), .load(rload[31]), .d(datain), .q(regs[31]));

    always @(*) begin
        if (waddr == 5'b0) begin
            load = 32'b0;
        end else begin
            load = 32'b1 << waddr;
        end
    end
endmodule
