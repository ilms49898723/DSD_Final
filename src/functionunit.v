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

    reg[31:0] right_b;

    assign overflow = (a[31] == right_b[31] && fout[31] != a[31]);
    assign negative = fout[31];
    assign zero = (fout == 32'b0);

    always @(*) begin
        case (fs)
            4'b0000: begin
                right_b = 32'b0;
                {carryout, fout} = a;
            end
            4'b0001: begin
                right_b = 32'b1;
                {carryout, fout} = a + 1'b1;
            end
            4'b0010: begin
                right_b = b;
                {carryout, fout} = a + b;
            end
            4'b0011: begin
                right_b = b + 1'b1;
                {carryout, fout} = a + b + 1'b1;
            end
            4'b0100: begin
                right_b = ~b;
                {carryout, fout} = a + (~b);
            end
            4'b0101: begin
                right_b = ~b + 1'b1;
                {carryout, fout} = a - b;
            end
            4'b0110: begin
                right_b = 32'hffffffff;
                {carryout, fout} = a - 1'b1;
            end
            4'b0111: begin
                right_b = 32'b0;
                {carryout, fout} = a;
            end
            4'b1000: begin
                right_b = b;
                {carryout, fout} = a & b;
            end
            4'b1001: begin
                right_b = b;
                {carryout, fout} = a | b;
            end
            4'b1010: begin
                right_b = b;
                {carryout, fout} = a ^ b;
            end
            4'b1011: begin
                right_b = 32'b0;
                {carryout, fout} = ~a;
            end
            4'b1100: begin
                right_b = b;
                {carryout, fout} = b;
            end
            4'b1101: begin
                right_b = 32'b0;
                {carryout, fout} = a >> sh;
            end
            4'b1110: begin
                right_b = 32'b0;
                {carryout, fout} = a << sh;
            end
            4'b1111: begin
                right_b = 32'b0;
                {carryout, fout} = 33'b0;
            end
            default: begin
                right_b = 32'b0;
                {carryout, fout} = 33'b0;
            end
        endcase
    end
endmodule

