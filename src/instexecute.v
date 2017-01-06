module InstExecute(
    input clk,
    input[31:0] busA,
    input[31:0] busB,
    input[6:0] opcode,
    input[3:0] fs,
    input[4:0] sh,
    output[31:0] fout,
    output overflow,
    output carryout,
    output negative,
    output zero
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
