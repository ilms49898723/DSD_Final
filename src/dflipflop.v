module DFlipFlop(
    parameter width = 32
)(
    input clk,
    input rst_n,
    input load,
    input[width - 1:0] d,
    output[width - 1:0] q
);

    reg[width - 1:0] q;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            q <= 0;
        end else begin
            if (load == 1'b1) begin
                q <= d;
            end else begin
                q <= q;
            end
        end
    end
endmodule
