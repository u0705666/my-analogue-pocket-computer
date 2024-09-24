`timescale 10ns / 1ps

module full_adder_tb;

    reg a;
    reg b;
    reg cin;
    wire cout;
    wire sum;

    Full_adder dut(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    initial begin
        $dumpfile("full_adder_tb.vcd");
        $dumpvars(0,full_adder_tb);
    end

    initial begin
        a = 0;
        b = 0;
        cin = 0;
        #1; 
        assert(cout == 0) else $fatal(1, "cout is not 0");
        assert(sum == 0) else $fatal(1, "sum is not 0");
        #1 a = 1;
        b = 1;
        cin = 0;
        #1 assert(cout == 1 && sum == 0) else $fatal(1, "expected cout 1, sum 0"); 
        #1 a = 1;
        b = 1;
        cin = 1;
        #1 assert(cout == 1 && sum == 1) else $fatal(1, "expected cout 1, sum 1");
        #1 a = 0; b = 0; cin = 0;
        #20 $stop;
    end

endmodule