/*------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Copyright (c) 2016, Loongson Technology Corporation Limited.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this 
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

3. Neither the name of Loongson Technology Corporation Limited nor the names of 
its contributors may be used to endorse or promote products derived from this 
software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL LOONGSON TECHNOLOGY CORPORATION LIMITED BE LIABLE
TO ANY PARTY FOR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--------------------------------------------------------------------------------
------------------------------------------------------------------------------*/

`timescale 1ns/10ps

`define V_UART_FIFO_COUNTER_W    5
`define V_UART_FIFO_WIDTH        8
`define V_UART_LC_PE             3
`define V_UART_LC_EP             4
`define V_UART_LC_SP             5
`define V_UART_LC_SB             2
`define V_UART_LC_BITS           1:0
`define V_UART_LC_BC             6
`define V_UART_FIFO_DEPTH        16
`define V_UART_FIFO_POINTER_W    4

module uart_dev
(
    input  wire        clk,
    input  wire        rx
);
parameter     uart_number=0;
parameter     STRLEN = 80;

    wire        gpio;

    assign data    = 8'h0;
    assign hwrite  = 1'b0;
    assign hready  = 1'b0;
    assign htrans  = 2'b0;
    assign haddr   = 32'h0;
    assign hclk    = clk;
    assign apb_clk = clk;
    assign gpio    = 1'b1;


   reg [7:0]     buffer[STRLEN:0];
   wire [8*STRLEN-1:0] outbuf;

   reg [7:0]     byte_in;
   reg [7:0]     ptr;
   integer       i;
   reg last_is_0d = 0;
   initial
   begin
      while(rx !== 1'b1) @(rx);
      forever begin
        byte_in = 8'h20;
        while(rx != 1'b0) @(rx);
        repeat(7) @(posedge clk);
        for ( i=0; i<8; i=i+1 ) begin
           repeat(13) @(posedge clk);
           byte_in[i] = rx;
        end
        repeat(13) @(posedge clk);
        if (!(byte_in == 8'h0a && last_is_0d)) 
            push(byte_in);
        last_is_0d = byte_in == 8'h0d;
      end
   end

   initial #100
     begin:init_buffer
        for (ptr = 8'h00; ptr < STRLEN; ptr = ptr + 1)
          begin
             buffer[ptr] = 8'h20;
          end
        ptr = 8'h00;
     end

   assign outbuf[639:0] = { buffer[0], buffer[1], buffer[2], buffer[3], buffer[4], buffer[5], buffer[6], buffer[7],
                            buffer[8], buffer[9], buffer[10],buffer[11],buffer[12],buffer[13],buffer[14],buffer[15],
                            buffer[16],buffer[17],buffer[18],buffer[19],buffer[20],buffer[21],buffer[22],buffer[23],
                            buffer[24],buffer[25],buffer[26],buffer[27],buffer[28],buffer[29],buffer[30],buffer[31],
                            buffer[32],buffer[33],buffer[34],buffer[35],buffer[36],buffer[37],buffer[38],buffer[39],
                            buffer[40],buffer[41],buffer[42],buffer[43],buffer[44],buffer[45],buffer[46],buffer[47],
                            buffer[48],buffer[49],buffer[50],buffer[51],buffer[52],buffer[53],buffer[54],buffer[55],
                            buffer[56],buffer[57],buffer[58],buffer[59],buffer[60],buffer[61],buffer[62],buffer[63],
                            buffer[64],buffer[65],buffer[66],buffer[67],buffer[68],buffer[69],buffer[70],buffer[71],
                            buffer[72],buffer[73],buffer[74],buffer[75],buffer[76],buffer[77],buffer[78],buffer[79]};

   
   task push;
      input [7:0] data;
      begin
      buffer[ptr] = (data[7:0]==8'h0D)? 8'h0A : data[7:0];
      ptr = ptr + 1;
      if (data[7:0] == 8'h0A || data[7:0] == 8'h0D)
        begin
           print;
           ptr = 8'h00;
        end
      else if (ptr == STRLEN)
        begin
           print;
           ptr = 8'h00;
        end
      end
   endtask

   task print;
      begin
         $display("[%t]:[uart%1x]: %s", $time, uart_number,outbuf);
         if (outbuf[639:576] == "GouSheng") $finish;
         for (ptr =  8'h00; ptr < STRLEN; ptr = ptr + 1)
           begin
              buffer[ptr] = 8'h20;
           end
      end
   endtask


endmodule 

