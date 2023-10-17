`timescale 1ns/1ps
module door_lock (
  input clk, // Clock input
  input rst, // Reset input
  input [3:0] keypad, // Keypad input
  output reg [6:0] seg, // Seven-segment display output
  output reg buzzer, // Buzzer output
  output reg lock // Lock output
);

  parameter [3:0] p1 = 4'b0001;//1
  parameter [3:0] p2 = 4'b0010;//2
  parameter [3:0] p3 = 4'b0011;//3
  parameter [3:0] p4 = 4'b0100;//4
  reg [3:0] input_password [3:0]; // Register array to store input password digits
  reg [2:0] state; // FSM state register
  reg lock_state; // Lock state register
  
always @(posedge clk, posedge rst) begin
    if (rst == 1) begin
      input_password[0] <= 4'b0000;
      input_password[1] <= 4'b0000;
      input_password[2] <= 4'b0000;
      input_password[3] <= 4'b0000;
      state <= 3'b000;
      lock_state <= 1'b1;
      buzzer <= 1'b0;
      seg <= 7'b0000000; // Display 0 on seven-segment display
      lock <= 1'b1;
    end else begin
      case (state)
        3'b000: begin // Wait for first password digit
          if (keypad != 4'b0000) begin
            input_password[0] <= keypad;
            state <= 3'b001;
          end 
        end
        3'b001: begin // Wait for second password digit
          if (keypad != 4'b0000) begin
            input_password[1] <= keypad;
            state <= 3'b010;
          end
        end
        3'b010: begin // Wait for third password digit
          if (keypad != 4'b0000) begin
            input_password[2] <= keypad;
            state <= 3'b011;
          end
        end
        3'b011: begin // Wait for fourth password digit
          if (keypad != 4'b0000) begin
            input_password[3] <= keypad;
            state <= 3'b100;
          end
          end
      3'b100: begin // Wait for third password digit
          if (input_password[0] == p1 && input_password[1] == p2 && input_password[2] == p3 && input_password[3] == p4)
           begin
            buzzer <= 1'b0;
            seg <= 7'b0111110; // Display U on seven-segment display
            
            lock_state <= 1'b0; // Set lock state to unlocked
          end else begin
            lock_state <= 1'b1;
            buzzer <= 1'b1;
            seg <= 7'b0011000; 
            // Display L on seven-segment display 
           end 
    //     end
//        3'b100: begin
           input_password[0] <= 4'b0000;
           input_password[1] <= 4'b0000;
           input_password[2] <= 4'b0000;
           input_password[3] <= 4'b0000; 
           state <= 3'b000;  
           // Auto reset after four digits
         end 
      
     endcase
    
   // Assign lock state to output
   end
    lock <= lock_state; 
end  
endmodule
