`timescale 1ns / 1ps
`include "iobuf_helper.svh"

module top(
    input cpu_clk,
    input soc_clk,
    input soc_aresetn,

    output              sdram_CLK,
    output     [12:0]   sdram_ADDR,
    output     [1:0]    sdram_BA,
    inout      [31:0]   sdram_DQ,
    output     [3:0]    sdram_DQM,
    output              sdram_CASn,
    output              sdram_CKE,
    output              sdram_CSn,
    output              sdram_RASn,
    output              sdram_WEn,
    
    output        SPI_CLK,
    output        SPI_CS,
    inout         SPI_MISO,
    inout         SPI_MOSI,
    
    inout         UART_RX,
    inout         UART_TX,
    
    input         rmii_ref_clk,
    output [1:0]  rmii_txd,
    output        rmii_tx_en,

    input  [1:0]  rmii_rxd,
    input         rmii_crs_rxdv,
    input         rmii_rx_err,
    
    output        MDC,
    inout         MDIO,
    output        phy_rstn,
    
    inout  [3:0]  SD_DAT,
    inout         SD_CMD,
    output        SD_CLK,
    
    input         ULPI_clk,
    inout  [7:0]  ULPI_data,
    output        ULPI_stp,
    input         ULPI_dir,
    input         ULPI_nxt,
    
    output          CDBUS_tx,
    output          CDBUS_tx_en,
    input           CDBUS_rx
);


// WARNING: en==0 means output, en==1 means input!!!
`IOBUF_GEN_SIMPLE(UART_TX)
`IOBUF_GEN_SIMPLE(UART_RX)
`IOBUF_GEN_SIMPLE(SPI_MISO)
`IOBUF_GEN_SIMPLE(SPI_MOSI)
`IOBUF_GEN_SIMPLE(MDIO)
`IOBUF_GEN_SIMPLE(SD_CMD)
`IOBUF_GEN_VEC_UNIFORM_SIMPLE(SD_DAT)
`IOBUF_GEN_VEC_SIMPLE(ULPI_data)
`IOBUF_GEN_VEC_SIMPLE(sdram_DQ)

wire [5:0]  mem_axi_awid;
wire [31:0] mem_axi_awaddr;
wire [7:0]  mem_axi_awlen;
wire [2:0]  mem_axi_awsize;
wire [1:0]  mem_axi_awburst;
wire        mem_axi_awvalid;
wire        mem_axi_awready;
wire [31:0] mem_axi_wdata;
wire [3:0]  mem_axi_wstrb;
wire        mem_axi_wlast;
wire        mem_axi_wvalid;
wire        mem_axi_wready;
wire        mem_axi_bready;
wire  [5:0] mem_axi_bid;
wire  [1:0] mem_axi_bresp;
wire        mem_axi_bvalid;
wire [5:0]  mem_axi_arid;
wire [31:0] mem_axi_araddr;
wire [7:0]  mem_axi_arlen;
wire [2:0]  mem_axi_arsize;
wire [1:0]  mem_axi_arburst;
wire        mem_axi_arvalid;
wire        mem_axi_arready;
wire        mem_axi_rready;
wire [5:0]  mem_axi_rid;
wire [31:0] mem_axi_rdata;
wire [1:0]  mem_axi_rresp;
wire        mem_axi_rlast;
wire        mem_axi_rvalid;

assign sdram_CLK = soc_clk;

wire [31:0] sdram_DQ_we;
assign sdram_DQ_t = ~sdram_DQ_we;
AxiSdramCtrl sdram (
  .clk(soc_clk),
  .reset(~soc_aresetn),

        .io_bus_aw_valid(mem_axi_awvalid),
        .io_bus_aw_ready(mem_axi_awready),
        .io_bus_aw_payload_addr(mem_axi_awaddr),
        .io_bus_aw_payload_id(mem_axi_awid),
        .io_bus_aw_payload_len(mem_axi_awlen),
        .io_bus_aw_payload_size(mem_axi_awsize),
        .io_bus_aw_payload_burst(mem_axi_awburst),
        .io_bus_w_valid(mem_axi_wvalid),
        .io_bus_w_ready(mem_axi_wready),
        .io_bus_w_payload_data(mem_axi_wdata),
        .io_bus_w_payload_strb(mem_axi_wstrb),
        .io_bus_w_payload_last(mem_axi_wlast),
        .io_bus_b_valid(mem_axi_bvalid),
        .io_bus_b_ready(mem_axi_bvalid ? mem_axi_bready : 1'b1),
        .io_bus_b_payload_id(mem_axi_bid),
        .io_bus_b_payload_resp(mem_axi_bresp),
        .io_bus_ar_valid(mem_axi_arvalid),
        .io_bus_ar_ready(mem_axi_arready),
        .io_bus_ar_payload_addr(mem_axi_araddr),
        .io_bus_ar_payload_id(mem_axi_arid),
        .io_bus_ar_payload_len(mem_axi_arlen),
        .io_bus_ar_payload_size(mem_axi_arsize),
        .io_bus_ar_payload_burst(mem_axi_arburst),
        .io_bus_r_valid(mem_axi_rvalid),
        .io_bus_r_ready(mem_axi_rvalid ? mem_axi_rready : 1'b1),
        .io_bus_r_payload_data(mem_axi_rdata),
        .io_bus_r_payload_id(mem_axi_rid),
        .io_bus_r_payload_resp(mem_axi_rresp),
        .io_bus_r_payload_last(mem_axi_rlast),

        .io_sdram_ADDR(sdram_ADDR),
        .io_sdram_BA(sdram_BA),
        .io_sdram_DQ_read(sdram_DQ_i),
        .io_sdram_DQ_write(sdram_DQ_o),
        .io_sdram_DQ_writeEnable(sdram_DQ_we),
        .io_sdram_DQM(sdram_DQM),
        .io_sdram_CASn(sdram_CASn),
        .io_sdram_CKE(sdram_CKE),
        .io_sdram_CSn(sdram_CSn),
        .io_sdram_RASn(sdram_RASn),
        .io_sdram_WEn(sdram_WEn)
);



wire [3:0] SPI_CS_M;
assign SPI_CS = SPI_CS_M[0];
soc_top #(
    .C_ASIC_SRAM(1)
) soc (
    .soc_clk(soc_clk),
    .cpu_clk(cpu_clk),
    .aresetn(soc_aresetn),
    
    .mem_axi_awid(mem_axi_awid),
    .mem_axi_awaddr(mem_axi_awaddr),
    .mem_axi_awlen(mem_axi_awlen),
    .mem_axi_awsize(mem_axi_awsize),
    .mem_axi_awburst(mem_axi_awburst),
    .mem_axi_awvalid(mem_axi_awvalid),
    .mem_axi_awready(mem_axi_awready),
    .mem_axi_wdata(mem_axi_wdata),
    .mem_axi_wstrb(mem_axi_wstrb),
    .mem_axi_wlast(mem_axi_wlast),
    .mem_axi_wvalid(mem_axi_wvalid),
    .mem_axi_wready(mem_axi_wready),
    .mem_axi_bready(mem_axi_bready),
    .mem_axi_bid(mem_axi_bid),
    .mem_axi_bresp(mem_axi_bresp),
    .mem_axi_bvalid(mem_axi_bvalid),
    .mem_axi_arid(mem_axi_arid),
    .mem_axi_araddr(mem_axi_araddr),
    .mem_axi_arlen(mem_axi_arlen),
    .mem_axi_arsize(mem_axi_arsize),
    .mem_axi_arburst(mem_axi_arburst),
    .mem_axi_arvalid(mem_axi_arvalid),
    .mem_axi_arready(mem_axi_arready),
    .mem_axi_rready(mem_axi_rready),
    .mem_axi_rid(mem_axi_rid),
    .mem_axi_rdata(mem_axi_rdata),
    .mem_axi_rresp(mem_axi_rresp),
    .mem_axi_rlast(mem_axi_rlast),
    .mem_axi_rvalid(mem_axi_rvalid),
    
    .csn_o(SPI_CS_M),
    .sck_o(SPI_CLK),
    .sdo_i(SPI_MOSI_i),
    .sdo_o(SPI_MOSI_o),
    .sdo_en(SPI_MOSI_t),  // Notice: en==0 means output, en==1 means input!
    .sdi_i(SPI_MISO_i),
    .sdi_o(SPI_MISO_o),
    .sdi_en(SPI_MISO_t),
    
    .uart_txd_i(UART_TX_i),
    .uart_txd_o(UART_TX_o),
    .uart_txd_en(UART_TX_t),
    .uart_rxd_i(UART_RX_i),
    .uart_rxd_o(UART_RX_o),
    .uart_rxd_en(UART_RX_t),
    
    .rmii_ref_clk (rmii_ref_clk   ),
    .rmii_txd     (rmii_txd       ),    
    .rmii_tx_en   (rmii_tx_en     ),   

    .rmii_rxd     (rmii_rxd       ),    
    .rmii_crs_rxdv(rmii_crs_rxdv  ),   
    .rmii_rx_err  (rmii_rx_err    ),  

    // MDIO
    .mdc_0        (MDC      ),
    .md_i_0       (MDIO_i   ),
    .md_o_0       (MDIO_o   ),       
    .md_t_0       (MDIO_t   ),
    .phy_rstn     (phy_rstn ),
    
    .sd_dat_i(SD_DAT_i),
    .sd_dat_o(SD_DAT_o),
    .sd_dat_t(SD_DAT_t),
    .sd_cmd_i(SD_CMD_i),
    .sd_cmd_o(SD_CMD_o),
    .sd_cmd_t(SD_CMD_t),
    .sd_clk  (SD_CLK  ),
    
    .ULPI_clk,
    .ULPI_data_i,
    .ULPI_data_o,
    .ULPI_data_t,
    .ULPI_stp,
    .ULPI_dir,
    .ULPI_nxt,
    
    .CDBUS_tx,
    .CDBUS_tx_en,
    .CDBUS_rx
);

endmodule

module IOBUF(input I, output O, inout IO, input T);
PB16 inst(.PAD(IO), .I(I), .C(O), .OEN(T));
endmodule

