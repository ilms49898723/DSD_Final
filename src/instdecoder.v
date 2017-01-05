`include "opcode.v"

module InstDecode(
    // instruction
    input[31:0] inst,
    // operation code
    output[6:0] opcode,
    // destination register
    output[4:0] dr,
    // source register a
    output[4:0] sa,
    // source register b
    output[4:0] sb,
    // constant (immediate)
    output[14:0] imm,
    // shift
    output[4:0] sh
    // register write
    output rw,
    // mux d select
    output[1:0] md,
    // branch
    output[1:0] bs,
    // branch
    output ps,
    // memory write
    output mw,
    // function select
    output[3:0] fs,
    // mux a select
    output ma,
    // mux b select
    output mb,
);

    assign opcode = inst[31:25];
    assign dr = inst[24:20];
    assign sa = inst[19:15];
    assign sb = inst[14:10];
    assign imm = inst[14:0];
    assign sh = inst[4:0];

    reg rw;
    reg[1:0] md;
    reg[1:0] bs;
    reg ps;
    reg mw;
    reg[3:0] fs;
    reg ma;
    reg mb;
    reg cs;

    always @(*) begin
        if (opcode == `NOP ||
            opcode == `ST  ||
            opcode == `JMR ||
            opcode == `BZ  ||
            opcode == `BNZ ||
            opcode == `JMP) begin
            rw = 1'b0;
        end else begin
            rw = 1'b1;
        end
    end

    always @(*) begin
        if (opcode == `LD) begin
            md = 2'b01;
        end else if (opcode == `SLT) begin
            md = 2'b10;
        end else begin
            md = 2'b0;
        end
    end

    always @(*) begin
        if (opcode == `JMR) begin
            bs = 2'b10;
        end else if (opcode == `BZ ||
            opcode == `BNZ) begin
            bs = 2'b01;
        end else if (opcode == `JMP ||
            opcode == `JML) begin
            bs = 2'b11
        end else begin
            bs = 2'b0;
        end
    end

    always @(*) begin
        if (opcode == `BNZ) begin
            ps = 1'b1;
        end else begin
            ps = 1'b0;
        end
    end

    always @(*) begin
        if (opcode == `ST) begin
            mw = 1'b1;
        end else begin
            mw = 1'b0;
        end
    end

    always @(*) begin
        fs = opcode[3:0];
    end

    // always @(*) begin
    //     case (opcode)
    //         `NOP:
    //             fs = 4'b0000;
    //         `MOVA:
    //             fs = 4'b0000;
    //         `ADD:
    //             fs = 4'b0010;
    //         `SUB:
    //             fs = 4'b0101;
    //         `AND:
    //             fs = 4'b1000;
    //         `OR:
    //             fs = 4'b1001;
    //         `XOR:
    //             fs = 4'b1010;
    //         `NOT:
    //             fs = 4'b1011;
    //         `ADI:
    //             fs = 4'b0010;
    //         `SBI:
    //             fs = 4'b0101;
    //         `ANI:
    //             fs = 4'b1000;
    //         `ORI:
    //             fs = 4'b1001;
    //         `XRI:
    //             fs = 4'b1010;
    //         `AIU:
    //             fs = 4'b0010;
    //         `SIU:
    //             fs = 4'b0101;
    //         `MOVB:
    //             fs = 4'b1100;
    //         `LSR:
    //             fs = 4'b1101;
    //         `LSL:
    //             fs = 4'b1110;
    //         `SLT:
    //             fs = 4'b0101;
    //         `BZ:
    //             fs = 4'b0000;
    //         `BNZ:
    //             fs = 4'b0000;
    //         `JML:
    //             fs = 4'b0000;
    //         default:
    //             fs = 4'b0000;
    //     endcase
    // end

    always @(*) begin
        if (opcode == `ADI ||
            opcode == `SBI ||
            opcode == `ANI ||
            opcode == `ORI ||
            opcode == `XRI ||
            opcode == `AIU ||
            opcode == `SIU ||
            opcode == `BZ  ||
            opcode == `BNZ ||
            opcode == `JMP ||
            opcode == `JML) begin
            mb = 1'b1;
        end else begin
            mb = 1'b0;
        end
    end

    always @(*) begin
        if (opcode == `JML) begin
            ma = 1'b1;
        end else begin
            ma = 1'b0;
        end
    end

    always @(*) begin
        if (opcode == `ADI ||
            opcode == `SBI ||
            opcode == `BZ  ||
            opcode == `BNZ ||
            opcode == `JMP ||
            opcode == `JML) begin
            cs = 1'b1;
        end else begin
            cs = 1'b0;
        end
    end

    always @(*) begin
        if (opcode == `BZ  ||
            opcode == `BNZ) begin
            bs = 2'b01;
        end else if (opcode == `JMR) begin
            bs = 2'b10;
        end else if (opcode == `JMP ||
            opcode == `JML) begin
            bs = 2'b11;
        end else begin
            bs = 2'b00;
        end
    end

    always @(*) begin
        if (opcode == `BNZ) begin
            ps = 1'b1;
        end else begin
            ps = 1'b0
        end
    end
endmodule
