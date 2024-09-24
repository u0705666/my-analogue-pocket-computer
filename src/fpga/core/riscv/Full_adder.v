module Full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign cout = b&cin | a&cin | a&b;
    assign sum = a&~b&~cin | ~a&b&~cin | ~a&~b&cin | a&b&cin;

endmodule