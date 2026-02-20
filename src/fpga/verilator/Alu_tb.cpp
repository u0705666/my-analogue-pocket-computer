// Simple Verilator testbench for Alu module
// This demonstrates testing a combinational module

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VAlu.h"
#include <iostream>
#include <cassert>

vluint64_t main_time = 0;

double sc_time_stamp() {
    return main_time;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Verilated::traceEverOn(true);
    
    VAlu* top = new VAlu;
    
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("Alu_tb.vcd");
    
    std::cout << "Testing Alu module..." << std::endl;
    
    int test_count = 0;
    int pass_count = 0;
    
    // Test cases
    struct TestCase {
        int a, b, cin, op;
        int expected_result, expected_cout;
        const char* description;
    };
    
    TestCase tests[] = {
        // AND operation (op=0)
        {1, 1, 0, 0, 1, 0, "AND: 1 & 1"},
        {1, 0, 0, 0, 0, 0, "AND: 1 & 0"},
        {0, 1, 0, 0, 0, 0, "AND: 0 & 1"},
        {0, 0, 0, 0, 0, 0, "AND: 0 & 0"},
        
        // OR operation (op=1)
        {1, 1, 0, 1, 1, 0, "OR: 1 | 1"},
        {1, 0, 0, 1, 1, 0, "OR: 1 | 0"},
        {0, 1, 0, 1, 1, 0, "OR: 0 | 1"},
        {0, 0, 0, 1, 0, 0, "OR: 0 | 0"},
        
        // ADD operation (op=2)
        {1, 1, 0, 2, 0, 1, "ADD: 1 + 1 (no carry)"},
        {1, 1, 1, 2, 1, 1, "ADD: 1 + 1 + 1 (with carry)"},
        {0, 0, 0, 2, 0, 0, "ADD: 0 + 0"},
        {1, 0, 0, 2, 1, 0, "ADD: 1 + 0"},
    };
    
    for (auto& test : tests) {
        test_count++;
        
        // Set inputs
        top->a = test.a;
        top->b = test.b;
        top->cin = test.cin;
        top->op = test.op;
        
        // Evaluate (combinational logic)
        top->eval();
        tfp->dump(main_time++);
        
        // Check results
        bool result_ok = (top->result == test.expected_result);
        bool cout_ok = (top->cout == test.expected_cout);
        
        if (result_ok && cout_ok) {
            pass_count++;
            std::cout << "PASS: " << test.description << std::endl;
        } else {
            std::cout << "FAIL: " << test.description 
                      << " (got result=" << (int)top->result 
                      << ", cout=" << (int)top->cout
                      << ", expected result=" << test.expected_result
                      << ", cout=" << test.expected_cout << ")" << std::endl;
        }
    }
    
    top->final();
    tfp->close();
    
    delete top;
    delete tfp;
    
    std::cout << "\nTest Summary: " << pass_count << "/" << test_count << " tests passed" << std::endl;
    
    if (pass_count == test_count) {
        std::cout << "All tests passed!" << std::endl;
        return 0;
    } else {
        std::cout << "Some tests failed!" << std::endl;
        return 1;
    }
}
