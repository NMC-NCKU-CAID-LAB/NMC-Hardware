
`timescale 1 ns / 1 ps

	module Unet2DDR_v2_0 #
	(
	  // Parameters of Axi Master Bus Interface M00_AXI
		// <-----------------Parameters for Base_address-----------------> 		
		// parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h4580_0000,
		// parameter integer C_M00_AXI_BURST_LEN	= 16,
		// parameter integer C_M00_AXI_ID_WIDTH	= 1,
		// parameter integer C_M00_AXI_ADDR_WIDTH	= 32,
		// parameter integer C_M00_AXI_DATA_WIDTH	= 32,
		// parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		// parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		// parameter integer C_M00_AXI_WUSER_WIDTH	= 0,
		// parameter integer C_M00_AXI_RUSER_WIDTH	= 0,
		// parameter integer C_M00_AXI_BUSER_WIDTH	= 0,

	  //all Port use
		parameter FLASH_CHANNEL		= 3'd0,

	  // Parameters of Axi Master Bus Interface M01_AXI
		//user
		parameter  C_M01_BRAM_BASE_ADDR	=	32'h5000_0000,
		//
		parameter  C_M01_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h43c0_3000,
		parameter integer C_M01_AXI_BURST_LEN	= 16,
		parameter integer C_M01_AXI_ID_WIDTH	= 1,
		parameter integer C_M01_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M01_AXI_DATA_WIDTH	= 32,
		parameter integer C_M01_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M01_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M01_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M01_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M01_AXI_BUSER_WIDTH	= 0,

	  // Parameters of Axi Master Bus Interface M02_AXI
		parameter  C_M02_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h1700_0000,
		parameter integer C_M02_AXI_BURST_LEN	= 8,
		parameter integer C_M02_AXI_ID_WIDTH	= 1,
		parameter integer C_M02_AXI_ADDR_WIDTH	= 32,
		parameter integer C_M02_AXI_DATA_WIDTH	= 32,
		parameter integer C_M02_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_WUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_RUSER_WIDTH	= 0,
		parameter integer C_M02_AXI_BUSER_WIDTH	= 0,

		// Parameters of BRAM Bus Interface
		parameter  BRAM_BASEADDRESS_START_ADDR	= 32'h4580_0000,
		// Parameters of CWBP_Decoder
		parameter integer C_CWBP_DATA_WIDTH		= 32		
	)
	(
	// Ports of Unet 
		input				UW_busy,
		input				U_L0_Finish,
		input	[7:0]		check_nfc_busy,

		output	wire		UW_ready,
		output	wire		UW_module_Finish, // Water S
		output  wire		UW_Busy_for_WS,   // Water S
		output	wire		patch_num,
	// Ports of Axi Master Bus Interface M01_AXI
		// input wire  m01_axi_init_axi_txn,
		// output wire  m01_axi_txn_done,
		// output wire  m01_axi_error,
		input wire  m01_axi_aclk,
		input wire  m01_axi_aresetn,
		output wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_awid,
		output wire [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_awaddr,
		output wire [7 : 0] m01_axi_awlen,
		output wire [2 : 0] m01_axi_awsize,
		output wire [1 : 0] m01_axi_awburst,
		output wire  m01_axi_awlock,
		output wire [3 : 0] m01_axi_awcache,
		output wire [2 : 0] m01_axi_awprot,
		output wire [3 : 0] m01_axi_awqos,
		output wire [C_M01_AXI_AWUSER_WIDTH-1 : 0] m01_axi_awuser,
		output wire  m01_axi_awvalid,
		input wire  m01_axi_awready,
		output wire [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_wdata,
		output wire [C_M01_AXI_DATA_WIDTH/8-1 : 0] m01_axi_wstrb,
		output wire  m01_axi_wlast,
		output wire [C_M01_AXI_WUSER_WIDTH-1 : 0] m01_axi_wuser,
		output wire  m01_axi_wvalid,
		input wire  m01_axi_wready,
		input wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_bid,
		input wire [1 : 0] m01_axi_bresp,
		input wire [C_M01_AXI_BUSER_WIDTH-1 : 0] m01_axi_buser,
		input wire  m01_axi_bvalid,
		output wire  m01_axi_bready,
		output wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_arid,
		output wire [C_M01_AXI_ADDR_WIDTH-1 : 0] m01_axi_araddr,
		output wire [7 : 0] m01_axi_arlen,
		output wire [2 : 0] m01_axi_arsize,
		output wire [1 : 0] m01_axi_arburst,
		output wire  m01_axi_arlock,
		output wire [3 : 0] m01_axi_arcache,
		output wire [2 : 0] m01_axi_arprot,
		output wire [3 : 0] m01_axi_arqos,
		output wire [C_M01_AXI_ARUSER_WIDTH-1 : 0] m01_axi_aruser,
		output wire  m01_axi_arvalid,
		input wire  m01_axi_arready,
		input wire [C_M01_AXI_ID_WIDTH-1 : 0] m01_axi_rid,
		input wire [C_M01_AXI_DATA_WIDTH-1 : 0] m01_axi_rdata,
		input wire [1 : 0] m01_axi_rresp,
		input wire  m01_axi_rlast,
		input wire [C_M01_AXI_RUSER_WIDTH-1 : 0] m01_axi_ruser,
		input wire  m01_axi_rvalid,
		output wire  m01_axi_rready,

	//Ports of Axi Master Bus Interface M02_AXI
		//input wire  m02_axi_init_axi_txn,
		output wire  m02_axi_txn_done,
		output wire  m02_axi_error,
		input wire  m02_axi_aclk,
		input wire  m02_axi_aresetn,
		output wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_awid,
		output wire [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_awaddr,
		output wire [7 : 0] m02_axi_awlen,
		output wire [2 : 0] m02_axi_awsize,
		output wire [1 : 0] m02_axi_awburst,
		output wire  m02_axi_awlock,
		output wire [3 : 0] m02_axi_awcache,
		output wire [2 : 0] m02_axi_awprot,
		output wire [3 : 0] m02_axi_awqos,
		output wire [C_M02_AXI_AWUSER_WIDTH-1 : 0] m02_axi_awuser,
		output wire  m02_axi_awvalid,
		input wire  m02_axi_awready,
		output wire [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_wdata,
		output wire [C_M02_AXI_DATA_WIDTH/8-1 : 0] m02_axi_wstrb,
		output wire  m02_axi_wlast,
		output wire [C_M02_AXI_WUSER_WIDTH-1 : 0] m02_axi_wuser,
		output wire  m02_axi_wvalid,
		input wire  m02_axi_wready,
		input wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_bid,
		input wire [1 : 0] m02_axi_bresp,
		input wire [C_M02_AXI_BUSER_WIDTH-1 : 0] m02_axi_buser,
		input wire  m02_axi_bvalid,
		output wire  m02_axi_bready,
		output wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_arid,
		output wire [C_M02_AXI_ADDR_WIDTH-1 : 0] m02_axi_araddr,
		output wire [7 : 0] m02_axi_arlen,
		output wire [2 : 0] m02_axi_arsize,
		output wire [1 : 0] m02_axi_arburst,
		output wire  m02_axi_arlock,
		output wire [3 : 0] m02_axi_arcache,
		output wire [2 : 0] m02_axi_arprot,
		output wire [3 : 0] m02_axi_arqos,
		output wire [C_M02_AXI_ARUSER_WIDTH-1 : 0] m02_axi_aruser,
		output wire  m02_axi_arvalid,
		input wire  m02_axi_arready,
		input wire [C_M02_AXI_ID_WIDTH-1 : 0] m02_axi_rid,
		input wire [C_M02_AXI_DATA_WIDTH-1 : 0] m02_axi_rdata,
		input wire [1 : 0] m02_axi_rresp,
		input wire  m02_axi_rlast,
		input wire [C_M02_AXI_RUSER_WIDTH-1 : 0] m02_axi_ruser,
		input wire  m02_axi_rvalid,
		output wire  m02_axi_rready,

	//base_address
		input wire base_address_rd_clk,
		input wire base_address_rd_rst_n,

		output wire ram_clk,
		output wire ram_rst,

		output wire [31:0]ram_addr,

		output wire ram_en,
		input  wire [31:0] ram_rd_data,

		output	wire [3:0] ram_we,
		output	wire [31:0] ram_wd_data
	);

	// Interal wire/reg
	wire m01_start_flag;
	wire m01_02_state_flag;
	
	wire [3:0] Way;
	wire [C_CWBP_DATA_WIDTH -1 :0] Row_address;

	wire w_change_based_address;

	//wire		UW_busy;
	wire		UW_finish;	
	wire		UW_wait;
	//for Water S
	wire 			m01_UW_Finish;
	reg 	[1:0]	UW_count;
	// Interal wire/reg end

// Instantiation of Axi Bus Interface M00_AXI
	// Unet2DDR_v2_0_M00_AXI # ( 
	// 	.C_M_TARGET_SLAVE_BASE_ADDR(C_M00_AXI_TARGET_SLAVE_BASE_ADDR),
	// 	.C_M_AXI_BURST_LEN(C_M00_AXI_BURST_LEN),
	// 	.C_M_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
	// 	.C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
	// 	.C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
	// 	.C_M_AXI_AWUSER_WIDTH(C_M00_AXI_AWUSER_WIDTH),
	// 	.C_M_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
	// 	.C_M_AXI_WUSER_WIDTH(C_M00_AXI_WUSER_WIDTH),
	// 	.C_M_AXI_RUSER_WIDTH(C_M00_AXI_RUSER_WIDTH),
	// 	.C_M_AXI_BUSER_WIDTH(C_M00_AXI_BUSER_WIDTH)
	// ) Unet2DDR_v2_0_M00_AXI_inst (
	// // .INIT_AXI_TXN(m00_axi_init_axi_txn),
	// // .TXN_DONE(m00_axi_txn_done),
	// // .ERROR(m00_axi_error),
	// 	//user port
	// 	.state_finish_flag(m00_01_state_flag),
	// 	.choose_channel(choose_channel),
	// 	//u8ser end
	// 	.M_AXI_ACLK(m00_axi_aclk),
	// 	.M_AXI_ARESETN(m00_axi_aresetn),
	// 	.M_AXI_AWID(m00_axi_awid),
	// 	.M_AXI_AWADDR(m00_axi_awaddr),
	// 	.M_AXI_AWLEN(m00_axi_awlen),
	// 	.M_AXI_AWSIZE(m00_axi_awsize),
	// 	.M_AXI_AWBURST(m00_axi_awburst),
	// 	.M_AXI_AWLOCK(m00_axi_awlock),
	// 	.M_AXI_AWCACHE(m00_axi_awcache),
	// 	.M_AXI_AWPROT(m00_axi_awprot),
	// 	.M_AXI_AWQOS(m00_axi_awqos),
	// 	.M_AXI_AWUSER(m00_axi_awuser),
	// 	.M_AXI_AWVALID(m00_axi_awvalid),
	// 	.M_AXI_AWREADY(m00_axi_awready),
	// 	.M_AXI_WDATA(m00_axi_wdata),
	// 	.M_AXI_WSTRB(m00_axi_wstrb),
	// 	.M_AXI_WLAST(m00_axi_wlast),
	// 	.M_AXI_WUSER(m00_axi_wuser),
	// 	.M_AXI_WVALID(m00_axi_wvalid),
	// 	.M_AXI_WREADY(m00_axi_wready),
	// 	.M_AXI_BID(m00_axi_bid),
	// 	.M_AXI_BRESP(m00_axi_bresp),
	// 	.M_AXI_BUSER(m00_axi_buser),
	// 	.M_AXI_BVALID(m00_axi_bvalid),
	// 	.M_AXI_BREADY(m00_axi_bready),
	// 	.M_AXI_ARID(m00_axi_arid),
	// 	.M_AXI_ARADDR(m00_axi_araddr),
	// 	.M_AXI_ARLEN(m00_axi_arlen),
	// 	.M_AXI_ARSIZE(m00_axi_arsize),
	// 	.M_AXI_ARBURST(m00_axi_arburst),
	// 	.M_AXI_ARLOCK(m00_axi_arlock),
	// 	.M_AXI_ARCACHE(m00_axi_arcache),
	// 	.M_AXI_ARPROT(m00_axi_arprot),
	// 	.M_AXI_ARQOS(m00_axi_arqos),
	// 	.M_AXI_ARUSER(m00_axi_aruser),
	// 	.M_AXI_ARVALID(m00_axi_arvalid),
	// 	.M_AXI_ARREADY(m00_axi_arready),
	// 	.M_AXI_RID(m00_axi_rid),
	// 	.M_AXI_RDATA(m00_axi_rdata),
	// 	.M_AXI_RRESP(m00_axi_rresp),
	// 	.M_AXI_RLAST(m00_axi_rlast),
	// 	.M_AXI_RUSER(m00_axi_ruser),
	// 	.M_AXI_RVALID(m00_axi_rvalid),
	// 	.M_AXI_RREADY(m00_axi_rready)
	// );

// Instantiation of Axi Bus Interface M01_AXI
	Unet2DDR_v2_0_M01_AXI # (
		.C_M_FLASH_CHANNEL(FLASH_CHANNEL),
		.C_M_BRAM_BASE_ADDR(C_M01_BRAM_BASE_ADDR),
		.C_M_TARGET_SLAVE_BASE_ADDR(C_M01_AXI_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_BURST_LEN(C_M01_AXI_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_M01_AXI_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M01_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M01_AXI_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_M01_AXI_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_M01_AXI_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_M01_AXI_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_M01_AXI_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_M01_AXI_BUSER_WIDTH)
	) Unet2DDR_v2_0_M01_AXI_inst (
		// Users to add ports here
		.check_nfc_busy(check_nfc_busy),
		.check_M02_state_flag(m01_02_state_flag),

		.Way		(Way),
		.Row_address(Row_address),
		
		.UW_count	(UW_count),
		.UW_Finish	(m01_UW_Finish),

		.UW_Busy  (UW_Busy_for_WS),
		.change_based_address (w_change_based_address),
		// User ports ends
		.INIT_AXI_TXN(m01_start_flag),
		// .TXN_DONE(m01_axi_txn_done),
		// .ERROR(m01_axi_error),
		.M_AXI_ACLK(m01_axi_aclk),
		.M_AXI_ARESETN(m01_axi_aresetn),
		.M_AXI_AWID(m01_axi_awid),
		.M_AXI_AWADDR(m01_axi_awaddr),
		.M_AXI_AWLEN(m01_axi_awlen),
		.M_AXI_AWSIZE(m01_axi_awsize),
		.M_AXI_AWBURST(m01_axi_awburst),
		.M_AXI_AWLOCK(m01_axi_awlock),
		.M_AXI_AWCACHE(m01_axi_awcache),
		.M_AXI_AWPROT(m01_axi_awprot),
		.M_AXI_AWQOS(m01_axi_awqos),
		.M_AXI_AWUSER(m01_axi_awuser),
		.M_AXI_AWVALID(m01_axi_awvalid),
		.M_AXI_AWREADY(m01_axi_awready),
		.M_AXI_WDATA(m01_axi_wdata),
		.M_AXI_WSTRB(m01_axi_wstrb),
		.M_AXI_WLAST(m01_axi_wlast),
		.M_AXI_WUSER(m01_axi_wuser),
		.M_AXI_WVALID(m01_axi_wvalid),
		.M_AXI_WREADY(m01_axi_wready),
		.M_AXI_BID(m01_axi_bid),
		.M_AXI_BRESP(m01_axi_bresp),
		.M_AXI_BUSER(m01_axi_buser),
		.M_AXI_BVALID(m01_axi_bvalid),
		.M_AXI_BREADY(m01_axi_bready),
		.M_AXI_ARID(m01_axi_arid),
		.M_AXI_ARADDR(m01_axi_araddr),
		.M_AXI_ARLEN(m01_axi_arlen),
		.M_AXI_ARSIZE(m01_axi_arsize),
		.M_AXI_ARBURST(m01_axi_arburst),
		.M_AXI_ARLOCK(m01_axi_arlock),
		.M_AXI_ARCACHE(m01_axi_arcache),
		.M_AXI_ARPROT(m01_axi_arprot),
		.M_AXI_ARQOS(m01_axi_arqos),
		.M_AXI_ARUSER(m01_axi_aruser),
		.M_AXI_ARVALID(m01_axi_arvalid),
		.M_AXI_ARREADY(m01_axi_arready),
		.M_AXI_RID(m01_axi_rid),
		.M_AXI_RDATA(m01_axi_rdata),
		.M_AXI_RRESP(m01_axi_rresp),
		.M_AXI_RLAST(m01_axi_rlast),
		.M_AXI_RUSER(m01_axi_ruser),
		.M_AXI_RVALID(m01_axi_rvalid),
		.M_AXI_RREADY(m01_axi_rready)
	);

// Instantiation of Axi Bus Interface M02_AXI
	Unet2DDR_v2_0_M02_AXI # ( 
		.C_M_TARGET_SLAVE_BASE_ADDR(C_M02_AXI_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_BURST_LEN(C_M02_AXI_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_M02_AXI_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M02_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M02_AXI_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_M02_AXI_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_M02_AXI_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_M02_AXI_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_M02_AXI_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_M02_AXI_BUSER_WIDTH)
	) Unet2DDR_v2_0_M02_AXI_inst (
	  //user port		
		//.WS_ALL_Done(U_L0_Finish),
	  // original	
		.INIT_AXI_TXN(U_L0_Finish),
	  // .TXN_DONE(m02_axi_txn_done),
	  // .ERROR(m02_axi_error),
		.M_AXI_ACLK(m02_axi_aclk),
		.M_AXI_ARESETN(m02_axi_aresetn),
		.M_AXI_AWID(m02_axi_awid),
		.M_AXI_AWADDR(m02_axi_awaddr),
		.M_AXI_AWLEN(m02_axi_awlen),
		.M_AXI_AWSIZE(m02_axi_awsize),
		.M_AXI_AWBURST(m02_axi_awburst),
		.M_AXI_AWLOCK(m02_axi_awlock),
		.M_AXI_AWCACHE(m02_axi_awcache),
		.M_AXI_AWPROT(m02_axi_awprot),
		.M_AXI_AWQOS(m02_axi_awqos),
		.M_AXI_AWUSER(m02_axi_awuser),
		.M_AXI_AWVALID(m02_axi_awvalid),
		.M_AXI_AWREADY(m02_axi_awready),
		.M_AXI_WDATA(m02_axi_wdata),
		.M_AXI_WSTRB(m02_axi_wstrb),
		.M_AXI_WLAST(m02_axi_wlast),
		.M_AXI_WUSER(m02_axi_wuser),
		.M_AXI_WVALID(m02_axi_wvalid),
		.M_AXI_WREADY(m02_axi_wready),
		.M_AXI_BID(m02_axi_bid),
		.M_AXI_BRESP(m02_axi_bresp),
		.M_AXI_BUSER(m02_axi_buser),
		.M_AXI_BVALID(m02_axi_bvalid),
		.M_AXI_BREADY(m02_axi_bready),
		.M_AXI_ARID(m02_axi_arid),
		.M_AXI_ARADDR(m02_axi_araddr),
		.M_AXI_ARLEN(m02_axi_arlen),
		.M_AXI_ARSIZE(m02_axi_arsize),
		.M_AXI_ARBURST(m02_axi_arburst),
		.M_AXI_ARLOCK(m02_axi_arlock),
		.M_AXI_ARCACHE(m02_axi_arcache),
		.M_AXI_ARPROT(m02_axi_arprot),
		.M_AXI_ARQOS(m02_axi_arqos),
		.M_AXI_ARUSER(m02_axi_aruser),
		.M_AXI_ARVALID(m02_axi_arvalid),
		.M_AXI_ARREADY(m02_axi_arready),
		.M_AXI_RID(m02_axi_rid),
		.M_AXI_RDATA(m02_axi_rdata),
		.M_AXI_RRESP(m02_axi_rresp),
		.M_AXI_RLAST(m02_axi_rlast),
		.M_AXI_RUSER(m02_axi_ruser),
		.M_AXI_RVALID(m02_axi_rvalid),
		.M_AXI_RREADY(m02_axi_rready)
	);

// Add user logic here
// Instantiation of base_address_rd
	base_address_rd #(
		.START_ADDR(BRAM_BASEADDRESS_START_ADDR)
	)base_address_rd_inst(
		.clk(base_address_rd_clk),
		.rst_n(base_address_rd_rst_n),
		//ram
		.ram_clk(ram_clk),
		.ram_rst(ram_rst),
		//addr
		.ram_addr(ram_addr),
		//read
		.ram_en(ram_en),
		.ram_rd_data(ram_rd_data),
		//write(not use)
		.ram_we(ram_we),
		.ram_wd_data(ram_wd_data),
		.Transfer_Done(m01_start_flag),
		//user use
		.change_based_address(w_change_based_address)
		//.data_get(m01_start_flag)
	);

  // Instantiation of CWBP_Decoder
	CWBP_Decoder #(
    	.C_DATA_WIDTH(C_CWBP_DATA_WIDTH)
	) CWBP_Decoder_inst(
		.mapping_pointer(ram_rd_data),
		.Way(Way),
		.Row_address(Row_address)
	);
  
  // Patch counter   
  // output ready signal
	//assign	UW_wait		=	~UW_busy;
	//assign	UW_ready	=	(patch_num == 0) ? UW_finish : (UW_finish & UW_wait);

	always @(posedge m01_axi_aclk) begin
		if (!m01_axi_aresetn) begin
			UW_count	<=	2'b0;
		end 
		else begin
			if(m01_UW_Finish)
				UW_count	<=	UW_count;	
			else if(m01_start_flag)
				UW_count	<=	UW_count + 1'b1;			
		end
	end

	assign	UW_module_Finish	=	(UW_count == 2'd2) ? 1'b1 : 1'b0;
	// User logic ends

// //  Mapping_Table_info_buffer
// 	reg [4:0] MT_info_buffer [31:0];
// 	integer i;

	endmodule
