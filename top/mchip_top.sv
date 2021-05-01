`timescale 1ns / 1ps
`include "iobuf_helper.svh"

module mchip_top (
    input clk_25m,                      // 25MHz 外部时钟输入
    input sys_rstn,                     // SoC 外部复位输入

    input ctrl_rstn,                    // 系统控制器外部复位输入
    inout i2c_sda,                      // 系统控制器 I2C 数据脚
    input i2c_scl,                      // 系统控制器 I2C 时钟脚

    output              sdram_CLK,      // SDRAM 时钟输出，等同于 SoC 时钟
    output     [12:0]   sdram_ADDR,     // 以下为 sdram 各路信号
    output     [1:0]    sdram_BA,
    inout      [31:0]   sdram_DQ,
    output     [3:0]    sdram_DQM,
    output              sdram_CASn,
    output              sdram_CKE,
    output              sdram_CSn,
    output              sdram_RASn,
    output              sdram_WEn,
    
    output        SPI_CLK,              // SPI 时钟，由 SoC 时钟分频得到
    output  [3:0] SPI_CS,               // SPI 片选信号
    inout         SPI_MISO,             // SPI 数据信号（1bit SPI: MISO，Dual SPI: IO1）
    inout         SPI_MOSI,             // SPI 数据信号（1bit SPI：MOSI，Dual SPI: IO2）
    
    inout         UART_RX,              // UART
    inout         UART_TX,
    
    input         rmii_ref_clk,         // 50MHz 以太网 RMII 参考时钟输入，由外部以太网 Phy 给出
    output [1:0]  rmii_txd,             // 以下 rmii 开头的信号均在 RMII 时钟域下
    output        rmii_tx_en,

    input  [1:0]  rmii_rxd,
    input         rmii_crs_rxdv,
    input         rmii_rx_err,
    
    output        MDC,                  // MDIO 时钟（RMII 管理总线），由 SoC 时钟分频得到
    inout         MDIO,                 // MDIO 数据
    
    inout  [3:0]  SD_DAT,               // SDIO 数据输入 / 输出
    inout         SD_CMD,               // SDIO 指令输入 / 输出
    output        SD_CLK,               // SDIO 时钟输出，由 SoC 时钟分频得到
    
    input         ULPI_clk,             // 60MHz USB ULPI 参考时钟，由外部 USB Phy 给出
    inout  [7:0]  ULPI_data,            // 以下 ULPI 开头的信号均在 ULPI 时钟域下
    output        ULPI_stp,
    input         ULPI_dir,
    input         ULPI_nxt,
    
    output          CDBUS_tx,           // CDBUS 总线信号，类似 UART 串口，属于 SoC 时钟域
    output          CDBUS_tx_en,
    input           CDBUS_rx,

    inout  [7:0] gpio,

    output [3:0] DBG_data,
    output       DBG_clk,

    inout i2cm_scl,
    inout i2cm_sda
);

wire soc_clk;
wire cpu_clk;
wire soc_aresetn;

wire [7:0]  CPU_PLL_MUL,
            CPU_PLL_DIV, 
            SOC_PLL_MUL, 
            SOC_PLL_DIV,
            PLL_CTRL,
            SPI_DIV_CTRL,
            DBG_CTRL,
            RESERVED;

wire [31:0] dat_ctrl_to_cfg,
            dat_cfg_to_ctrl;
wire [31:0] dat_ctrl_to_cfg_soc,
            dat_cfg_to_ctrl_soc;
wire [3:0]  spi_div_ctrl_soc;

wire CPU_PLL_OE = PLL_CTRL[0], CPU_PLL_BP = PLL_CTRL[1], SOC_PLL_OE = PLL_CTRL[2], SOC_PLL_BP = PLL_CTRL[3], CTRL_SYS_RSTN = PLL_CTRL[4], CTRL_INTR = PLL_CTRL[5];

`IPAD_GEN_SIMPLE(clk_25m)
`IPAD_GEN_SIMPLE(sys_rstn)
`IPAD_GEN_SIMPLE(ctrl_rstn)
stolen_cdc_sync_rst soc_rstgen(
    .dest_clk(soc_clk),
    .dest_rst(soc_aresetn),
    .src_rst(sys_rstn_c || CTRL_SYS_RSTN)
);

// WARNING: en==0 means output, en==1 means input!!!
`IOBUF_GEN_SIMPLE(UART_TX)
`IOBUF_GEN_SIMPLE(UART_RX)
`IOBUF_GEN_VEC_SIMPLE(gpio)

`IOBUF_GEN_SIMPLE(i2c_sda)
`IPAD_GEN_SIMPLE(i2c_scl)

`OPAD_GEN_SIMPLE(sdram_CLK)
`OPAD_GEN_VEC_SIMPLE(sdram_ADDR)
`OPAD_GEN_VEC_SIMPLE(sdram_BA)
`OPAD_GEN_VEC_SIMPLE(sdram_DQM)
`IOBUF_GEN_VEC_SIMPLE(sdram_DQ)
`OPAD_GEN_SIMPLE(sdram_CASn)
`OPAD_GEN_SIMPLE(sdram_CKE)
`OPAD_GEN_SIMPLE(sdram_CSn)
`OPAD_GEN_SIMPLE(sdram_RASn)
`OPAD_GEN_SIMPLE(sdram_WEn)

`OPAD_GEN_SIMPLE(SPI_CLK)
`OPAD_GEN_VEC_SIMPLE(SPI_CS)
`IOBUF_GEN_SIMPLE(SPI_MISO)
`IOBUF_GEN_SIMPLE(SPI_MOSI)

`IPAD_GEN_SIMPLE(rmii_ref_clk)
`OPAD_GEN_VEC_SIMPLE(rmii_txd)
`OPAD_GEN_SIMPLE(rmii_tx_en)

`IPAD_GEN_VEC_SIMPLE(rmii_rxd)
`IPAD_GEN_SIMPLE(rmii_crs_rxdv)
`IPAD_GEN_SIMPLE(rmii_rx_err)

`OPAD_GEN_SIMPLE(MDC)
`IOBUF_GEN_SIMPLE(MDIO)

`OPAD_GEN_SIMPLE(SD_CLK)
`IOBUF_GEN_SIMPLE(SD_CMD)
`IOBUF_GEN_VEC_UNIFORM_SIMPLE(SD_DAT)

`IPAD_GEN_SIMPLE(ULPI_clk)
`IOBUF_GEN_VEC_SIMPLE(ULPI_data)
`OPAD_GEN_SIMPLE(ULPI_stp)
`IPAD_GEN_SIMPLE(ULPI_dir)
`IPAD_GEN_SIMPLE(ULPI_nxt)

`OPAD_GEN_SIMPLE(CDBUS_tx)
`OPAD_GEN_SIMPLE(CDBUS_tx_en)
`IPAD_GEN_SIMPLE(CDBUS_rx)

`OPAD_GEN_T_SIMPLE(DBG_clk)
`OPAD_GEN_VEC_T_UNIFORM_SIMPLE(DBG_data)

`IOBUF_GEN_SIMPLE(i2cm_scl)
`IOBUF_GEN_SIMPLE(i2cm_sda)

assign i2c_sda_t = i2c_sda_o;

wire i2c_rstn;
stolen_cdc_sync_rst ctrl_rstgen(
    .dest_clk(clk_25m_c),
    .dest_rst(i2c_rstn),
    .src_rst(ctrl_rstn_c)
);

i2cSlave #(
    .C_NUM_OUTPUT_REGS(12),
    .C_NUM_INPUT_REGS(4)
) i2c_ctrl (
  .clk     (clk_25m_c     ),
  .rst     (~i2c_rstn     ),
  .scl     (i2c_scl_c     ),
  .sdaIn   (i2c_sda_i     ),
  .sdaOut  (i2c_sda_o     ),
  .outputs ({dat_ctrl_to_cfg[31:24], dat_ctrl_to_cfg[23:16], dat_ctrl_to_cfg[15:8], dat_ctrl_to_cfg[7:0], 
             RESERVED, DBG_CTRL, SPI_DIV_CTRL, PLL_CTRL, SOC_PLL_DIV  , SOC_PLL_MUL, CPU_PLL_DIV  , CPU_PLL_MUL}),
  .defaults({8'b0,                   8'b0,                   8'b0,                  8'b0,
             8'b0    , 8'b101  , 8'b0100     , 8'b0    , {3'd1, 5'd1} , 8'd30      , {3'd1, 5'd2}, 8'd46       }),
  .inputs  ({dat_cfg_to_ctrl[31:24], dat_cfg_to_ctrl[23:16], dat_cfg_to_ctrl[15:8], dat_cfg_to_ctrl[7:0]       })
);


S018PLLGS_LC CPU_PLL(
  .XIN(clk_25m_c),
  .CLK_OUT(cpu_clk),
  .N(CPU_PLL_DIV[4:0]),
  .M({1'b0, CPU_PLL_MUL}),
  .PLL_TST(2'b0),
  .RESET(1'b0),
  .PD(1'b0),
  .OD({1'b0, CPU_PLL_DIV[7:5]}),
  .BP(CPU_PLL_BP),
  .OE(CPU_PLL_OE)
);

S018PLLGS_LC SOC_PLL(
  .XIN(clk_25m_c),
  .CLK_OUT(soc_clk),
  .N(SOC_PLL_DIV[4:0]),
  .M({1'b0, SOC_PLL_MUL}),
  .PLL_TST(2'b0),
  .RESET(1'b0),
  .PD(1'b0),
  .OD({1'b0, SOC_PLL_DIV[7:5]}),
  .BP(SOC_PLL_BP),
  .OE(SOC_PLL_OE)
);

stolen_cdc_array_single #(2, 1, 32) dat_ctrl_to_cfg_sync (
   .src_clk(clk_25m_c),
   .src_in(dat_ctrl_to_cfg),
   .dest_clk(soc_clk),
   .dest_out(dat_ctrl_to_cfg_soc)
);

stolen_cdc_array_single #(2, 1, 32) dat_cfg_to_ctrl_sync (
   .src_clk(soc_clk),
   .src_in(dat_cfg_to_ctrl_soc),
   .dest_clk(clk_25m_c),
   .dest_out(dat_cfg_to_ctrl)
);

stolen_cdc_array_single #(2, 1, 4) spi_div_ctrl_sync (
   .src_clk(clk_25m_c),
   .src_in(SPI_DIV_CTRL[3:0]),
   .dest_clk(soc_clk),
   .dest_out(spi_div_ctrl_soc)
);

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

assign sdram_CLK_c = soc_clk;

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

        .io_sdram_ADDR(sdram_ADDR_c),
        .io_sdram_BA(sdram_BA_c),
        .io_sdram_DQ_read(sdram_DQ_i),
        .io_sdram_DQ_write(sdram_DQ_o),
        .io_sdram_DQ_writeEnable(sdram_DQ_we),
        .io_sdram_DQM(sdram_DQM_c),
        .io_sdram_CASn(sdram_CASn_c),
        .io_sdram_CKE(sdram_CKE_c),
        .io_sdram_CSn(sdram_CSn_c),
        .io_sdram_RASn(sdram_RASn_c),
        .io_sdram_WEn(sdram_WEn_c)
);

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
    
    .csn_o(SPI_CS_c),
    .sck_o(SPI_CLK_c),
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
    
    .rmii_ref_clk (rmii_ref_clk_c ),
    .rmii_txd     (rmii_txd_c     ),    
    .rmii_tx_en   (rmii_tx_en_c   ),   

    .rmii_rxd     (rmii_rxd_c     ),    
    .rmii_crs_rxdv(rmii_crs_rxdv_c),   
    .rmii_rx_err  (rmii_rx_err_c  ),  

    // MDIO
    .mdc_0        (MDC_c    ),
    .md_i_0       (MDIO_i   ),
    .md_o_0       (MDIO_o   ),       
    .md_t_0       (MDIO_t   ),
    
    .sd_dat_i(SD_DAT_i),
    .sd_dat_o(SD_DAT_o),
    .sd_dat_t(SD_DAT_t),
    .sd_cmd_i(SD_CMD_i),
    .sd_cmd_o(SD_CMD_o),
    .sd_cmd_t(SD_CMD_t),
    .sd_clk  (SD_CLK_c),
    
    .ULPI_clk(ULPI_clk_c),
    .ULPI_data_i,
    .ULPI_data_o,
    .ULPI_data_t,
    .ULPI_stp(ULPI_stp_c),
    .ULPI_dir(ULPI_dir_c),
    .ULPI_nxt(ULPI_nxt_c),
    
    .CDBUS_tx(CDBUS_tx_c),
    .CDBUS_tx_en(CDBUS_tx_en_c),
    .CDBUS_rx(CDBUS_rx_c),

    .dat_cfg_to_ctrl(dat_cfg_to_ctrl_soc),
    .dat_ctrl_to_cfg(dat_ctrl_to_cfg_soc),
    .gpio_o(gpio_o),
    .gpio_i(gpio_i),
    .gpio_t(gpio_t),
    .spi_div_ctrl(spi_div_ctrl_soc),
    .intr_ctrl(CTRL_INTR),

    .debug_output_data(DBG_data_c),
    .debug_output_mode(DBG_CTRL[1:0]),

    .i2cm_scl_i,
	  .i2cm_scl_o,
	  .i2cm_scl_t, 

	  .i2cm_sda_i,
	  .i2cm_sda_o,
	  .i2cm_sda_t
);

assign DBG_data_t = ~DBG_CTRL[2];
assign DBG_clk_t = ~DBG_CTRL[2];
assign DBG_clk_c = cpu_clk;

endmodule

module IOBUF(input I, output O, inout IO, input T);
PB16 inst(.PAD(IO), .I(I), .C(O), .OEN(T));
endmodule

