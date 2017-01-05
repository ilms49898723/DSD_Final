module SignExtend(
    input[15:0] in,
    output[31:0] out
);

    reg[31:0] out;

    always @(*) begin
        out = {
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15],
            in[15:0]
        };
    end
endmodule

module ZeroFill(
    input[15:0] in,
    output[31:0] out
);

    reg[31:0] out;

    always @(*) begin
        out = { 16'b0, in[15:0] };
    end
endmodule
