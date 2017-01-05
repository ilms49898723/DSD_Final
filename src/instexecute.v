module InstExecute(
    input clk,
    input[31:0] busA,
    input[31:0] busB,
    input[6:0] opcode,
    input[3:0] fs,
    input[4:0] sh,
    input mw,
    output[31:0] memout,
    output[31:0] fout,
    output overflow,
    output carryout,
    output negative,
    output zero
);

    parameter program_data = "";

    // memory access

    // D memory signals
    wire dm_cen;
    wire dm_wen;
    wire [10:0] dm_addr;
    wire [31:0] dm_datain;
    wire dm_oen;
    wire [31:0] dm_dataout;

    assign dm_cen = 1'b0;
    assign dm_oen = 1'b0;
    assign dm_wen = mw;
    assign dm_addr = busA[10:0];
    assign dm_datain = busB;

    assign memout = dm_dataout;

    RAM2Kx32 #(
        .preload_file(program_data)
    ) dMem (
        .Q(dm_dataout),
        .CLK(clk),
        .CEN(dm_cen),
        .WEN(dm_wen),
        .A(dm_addr),
        .D(dm_datain),
        .OEN(dm_oen)
    );

    // function unit

    FunctionUnit functionUnit(
        .opcode(opcode),
        .fs(fs),
        .sh(sh),
        .a(busA),
        .b(busB),
        .fout(fout),
        .overflow(overflow),
        .carryout(carryout),
        .negative(negative),
        .zero(zero)
    );
endmodule
