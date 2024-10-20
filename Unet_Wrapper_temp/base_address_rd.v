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
    input [31:0] ram_rd_data,
    //write(not use)
    output [3:0]  ram_we,
    output [31:0] ram_wd_data,
    //to m01_signal
    output Transfer_Done
    );

assign ram_rst  = 1'b0;
assign ram_clk  = clk ;
assign ram_en   = 1'b1;
assign ram_we   = 4'b0;
assign ram_wd_data = 32'd0;


reg counter;
assign Transfer_Done    =   (counter) ? 1'b1 : 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 1'b0;    
    end 
    else begin
      if (counter) begin
        counter <= counter;        
      end
      else begin
        counter <= counter + 1'b1;
      end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ram_addr <= 32'd0;
    end
    else begin
        if(counter == 0)
            ram_addr    <= START_ADDR;
        else
            ram_addr    <= 32'd0;
    end
end

endmodule
