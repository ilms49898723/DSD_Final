`include "opcode.v"

module FunctionUnit(
    input[6:0] opcode,
    input[3:0] fs,
    input[4:0] sh,
    input[31:0] a,
    input[31:0] b,
    output[31:0] fout,
    output overflow,
    output carryout,
    output negative,
    output zero
);

    reg[31:0] fout;
    reg carryout;

    wire[31:0] ex_b;
    SignExtend signExtend(.in(b[15:0]), .out(ex_b));

    wire[31:0] zr_b;
    ZeroFill zeroFill(.in(b[15:0]), .out(zr_b));

    always @(*) begin
        case (opcode)
            `NOP:
                {carryout, fout} = a;
            `MOVA:
                {carryout, fout} = a;
            `ADD:
                {carryout, fout} = a + b;
            `SUB:
                {carryout, fout} = a - b;
            `AND:
                {carryout, fout} = a & b;
            `OR:
                {carryout, fout} = a | b;
            `XOR:
                {carryout, fout} = a ^ b;
            `NOT:
                {carryout, fout} = ~a;
            `ADI:
                {carryout, fout} = a + ex_b;
            `SBI:
                {carryout, fout} = a - ex_b;
            `ANI:
                {carryout, fout} = a & zr_b;
            `ORI:
                {carryout, fout} = a | zr_b;
            `XRI:
                {carryout, fout} = a ^ zr_b;
            `AIU:
                {carryout, fout} = a + zr_b;
            `SIU:
                {carryout, fout} = a - zr_b;
            `MOVB:
                {carryout, fout} = b;
            `LSR:
                {carryout, fout} = a << sh;
            `LSL:
                {carryout, fout} = a >> sh;
            `LD:
                {carryout, fout} = 32'b0;
            `ST:
                {carryout, fout} = 32'b0;
            `JMR:
                {carryout, fout} = a;
            `SLT:
                {carryout, fout} = a - b;
            `BZ:
                {carryout, fout} = (a == 32'b0);
            `BNZ:
                {carryout, fout} = (a != 32'b0);
            `JMP:
                {carryout, fout} = 32'b0;
            `JML:
                {carryout, fout} = 32'b0;
            default:
                {carryout, fout} = 32'b0;
        endcase
    end
endmodule


