//////////////////////////////////////////////////////////////////////
////                                                              ////
//// registerInterface.v                                          ////
////                                                              ////
//// This file is part of the i2cSlave opencores effort.
//// <http://www.opencores.org/cores//>                           ////
////                                                              ////
//// Module Description:                                          ////
//// You will need to modify this file to implement your 
//// interface.
//// Add your control and status bytes/bits to module inputs and outputs,
//// and also to the I2C read and write process blocks  
////                                                              ////
//// To Do:                                                       ////
//// 
////                                                              ////
//// Author(s):                                                   ////
//// - Steve Fielding, sfielding@base2designs.com                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2008 Steve Fielding and OPENCORES.ORG          ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE. See the GNU Lesser General Public License for more  ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from <http://www.opencores.org/lgpl.shtml>                   ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
`include "i2cSlave_define.vh"


module registerInterface #(
    parameter C_NUM_OUTPUT_REGS = 4,
    parameter C_NUM_INPUT_REGS = 4
) (
  input clk,
  input rst,
  input [7:0] addr,
  input [7:0] dataIn,
  input writeEn,
  output reg [7:0] dataOut,
  output i2c_data_t [C_NUM_OUTPUT_REGS-1:0] outputs,
  input  i2c_data_t [C_NUM_OUTPUT_REGS-1:0] defaults,
  input  i2c_data_t [C_NUM_INPUT_REGS-1:0]  inputs
);

i2c_data_t [C_NUM_OUTPUT_REGS-1:0] outputRegs;
assign outputs = outputRegs;

// --- I2C Read
always @(posedge clk) begin
  if (addr < C_NUM_OUTPUT_REGS) begin
    dataOut <= outputRegs[addr];
  end else if (addr < C_NUM_OUTPUT_REGS + C_NUM_INPUT_REGS) begin
    dataOut <= inputs[addr - C_NUM_OUTPUT_REGS];
  end else begin
    dataOut <= 8'h0;
  end
end

// --- I2C Write
always @(posedge clk) begin
  if (rst) begin
    outputRegs <= defaults;
  end else if (writeEn == 1'b1) begin
    if (addr < C_NUM_OUTPUT_REGS) begin
      outputRegs[addr] <= dataIn;
    end
  end
end

endmodule


 
