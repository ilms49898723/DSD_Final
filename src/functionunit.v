module FunctionUnit(
    input[6:0] opcode,
    input[3:0] fs,
    input[4:0] sh,
    input[31:0] a,
    input[31:0] b,
    output reg[31:0] fout,
    output wire overflow,
    output reg carryout,
    output wire negative,
    output wire zero
);

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
                {carryout, fout} = a + b;
            `SBI:
                {carryout, fout} = a - b;
            `ANI:
                {carryout, fout} = a & b;
            `ORI:
                {carryout, fout} = a | b;
            `XRI:
                {carryout, fout} = a ^ b;
            `AIU:
                {carryout, fout} = a + b;
            `SIU:
                {carryout, fout} = a - b;
            `MOVB:
                {carryout, fout} = b;
            `LSR:
                {carryout, fout} = a << sh;
            `LSL:
                {carryout, fout} = a >> sh;
            `LD:
                {carryout, fout} = a;
            `ST:
                {carryout, fout} = a;
            `JMR:
                {carryout, fout} = a;
            `SLT:
                {carryout, fout} = a - b;
            `BZ:
                {carryout, fout} = (a == 32'b0);
            `BNZ:
                {carryout, fout} = (a != 32'b0);
            `JMP:
                {carryout, fout} = a;
            `JML:
                {carryout, fout} = a;
            default:
                {carryout, fout} = 32'b0;
        endcase
    end
endmodule

