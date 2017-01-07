module InstExecute(
    input clk,
    input[31:0] busA,
    input[31:0] busB,
    input[6:0] opcode,
    input[3:0] fs,
    input[4:0] sh,
    input mw,
    input[31:0] memaddr,
    input[31:0] memdatain,
    output[31:0] memout,
    output[31:0] fout,
    output overflow,
    output carryout,
    output negative,
    output zero
);

    parameter program_data = "01_gcd_plain-data.dat";

    // memory access

    // D memory signals
    wire dm_cen;
    reg dm_wen;
    reg [10:0] dm_addr;
    reg [31:0] dm_datain;
    wire dm_oen;
    wire [31:0] dm_dataout;

    assign dm_cen = 1'b0;
    assign dm_oen = 1'b0;

    assign memout = dm_dataout;

    always @(posedge clk) begin
        #(1)
        dm_wen <= ~mw;
        dm_addr <= memaddr[10:0];
        dm_datain <= memdatain;
    end

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
