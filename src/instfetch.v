module InstFetch(
    input clk,
    input[31:0] pc,
    output[10:0] iaddr
);

    assign iaddr = pc[10:0];

endmodule
