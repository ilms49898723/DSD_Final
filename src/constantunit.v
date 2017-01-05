module ConstantUnit(
    input[14:0] in,
    input cs,
    output reg[31:0] out
);

    always @(*) begin
        if (cs == 1'b0) begin
            out = { 17'b0, in[14:0] };
        end else begin
            out = {
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14],
                in[14:0]
            };
        end
    end
endmodule
