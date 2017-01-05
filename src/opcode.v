`ifndef CTLWD_V_
`define CTLWD_V_

`define NOP  = 7'b0000000;
`define MOVA = 7'b1000000;
`define ADD  = 7'b0000010;
`define SUB  = 7'b0000101;
`define AND  = 7'b0001000;
`define OR   = 7'b0001001;
`define XOR  = 7'b0001010;
`define NOT  = 7'b0001011;
`define ADI  = 7'b0100010;
`define SBI  = 7'b0100101;
`define ANI  = 7'b0101000;
`define ORI  = 7'b0101001;
`define XRI  = 7'b0101010;
`define AIU  = 7'b0100010;
`define SIU  = 7'b0100101;
`define MOVB = 7'b0001100;
`define LSR  = 7'b0001101;
`define LSL  = 7'b0001110;
`define LD   = 7'b0010000;
`define ST   = 7'b0100000;
`define JMR  = 7'b1110000;
`define SLT  = 7'b1100101;
`define BZ   = 7'b1100000;
`define BNZ  = 7'b1001000;
`define JMP  = 7'b1101000;
`define JML  = 7'b0110000;

`endif
