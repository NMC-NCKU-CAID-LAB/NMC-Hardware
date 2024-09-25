`timescale 1 ns/ 1 ps

    module Unet2DDR_v2_0_M01_AXI #(
		// Users to add parameters here
		parameter C_M_FLASH_CHANNEL		=	3'd0,
		parameter C_M_BRAM_BASE_ADDR	=	32'h5000_0000,
		// User parameters ends
		// Base address of targeted slave
		parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h43c0_3000,
		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		parameter integer C_M_AXI_BURST_LEN	= 16,
		// Thread ID Width
		parameter integer C_M_AXI_ID_WIDTH	= 1,
		// Width of Address Bus
		parameter integer C_M_AXI_ADDR_WIDTH	= 32,
		// Width of Data Bus
		parameter integer C_M_AXI_DATA_WIDTH	= 32,
		// Width of User Write Address Bus
		parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
		// Width of User Read Address Bus   
		parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
		// Width of User Write Data Bus
		parameter integer C_M_AXI_WUSER_WIDTH	= 0,
		// Width of User Read Data Bus
		parameter integer C_M_AXI_RUSER_WIDTH	= 0,
		// Width of User Response Bus 
		parameter integer C_M_AXI_BUSER_WIDTH	= 0
    ) (
		// Users to add ports here
		input  wire M02_finish_flag, 
		output wire check_M02_state_flag,

		input  wire [3:0] Way,
		input  wire [C_M_AXI_DATA_WIDTH -1:0] Row_address,

		// User ports ends
		// // Initiate AXI transactions
		input wire  INIT_AXI_TXN,

		// // Asserts when transaction is complete
		// output wire  TXN_DONE,
		// // Asserts when ERROR is detected
		// output reg  ERROR,

		input wire  M_AXI_ACLK,
		input wire  M_AXI_ARESETN,

		input wire  M_AXI_AWREADY,
		output wire  M_AXI_AWVALID,
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		output wire [1 : 0] M_AXI_AWBURST,

		input wire  M_AXI_WREADY,
		output wire  M_AXI_WVALID,
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		output wire  M_AXI_WLAST,

		input wire [1 : 0] M_AXI_BRESP,

		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		output wire [7 : 0] M_AXI_AWLEN,
		output wire [2 : 0] M_AXI_AWSIZE,
		output wire  M_AXI_AWLOCK,
		output wire [3 : 0] M_AXI_AWCACHE,
		output wire [2 : 0] M_AXI_AWPROT,
		output wire [3 : 0] M_AXI_AWQOS,
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,


		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		output wire  M_AXI_RREADY        
    );

	// function called clogb2 that returns an integer which has the
	//value of the ceiling of the log base 2

	  // function called clogb2 that returns an integer which has the 
	  // value of the ceiling of the log base 2.                      
	  function integer clogb2 (input integer bit_depth);              
	  begin                                                           
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	      bit_depth = bit_depth >> 1;                                 
	    end                                                           
	  endfunction                                                     

	// C_TRANSACTIONS_NUM is the width of the index counter for 
	// number of write or read transaction.
	 localparam integer C_TRANSACTIONS_NUM = clogb2(C_M_AXI_BURST_LEN-1);

	// Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	// Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	 localparam integer C_MASTER_LENGTH	= 12;
	// total number of burst transfers is master length divided by burst length and burst size
	 localparam integer C_NO_BURSTS_REQ = C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);

// <--------------local_parameter------------------>
    //parameter for offset
    parameter [15:0] ID_register_offset = 16'h0000; 
    parameter [15:0] SP_register_offset = 16'h3000;
    parameter [15:0] CC_register_offset = 16'h4000; 
    parameter [31:0] statusreport_reg   = 32'h1234_5678;
// <-------local_parameter_End---------------------->
// <-------------------FSM------------------------->
    //parameter for FSM
        parameter [2:0] Init     = 3'b000,
                        Trigger  = 3'b001,
                        Check    = 3'b010,
                        Transfer = 3'b011;
// <------------------FSM_End---------------------->
//<---------------Control Signal------------------->
	wire addr_done;
	wire Trigger_done, Check_done, Trans_done, Read_done;//, writes_done;
	reg [2:0] count;
	reg [2:0] S_cur, S_next;
	reg [10:0] mp_counter;
	wire mp_counter_flag;// (use pulse)	
	wire mp_done;  // revise times 

	assign	mp_counter_flag	=	Trans_done;
	assign	mp_done			=	(mp_counter == 100) ? 1'b1 : 1'b0;

	assign Trigger_done = ((S_cur == Trigger) && writes_done)? 1'b1 : 1'b0;

	assign Check_done   = ((S_cur == Check) && writes_done)? 1'b1 : 1'b0;
	assign Trans_done   = ((S_cur == Transfer) && writes_done)? 1'b1 : 1'b0;	
	assign check_M02_state_flag	 =	Trigger_done;

	always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
	      writes_done <= 1'b0;                                                                                  
                                           
	    //else if (M_AXI_BVALID && axi_bready && (write_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_wlast)
	    else if (M_AXI_BVALID && (write_burst_counter[C_NO_BURSTS_REQ]) && axi_bready)                          
	      writes_done <= 1'b1;                                                                                  
	    else                                                                                                    
	      writes_done <= writes_done;                                                                           
	  end  
//<-----------Control Signal END------------------->

//<-----------------count-------------------------->
	// <Conut the number of command write into prticular place>
		always @(posedge M_AXI_ACLK) begin
		if (!M_AXI_ARESETN || init_txn_pulse )   count <= 3'b0;   
		else            
			case (S_cur)
				Trigger:	count <= (Trigger_done)? 3'd0 : count + 1;
				Check:		count <= (Check_done)  ? 3'd0 : count + 1;
				Transfer:   count <= (Trans_done)  ? 3'd0 : count + 1;
				default: 	count <= count;
			endcase
		end
//<-----------------count end---------------------->
// <-------------internal_signals------------------>
	//user add
	wire [C_M_AXI_ADDR_WIDTH-1 : 0] Targert_addr;
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] target_count;		
	//
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awvalid;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
	reg  	axi_wlast;
	reg  	axi_wvalid;
	reg  	axi_bready;
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arvalid;
	reg  	axi_rready;
	//write beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	write_index;
	//read beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	read_index;
	//size of C_M_AXI_BURST_LEN length burst in bytes
	wire [C_TRANSACTIONS_NUM+2 : 0] 	burst_size_bytes;
	//The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
	reg [C_NO_BURSTS_REQ : 0] 	write_burst_counter;
	reg [C_NO_BURSTS_REQ : 0] 	read_burst_counter;
	reg  	start_single_burst_write;
	reg  	start_single_burst_read;
	reg  	writes_done;
	reg  	reads_done;
	reg  	error_reg;
	reg  	compare_done;
	reg  	read_mismatch;
	reg  	burst_write_active;
	reg  	burst_read_active;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	expected_rdata;
	//Interface response error flags
	wire  	write_resp_error;
	wire  	read_resp_error;
	wire  	wnext;
	wire  	rnext;
	reg  	init_txn_ff;
	reg  	init_txn_ff2;
	reg  	init_txn_edge;
	wire  	init_txn_pulse;
// <-----------internal_signals_end----------------->

// <----------- I/O Connection---------------------->
	//user 
	assign Targert_addr	= C_M_BRAM_BASE_ADDR + target_count;

	assign M_AXI_AWID	= 'b0;
	assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
	
	
	assign M_AXI_AWLEN	= C_M_AXI_BURST_LEN - 1;


	assign M_AXI_AWSIZE	= 3'b010;
	//clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	assign M_AXI_AWBURST	= 2'b01;
	assign M_AXI_AWLOCK		= 1'b0;
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= 3'h0;
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'b1;
	assign M_AXI_AWVALID	= axi_awvalid;
	assign M_AXI_WDATA	= axi_wdata;
	assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'b0;
	assign M_AXI_WVALID	= axi_wvalid;
	assign M_AXI_BREADY	= axi_bready;
	assign M_AXI_ARID	= 'b0;
	assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
	assign M_AXI_ARLEN	= C_M_AXI_BURST_LEN - 1;
	assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	assign M_AXI_ARBURST	= 2'b01;
	assign M_AXI_ARLOCK	= 1'b0;
	assign M_AXI_ARCACHE	= 4'b0010;
	assign M_AXI_ARPROT	= 3'h0;
	assign M_AXI_ARQOS	= 4'h0;
	assign M_AXI_ARUSER	= 'b1;
	assign M_AXI_ARVALID	= axi_arvalid;
	assign M_AXI_RREADY	= axi_rready;
	//assign TXN_DONE	= compare_done;
	assign burst_size_bytes	= C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
	assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;
// <----------- I/O Connection end------------------>

// <----------- Initialize Pulse-------------------->
	always @(posedge M_AXI_ACLK)										      
	begin                                                                        
	// Initiates AXI transaction delay    
	if (M_AXI_ARESETN == 0 )                                                   
		begin                                                                    
		init_txn_ff <= 1'b0;                                                   
		init_txn_ff2 <= 1'b0;                                                   
		end                                                                               
	else                                                                       
		begin  
		init_txn_ff <= INIT_AXI_TXN;
		init_txn_ff2 <= init_txn_ff;                                                                 
		end                                                                      
	end    
// <----------- Initialize Pulse-End----------------->

// <----------- burst_write_active ----------------->
	always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
	      burst_write_active <= 1'b0;                                                                           
	                                                                                                            
	    //The burst_write_active is asserted when a write burst transaction is initiated                        
	    else if (start_single_burst_write)                                                                      
	      burst_write_active <= 1'b1;                                                                           
	    else if (M_AXI_BVALID && axi_bready)                                                                    
	      burst_write_active <= 0;                                                                              
	  end 


// <---------- Write Address Channel ---------------->
	always @(posedge M_AXI_ACLK)                                   
	begin                                                                
																		
	if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                           
		begin                                                            
		axi_awvalid <= 1'b0;                                           
		end                                                              
	// If previously not valid , start next transaction                
	else if (~axi_awvalid && start_single_burst_write)                 
		begin                                                            
		axi_awvalid <= 1'b1;                                           
		end                                                              
	/* Once asserted, VALIDs cannot be deasserted, so axi_awvalid      
	must wait until transaction is accepted */                         
	else if (M_AXI_AWREADY && axi_awvalid)                             
		begin                                                            
		axi_awvalid <= 1'b0;                                           
		end                                                              
	else                                                               
		axi_awvalid <= axi_awvalid;                                      
	end
// <---------- Write Address Channel END------------->     

// <---------- Write Data Channel ---------------->
	always @(posedge M_AXI_ACLK)                                   
	begin                                                                															
		if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                                                                                      
			axi_wvalid <= 1'b0;                                                                                                                       
		else if (~axi_awvalid && ~axi_wvalid && start_single_burst_write) 
			axi_wvalid <= 1'b1;                                                            
	    else if (wnext && axi_wlast)                                                    
	      axi_wvalid <= 1'b0;                                              
	    else                                                                            
	      axi_wvalid <= axi_wvalid;                                                     
	  end    

	//data
	always @(posedge M_AXI_ACLK)                                         
	  begin                                                                
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                            
	      begin                                                            
	        axi_awaddr <= 'b0;                                             
	      end                                                              
	    else if (M_AXI_AWREADY && axi_awvalid)                             
	      begin
	        axi_awaddr <= C_M_FLASH_CHANNEL + C_M_AXI_DATA_WIDTH/8;   			                                                            
	        // axi_awaddr <= axi_awaddr + burst_size_bytes;                   
	      end                                                              
	    else                                                               
	      axi_awaddr <= axi_awaddr;                                        
	 end    

// <---------- Write DATA Channel END----------------> 

// <-------------- Write Data Last ------------------->
	always @(posedge M_AXI_ACLK)                                                      
	  begin                                                                             
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                                        
	      begin                                                                         
	        axi_wlast <= 1'b0;                                                          
	      end
		else if (((write_index == C_M_AXI_BURST_LEN-2 && C_M_AXI_BURST_LEN >= 2) && wnext) || (C_M_AXI_BURST_LEN == 1 ))
	      begin                                                                         
	        axi_wlast <= 1'b1;                                                          
	      end
		else if (wnext)                                                                 
	      axi_wlast <= 1'b0;                                                            
	    else if (axi_wlast && C_M_AXI_BURST_LEN == 1)                                   
	      axi_wlast <= 1'b0;                                                            
	    else                                                                            
	      axi_wlast <= axi_wlast;                                                       
	  end                                                         
// <---------- Write DATA Last END---------------->   


// <---------- write_Brust_counter----------------> 
	  always @(posedge M_AXI_ACLK)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                                                                 
	      begin                                                                                                 
	        write_burst_counter <= 'b0;                                                                         
	      end                                                                                                   
	    else if (M_AXI_AWREADY && axi_awvalid)                                                                  
	      begin                                                                                                 
	        if (write_burst_counter[C_NO_BURSTS_REQ] == 1'b0)                                                   
	          begin                                                                                             
	            write_burst_counter <= write_burst_counter + 1'b1;                                              
	            //write_burst_counter[C_NO_BURSTS_REQ] <= 1'b1;                                                 
	          end                                                                                               
	      end                                                                                                   
	    else                                                                                                    
	      write_burst_counter <= write_burst_counter;                                                           
	  end  
// <---------- write_Brust_counter end----------------> 

// <---------- write_index (Brust Len counter)----------------> 
	  always @(posedge M_AXI_ACLK)                                                      
	  begin                                                                             
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 || start_single_burst_write == 1'b1)    
	      begin                                                                         
	        write_index <= 0;                                                           
	      end                                                                           
	    else if (wnext && (write_index != C_M_AXI_BURST_LEN-1))                         
	      begin                                                                         
	        write_index <= write_index + 1;                                             
	      end                                                                           
	    else                                                                            
	      write_index <= write_index;                                                   
	  end  

// <---------- write_index (Brust Len counter) end----------------> 
	
//Forward movement occurs when the write channel is valid and ready

	  assign wnext = M_AXI_WREADY & M_AXI_WVALID;//axi_wvalid;  


// <---------- Read Address Channel ---------------->
	always @(posedge M_AXI_ACLK) begin                                                              																			
		if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
		begin                                                          
			axi_arvalid <= 1'b0;                                         
		end                                                            
		// If previously not valid , start next transaction              
		else if (~axi_arvalid && start_single_burst_read)                
		begin                                                          
			axi_arvalid <= 1'b1;                                         
		end                                                            
		else if (axi_arvalid)//M_AXI_ARREADY &&                           
		begin                                                          
			axi_arvalid <= 1'b0;                                         
		end                                                            
		else                                                             
		axi_arvalid <= axi_arvalid;                                    
	end 
// <---------- Read Address Channel END---------------->

// < ----------Block List Decoder Transfer----------->
	reg [11:0] flash_Way;
	always @(*) begin
		case (Way)
			3'd0:	flash_Way	= 12'h000;	
			3'd1:	flash_Way	= 12'h001;
			3'd2:	flash_Way	= 12'h010;
			3'd3:	flash_Way	= 12'h011;
			3'd4:	flash_Way	= 12'h100;
			3'd5:	flash_Way	= 12'h101;
			3'd6:	flash_Way	= 12'h110;
			3'd7:	flash_Way	= 12'h111;
			default:	flash_Way	= 12'h000;
		endcase
	end

// <-----------------------FSM----------------------->
	//Changing FSM state from State_next to State_current
	always @(posedge M_AXI_ACLK)begin
		if(M_AXI_ARESETN == 0)  S_cur <= Init;
		else          		S_cur <= S_next;
	end
	//FSM
	always @(*)begin
		case(S_cur)
			Init:begin
				if (init_txn_pulse) S_next = Trigger; // && axi_awvalid && M_AXI_AWREADY
				else 				S_next = Init;
			end
			Trigger:begin
				if(Trigger_done)  S_next = Check;
				else              S_next = Trigger;
			end
			Check:begin
				if(Check_done)    S_next = Transfer;
				else              S_next = Check;
			end
			default:begin       //transfer
				if(Trans_done && !mp_done)			S_next = Init;   // && Data_done
				else if(Trans_done && mp_done)	S_next = Trigger;    //  && !Data_done 
				else              								S_next = Transfer;
			end
		endcase
	end
	// <---------start_single_burst_write---------------->
	always @ ( posedge M_AXI_ACLK) begin          
		if (M_AXI_ARESETN == 1'b0 ) 
			begin                           
				start_single_burst_write <= 1'b0;                                
			end                                                                   
		else 
			case (S_cur)
				Trigger, Check, Transfer:  begin				
	                if (~axi_awvalid && ~start_single_burst_write && ~burst_write_active)                       
	                  begin                                                                                     
	                    start_single_burst_write <= 1'b1;                                                       
	                  end                                                                                       
	                else                                                                                        
	                  begin                                                                                     
	                    start_single_burst_write <= 1'b0; //Negate to generate a pulse                          
	                  end 
				end
				default:  start_single_burst_write <= 1'b0;
			endcase                                          
	end 	
// <--------------------FSM END---------------------->

// <------------ Target Address generator---------------->
	always @(posedge M_AXI_ACLK) begin
	if (!M_AXI_ARESETN || init_txn_pulse )   target_count <= 32'd0;   
	else            
		if(S_cur == Transfer)
			target_count <= (Trans_done)  ? 3'd0 : target_count + 32'd1;
	end

// <---------- Target Address generator end-------------->

// <----------------- Own Logic --------------------->
	always @(posedge M_AXI_ACLK ) begin
	if (!M_AXI_ARESETN || init_txn_pulse == 1'b1) begin
		// axi_awaddr   <= 32'h0000_0000;
		// axi_awsize   <= 3'b0;
		axi_wdata    <= 32'b0;
	end
	else begin
		// axi_awsize   <= 3'b010;

		case(S_cur)
		Trigger:begin
			if (axi_wvalid && M_AXI_WREADY) begin
				case (count)
					3'd0: begin             //write opcode into nsc_base_address + SP_register_offset
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset};
					axi_wdata    <= 32'h0000_01A4;
					end
					3'd1: begin             //write way into nsc_base_address + SP_register_offset + 4
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd4;
					axi_wdata    <= flash_Way;
					end
					3'd2: begin             //write row_address into nsc_base_address + SP_register_offset + 8
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd8;
					axi_wdata    <= Row_address;
					end
					3'd3: begin             //write done flag into nsc_base_address + CC_register_offset
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,CC_register_offset};
					axi_wdata    <= 32'h0000_0001;
					end
					default: begin           //otherwise
					// axi_awaddr   <= 32'h0000_0000;
					axi_wdata    <= 32'h0000_0000;
					end
				endcase			
			end 
			else begin
				axi_wdata    <= 32'h0000_0000;			
			end
		end
		Check:begin
			if (axi_wvalid && M_AXI_WREADY) begin
				case (count)
					3'd0: begin             //write opcode into nsc_base_address + SP_register_offset
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset};
					axi_wdata    <= 32'h0000_0130;
					end
					3'd1: begin             //write way into nsc_base_address + SP_register_offset + 4
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd4;
					axi_wdata    <= flash_Way;
					end
					3'd2: begin             //write statusreport_reg into nsc_base_address + 8
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,CC_register_offset} + 5'd8;
					axi_wdata    <= statusreport_reg;
					end
					3'd3: begin             //reset data in statusreport_reg
					// axi_awaddr   <= statusreport_reg;
					axi_wdata    <= 32'h0000_0000;
					end
					3'd4: begin             //write done flag into nsc_base_address + CC_register_offset
					// axi_awaddr   <= CC_register_offset;
					axi_wdata    <= 32'h0000_0001;
					end
					default: begin           //otherwise
					// axi_awaddr   <= 32'h0000_0000;
					axi_wdata    <= 32'h0000_0000;
					end
				endcase
			end
			else begin
					axi_wdata    <= 32'h0000_0000;				
			end

		end
		Transfer:begin
			if (axi_wvalid && M_AXI_WREADY) begin
				case (count)
					3'd0: begin             //write opcode into nsc_base_address + SP_register_offset
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset};
					axi_wdata    <= 32'h0000_0338;
					end
					3'd1: begin             //write way into nsc_base_address + SP_register_offset + 4
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd4;
					axi_wdata    <= flash_Way;
					end
					3'd2: begin             //write row_address into nsc_base_address + SP_register_offset + 8
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd8;
					axi_wdata    <= Row_address;
					end
					3'd3: begin             //write BRAM address into nsc_base_address + SP_register_offset + 12
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd12;
					axi_wdata    <= Targert_addr;
					end
					3'd4: begin             //write ECC address into nsc_base_address + SP_register_offset + 16    //need check
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd16;
					axi_wdata    <= 32'h0000_0001;
					end
					3'd5: begin             //write ERR address into nsc_base_address + SP_register_offset + 20     //need check
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd20;
					axi_wdata    <= 32'h0000_0001;
					end
					3'd6: begin             //write Complete address into nsc_base_address + SP_register_offset + 24
					// axi_awaddr   <= {C_M_FLASH_CHANNEL,SP_register_offset} + 5'd24;
					axi_wdata    <= 32'h0000_0001;
					end
					default: begin          //otherwise
					// axi_awaddr   <= 32'h0000_0000;
					axi_wdata    <= 32'h0000_0000;
					end
				endcase
			end
			else begin
					axi_wdata    <= 32'h0000_0000;							
			end		
		end
		default:begin
		//axi_awaddr   <= 32'b0;
		axi_wdata    <= 32'b0;
		end
		endcase
	end
	end
	
//----------------------- counter for mapping table -----------------------//
	//counter
	always @(posedge M_AXI_ACLK or posedge M_AXI_ARESETN) begin
		if(M_AXI_ARESETN == 0) begin
			mp_counter	<=	 11'd0;
		end
		else if(mp_counter_flag) begin  //use Trans done sig.
			mp_counter	<=	mp_counter	+ 1;
		end
		else begin
			mp_counter	<=	mp_counter;
		end
	end

//------------------------------ not use --------------------------------//
//axi_rready 
	  always @(posedge M_AXI_ACLK)                                          
	  begin                                                                 
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                  
	      begin                                                             
	        axi_rready <= 1'b0;                                             
	      end                                                               
	    // accept/acknowledge rdata/rresp with axi_rready by the master     
	    // when M_AXI_RVALID is asserted by slave                           
	    else if (M_AXI_RVALID)                       
	      begin                                      
	         if (M_AXI_RLAST && axi_rready)          
	          begin                                  
	            axi_rready <= 1'b0;                  
	          end                                    
	         else                                    
	           begin                                 
	             axi_rready <= 1'b1;                 
	           end                                   
	      end  
	  end

//axi_bready
	  always @(posedge M_AXI_ACLK)                                     
	  begin                                                                 
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                            
	      begin                                                             
	        axi_bready <= 1'b0;                                             
	      end                                                               
	    // accept/acknowledge bresp with axi_bready by the master           
	    // when M_AXI_BVALID is asserted by slave                           
	    else if (M_AXI_BVALID && ~axi_bready)                               
	      begin                                                             
	        axi_bready <= 1'b1;                                             
	      end
		else if (axi_wlast)
		  begin
	        axi_bready <= 1'b1;  			
		  end                                                               
	    // deassert after one clock cycle                                   
	    else if (M_AXI_BVALID && axi_bready)                                                
	      begin                                                             
	        axi_bready <= 1'b0;                                             
	      end                                                               
	    // retain the previous value                                        
	    else                                                                
	      axi_bready <= axi_bready;                                         
	  end  

    endmodule
