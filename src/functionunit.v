module FunctionUnit(
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

    assign overflow = (a[31] == b[31] && fout[31] != a[31]);
    assign negative = fout[31];
    assign zero = (fout == 32'b0);

    always @(*) begin
        case (fs)
            4'b0000:
                {carryout, fout} = a;
            4'b0001:
                {carryout, fout} = a + 1'b1;
            4'b0010:
                {carryout, fout} = a + b;
            4'b0011:
                {carryout, fout} = a + b + 1'b1;
            4'b0100:
                {carryout, fout} = a + (~b);
            4'b0101:
                {carryout, fout} = a - b;
            4'b0110:
                {carryout, fout} = a - 1'b1;
            4'b0111:
                {carryout, fout} = a;
            4'b1000:
                {carryout, fout} = a & b;
            4'b1001:
                {carryout, fout} = a | b;
            4'b1010:
                {carryout, fout} = a ^ b;
            4'b1011:
                {carryout, fout} = ~a;
            4'b1100:
                {carryout, fout} = b;
            4'b1101:
                {carryout, fout} = a << b;
            4'b1110:
                {carryout, fout} = a >> b;
            4'b1111:
                {carryout, fout} = 33'b0;
            default:
                {carryout, fout} = 33'b0;
        endcase
    end
endmodule

