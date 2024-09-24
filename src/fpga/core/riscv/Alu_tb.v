`timescale 10ns / 10ns

module alu_tb;

    reg a;
    reg b;
    reg cin;
    reg[1:0] op;
    wire cout;
    wire result;

    Alu dut(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .op(op),
        .result(result)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0,alu_tb);
    end

    initial begin
        a = 0;
        b = 0;
        cin = 0;
        op = 2'b0;
        #1;
        assert(cout == 0);
        assert(result == 0);
        a = 1;
        #2;
        assert(result == 1);
        b = 1;
        #3;
        assert(result == 1);
    end

endmodule