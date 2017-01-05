module RegisterFile(
    input clk,
    input rst_n,
    input[4:0] raddr0,
    input[4:0] raddr1,
    input[4:0] waddr,
    input wen,
    input[31:0] datain,
    output[31:0] dataout0,
    output[31:0] dataout1
);

    assign dataout0 = regs[raddr0];
    assign dataout1 = regs[raddr1];

    reg[31:0] load;
    wire[31:0] rload;
    assign rload = (wen == 1'b1) ? load : 32'b0;

    wire[31:0] regs[0:31];

    DFlipFlop #(.width(32)) reg0(.clk(clk), .rst_n(rst_n), .load(rload[0]), .d(datain), .q(regs[0]));
    DFlipFlop #(.width(32)) reg1(.clk(clk), .rst_n(rst_n), .load(rload[1]), .d(datain), .q(regs[1]));
    DFlipFlop #(.width(32)) reg2(.clk(clk), .rst_n(rst_n), .load(rload[2]), .d(datain), .q(regs[2]));
    DFlipFlop #(.width(32)) reg3(.clk(clk), .rst_n(rst_n), .load(rload[3]), .d(datain), .q(regs[3]));
    DFlipFlop #(.width(32)) reg4(.clk(clk), .rst_n(rst_n), .load(rload[4]), .d(datain), .q(regs[4]));
    DFlipFlop #(.width(32)) reg5(.clk(clk), .rst_n(rst_n), .load(rload[5]), .d(datain), .q(regs[5]));
    DFlipFlop #(.width(32)) reg6(.clk(clk), .rst_n(rst_n), .load(rload[6]), .d(datain), .q(regs[6]));
    DFlipFlop #(.width(32)) reg7(.clk(clk), .rst_n(rst_n), .load(rload[7]), .d(datain), .q(regs[7]));
    DFlipFlop #(.width(32)) reg8(.clk(clk), .rst_n(rst_n), .load(rload[8]), .d(datain), .q(regs[8]));
    DFlipFlop #(.width(32)) reg9(.clk(clk), .rst_n(rst_n), .load(rload[9]), .d(datain), .q(regs[9]));
    DFlipFlop #(.width(32)) reg10(.clk(clk), .rst_n(rst_n), .load(rload[10]), .d(datain), .q(regs[10]));
    DFlipFlop #(.width(32)) reg11(.clk(clk), .rst_n(rst_n), .load(rload[11]), .d(datain), .q(regs[11]));
    DFlipFlop #(.width(32)) reg12(.clk(clk), .rst_n(rst_n), .load(rload[12]), .d(datain), .q(regs[12]));
    DFlipFlop #(.width(32)) reg13(.clk(clk), .rst_n(rst_n), .load(rload[13]), .d(datain), .q(regs[13]));
    DFlipFlop #(.width(32)) reg14(.clk(clk), .rst_n(rst_n), .load(rload[14]), .d(datain), .q(regs[14]));
    DFlipFlop #(.width(32)) reg15(.clk(clk), .rst_n(rst_n), .load(rload[15]), .d(datain), .q(regs[15]));
    DFlipFlop #(.width(32)) reg16(.clk(clk), .rst_n(rst_n), .load(rload[16]), .d(datain), .q(regs[16]));
    DFlipFlop #(.width(32)) reg17(.clk(clk), .rst_n(rst_n), .load(rload[17]), .d(datain), .q(regs[17]));
    DFlipFlop #(.width(32)) reg18(.clk(clk), .rst_n(rst_n), .load(rload[18]), .d(datain), .q(regs[18]));
    DFlipFlop #(.width(32)) reg19(.clk(clk), .rst_n(rst_n), .load(rload[19]), .d(datain), .q(regs[19]));
    DFlipFlop #(.width(32)) reg20(.clk(clk), .rst_n(rst_n), .load(rload[20]), .d(datain), .q(regs[20]));
    DFlipFlop #(.width(32)) reg21(.clk(clk), .rst_n(rst_n), .load(rload[21]), .d(datain), .q(regs[21]));
    DFlipFlop #(.width(32)) reg22(.clk(clk), .rst_n(rst_n), .load(rload[22]), .d(datain), .q(regs[22]));
    DFlipFlop #(.width(32)) reg23(.clk(clk), .rst_n(rst_n), .load(rload[23]), .d(datain), .q(regs[23]));
    DFlipFlop #(.width(32)) reg24(.clk(clk), .rst_n(rst_n), .load(rload[24]), .d(datain), .q(regs[24]));
    DFlipFlop #(.width(32)) reg25(.clk(clk), .rst_n(rst_n), .load(rload[25]), .d(datain), .q(regs[25]));
    DFlipFlop #(.width(32)) reg26(.clk(clk), .rst_n(rst_n), .load(rload[26]), .d(datain), .q(regs[26]));
    DFlipFlop #(.width(32)) reg27(.clk(clk), .rst_n(rst_n), .load(rload[27]), .d(datain), .q(regs[27]));
    DFlipFlop #(.width(32)) reg28(.clk(clk), .rst_n(rst_n), .load(rload[28]), .d(datain), .q(regs[28]));
    DFlipFlop #(.width(32)) reg29(.clk(clk), .rst_n(rst_n), .load(rload[29]), .d(datain), .q(regs[29]));
    DFlipFlop #(.width(32)) reg30(.clk(clk), .rst_n(rst_n), .load(rload[30]), .d(datain), .q(regs[30]));
    DFlipFlop #(.width(32)) reg31(.clk(clk), .rst_n(rst_n), .load(rload[31]), .d(datain), .q(regs[31]));

    always @(*) begin
        if (waddr == 5'b0) begin
            rload = 32'b0;
        end else begin
            rload = 32'b1 << waddr;
        end
    end
endmodule
