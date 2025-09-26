module counter (
	input  wire        sys_clk   ,
	input  wire        sys_rst_n ,
	input  wire        cnt_en    ,
	input  wire [1:0]  wr_sel    ,
     input  wire [3:0]  pstrb     ,
	input  wire [31:0] wdt       ,
     input  wire        timer_en  ,
	output wire [63:0] cnt
);

parameter DEFAULT     = 32'h00;
parameter CNT_DEFAULT = 64'h00;
reg  [31:0] tdr0_r   ;
reg  [31:0] tdr1_r   ;

wire [31:0] tdr0_tmp ;
wire [31:0] tdr1_tmp ;
wire [63:0] cnt_tmp  ;

assign cnt      = {tdr1_r,tdr0_r};
assign cnt_tmp = cnt + 1'b1;
assign tdr0_tmp [7:0] = (wr_sel == 2'b01) & pstrb[0] ?  wdt[7:0]      : 
                        timer_en                     ?  8'h0          :
			         cnt_en                       ?  cnt_tmp [7:0] :
					     		               tdr0_r [7:0]  ;

assign tdr0_tmp [15:8] = (wr_sel == 2'b01) & pstrb[1] ?  wdt[15:8]     :      
                         timer_en                     ?  8'h0          :
                         cnt_en                       ?  cnt_tmp[15:8] :
                                                         tdr0_r [15:8] ;

assign tdr0_tmp [23:16] = (wr_sel == 2'b01) & pstrb[2] ?  wdt[23:16]     :      
                          timer_en                     ?  8'h0           :
                          cnt_en                       ?  cnt_tmp[23:16] :
                                                          tdr0_r [23:16] ;

assign tdr0_tmp [31:24] = (wr_sel == 2'b01) & pstrb[3] ?  wdt[31:24]      :      
                          timer_en                     ?  8'h0            :
                          cnt_en                       ?  cnt_tmp [31:24] :
                                                          tdr0_r [31:24]  ;

assign tdr1_tmp [7:0] = (wr_sel == 2'b10) & pstrb[0] ?  wdt[7:0]        :      
                        timer_en                     ?  8'h0            :
                        cnt_en                       ?  cnt_tmp [39:32] :
                                                        tdr1_r [7:0]    ;

assign tdr1_tmp [15:8] = (wr_sel == 2'b10) & pstrb[1] ?  wdt[15:8]     :  
                         timer_en                     ?  8'h0          :
                         cnt_en                       ?  cnt_tmp[47:40] :
                                                         tdr1_r [15:8] ;

assign tdr1_tmp [23:16] = (wr_sel == 2'b10) & pstrb[2] ?  wdt[23:16]     :
                          timer_en                     ?  8'h0           :
                          cnt_en                       ?  cnt_tmp[55:48] :
                                                          tdr1_r [23:16] ;

assign tdr1_tmp [31:24] = (wr_sel == 2'b10) & pstrb[3] ?  wdt[31:24]      :
                          timer_en                     ?  8'h0            :
                          cnt_en                       ?  cnt_tmp [63:56] :
                                                          tdr1_r [31:24]  ;


always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		tdr0_r <= DEFAULT;
	end
	else begin
		tdr0_r <= tdr0_tmp;
	end
end		

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          tdr1_r <= DEFAULT;
     end 
     else begin
          tdr1_r <= tdr1_tmp;
     end 
end
endmodule
