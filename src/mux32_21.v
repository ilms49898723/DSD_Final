module Mux32_21(
    input[31:0] in0,
    input[31:0] in1,
    input sel,
    output[31:0] out
);

    reg[31:0] out;

    always @(*) begin
        if (sel == 1'b0) begin
            out = in0;
        end else begin
            out = in1;
        end
    end
endmodule
