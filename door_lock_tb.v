`timescale 1ns / 1ps

module door_lock_tb();

  reg clk;
  reg rst;
  reg [3:0] keypad;
  wire [6:0] seg;
  wire buzzer;
  wire lock;

  parameter clk_period = 5; // 100 MHz
  parameter sim_time = 500; // 500 ns

  door_lock dut (
    .clk(clk),
    .rst(rst),
    .keypad(keypad),
    .seg(seg),
    .buzzer(buzzer),
    .lock(lock)
  );

  initial begin
    clk = 0;
    forever #clk_period clk = ~clk;
  end

  initial begin
    rst = 1;
    keypad = 4'b0000;
    #10 rst = 0; // Release reset after 10 ns

    // Enter correct password
    #10 keypad = 4'b0001; // 1
    #10 keypad = 4'b0010; // 2
    #10 keypad = 4'b0011; // 3
    #10 keypad = 4'b0100; // 4
    #10 keypad = 4'b000;
    #10 rst = 1;
   #10 rst = 0;
    #10 keypad = 4'b0011; // 3
    #10 keypad = 4'b0101; // 5
    #10 keypad = 4'b0001; // 1
    #10 keypad = 4'b0110; // 6
    #10 keypad = 4'b000;
    #10 rst = 1;
    #10 rst = 0;
    #10 keypad = 4'b0011; // 1
    #10 keypad = 4'b0101; // 2
    #10 keypad = 4'b0001; // 3
    #10 keypad = 4'b0110; // 4
    #10 keypad = 4'b000;
    #10 rst = 1;
    #10 rst = 0;    

    // Wait for 200 ns before ending the simulation
    #20 $finish;
  end

  // Display the output signals
  always @(clk) begin
    $display("clk=%d, rst=%d, keypad=%d, seg=%d, buzzer=%d, lock=%d",
             clk, rst, keypad, seg, buzzer, lock);
  end

endmodule
