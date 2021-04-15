`timescale 1ns / 1ns

module tb_test();

reg soc_clk, cpu_clk, aresetn;

    wire sdram_CLK;
    wire [12:0]   sdram_ADDR;
    wire [1:0]    sdram_BA;
    wire [31:0]   sdram_DQ;
    wire [3:0]    sdram_DQM;
    wire sdram_CASn;
    wire sdram_CKE;
    wire sdram_CSn;
    wire sdram_RASn;
    wire sdram_WEn;

sdr sdram1(.Dq(sdram_DQ[15:0]), .Addr(sdram_ADDR), .Ba(sdram_BA), .Clk(sdram_CLK), .Cke(sdram_CKE), .Cs_n(sdram_CSn), .Ras_n(sdram_RASn), .Cas_n(sdram_CASn), .We_n(sdram_WEn), .Dqm(sdram_DQM[1:0]));
sdr sdram2(.Dq(sdram_DQ[31:16]), .Addr(sdram_ADDR), .Ba(sdram_BA), .Clk(sdram_CLK), .Cke(sdram_CKE), .Cs_n(sdram_CSn), .Ras_n(sdram_RASn), .Cas_n(sdram_CASn), .We_n(sdram_WEn), .Dqm(sdram_DQM[3:2]));

wire SPI_CLK, SPI_MISO, SPI_MOSI;
wire [3:0] SPI_CS;

// tri1: pull up
tri1 [3:0] SD_DAT;
tri1 SD_CMD;
wire SD_CLK;

reg rmii_clk, ulpi_clk;
always #3.333 cpu_clk = ~cpu_clk;
always #5 soc_clk = ~soc_clk;
always #10 rmii_clk = ~rmii_clk;
always #8.333 ulpi_clk = ~ulpi_clk;
initial begin
aresetn = 0;
    cpu_clk = 0;
#0.123;
soc_clk = 0;
    #1.2;
    rmii_clk = 0;
    #0.573;
    ulpi_clk = 0;
#50;
	aresetn = 1;
end
    

top dut(
    .cpu_clk(cpu_clk),
    .soc_clk(soc_clk),
    .soc_aresetn(aresetn),

    .SPI_CLK(SPI_CLK),
    .SPI_CS(SPI_CS),
    .SPI_MISO(SPI_MISO),
    .SPI_MOSI(SPI_MOSI),
    
    .SD_DAT(SD_DAT),
    .SD_CMD(SD_CMD),
    .SD_CLK(SD_CLK),
    
    .UART_TX(UART_TX),
    
    .ULPI_clk(ulpi_clk),
    .rmii_ref_clk(rmii_clk),

.sdram_CLK(sdram_CLK),
.sdram_ADDR(sdram_ADDR),
.sdram_BA(sdram_BA),
.sdram_DQ(sdram_DQ),
.sdram_DQM(sdram_DQM),
.sdram_CASn(sdram_CASn),
.sdram_CKE(sdram_CKE),
.sdram_CSn(sdram_CSn),
.sdram_RASn(sdram_RASn),
.sdram_WEn(sdram_WEn)

);


uart_dev #
    (
    .uart_number    (0),
    .STRLEN         (80)
    ) 
    uart_dev0
    (
    .clk    (dut.soc.APB_DEV.uart0.regs.enable),
    .rx     (UART_TX)
);


MX25L6405D #(
    .Init_File("./spi.mif")
) spi_flash (
    .SCLK (SPI_CLK  ),
    .CS   (SPI_CS[0]),
    .SI   (SPI_MOSI ),
    .SO   (SPI_MISO ),
    .WP   (1'b1     ), 
    .HOLD (1'b1     )
);

sdModel #(
   .log_file("/tmp/sdlog.txt"),
   .ramdisk("./sd.mif")
) sdcard (
  .sdClk(SD_CLK),
  .cmd(SD_CMD),
  .dat(SD_DAT)
);

initial begin
   $fsdbDumpfile("s2.fsdb");
   $fsdbDumpvars();
   #6000000;
   $finish;
end

endmodule
