module base_address_rd #(
    parameter  START_ADDR = 32'h4580_0000
    )
    (
    input clk ,
    input rst_n ,

    output ram_clk , 
    output ram_rst,
    //addr
    output reg [31:0] ram_addr,
    //read
    output ram_en ,
    input  [31:0] ram_rd_data,
    //write(not use)
    output [3:0]  ram_we,
    output [31:0] ram_wd_data,
    //to m01_signal
    output wire Transfer_Done,
    //user use
    input   change_based_address
    //input   data_get
    );

assign ram_rst  = 1'b0;
assign ram_clk  = clk ;
assign ram_en   = 1'b1;
assign ram_we   = 4'b0;
assign ram_wd_data = 32'd0;


reg         counter;
reg [31:0]  reg_ram_rd_data;

reg [31:0]  data_input_change;

// change to pulse
assign Transfer_Done = (reg_ram_rd_data == data_input_change) ? 1'b1 : 1'b0;//(counter && ((&ram_rd_data) != 0)) ? 1'b1 : 1'b0;
//   assign Transfer_Done  =  (counter == 1'b1) ? 1'b1 : 1'b0;
//--------------------- rd data reg ---------------------//
    always @(posedge clk  or negedge rst_n) begin
        if (!rst_n) begin
            // data_input_change <=  32'h0001_0010;
            data_input_change <=  32'h0001_0030;
        end 
        else if(Transfer_Done)begin
            // data_input_change <=  32'h0003_0010;    
            // data_input_change <=  data_input_change - 32'h0001_0000;        
            data_input_change <=  data_input_change + 32'h0001_0000;        
        end 
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_ram_rd_data <=  32'd0;
        end 
        else begin
            reg_ram_rd_data <=  ram_rd_data;            
        end
    end


    // always @(posedge clk or negedge rst_n) begin
    //     if (!rst_n) begin
    //         counter <= 1'b0;    
    //     end 
    //     else begin
    //         if ((counter == 1'b1) && (!Transfer_Done)) begin
    //             counter <= counter;        
    //         end
    //         else if (change_based_address)  begin
    //             counter <=  1'b0;
    //         end
    //         else if (reg_ram_rd_data == data_input_change) begin
    //             counter <= counter + 1'b1;
    //         end
    //         // else 
    //         //     counter <=  counter + 1'b1;
    //     end
    //end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ram_addr <= START_ADDR;
    end
    else begin
        if (change_based_address)  begin
            ram_addr    <= ram_addr +   32'h0000_0004;
        end
        else
            ram_addr    <= ram_addr;
    end
end

endmodule
