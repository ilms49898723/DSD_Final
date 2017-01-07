module DFlipFlop_32(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input[31:0] d;
    output[31:0] q;

    reg[31:0] q;

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

module DFlipFlop_7(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input[6:0] d;
    output[6:0] q;

    reg[6:0] q;

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

module DFlipFlop_5(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input[4:0] d;
    output[4:0] q;

    reg[4:0] q;

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

module DFlipFlop_4(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input[3:0] d;
    output[3:0] q;

    reg[3:0] q;

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

module DFlipFlop_2(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input[1:0] d;
    output[1:0] q;

    reg[1:0] q;

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

module DFlipFlop_1(
    clk,
    rst_n,
    load,
    d,
    q
);

    input clk;
    input rst_n;
    input load;
    input d;
    output q;

    reg q;

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
