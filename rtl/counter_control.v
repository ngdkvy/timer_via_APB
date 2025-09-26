module counter_control (
	input  wire       sys_clk   ,
	input  wire       sys_rst_n ,
	input  wire       div_en    ,
	input  wire [3:0] div_val   ,
	input  wire       halt_req  ,
	input  wire       timer_en  ,
	output wire       cnt_en  
);

reg  [7:0]  div             ;
reg  [7:0]  cnt             ;
wire [7:0]  cnt_pre         ;
wire        cnt_rst         ;
wire        default_mode    ;
wire        cnt_ctrl_mode_0 ;
wire        cnt_ctrl_other  ;

assign cnt_rst = (cnt == div) | (!timer_en) | (!div_en);
assign cnt_pre = halt_req   ? cnt  :
                 cnt_rst    ? 8'h0 :
                 cnt + 1'b1 ;

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          cnt <= 8'h0;
     end else begin
          cnt <= cnt_pre;
     end
end

always @(*) begin
	case (div_val) 
		4'b0000: div = 8'd0   ;
		4'b0001: div = 8'd1   ;
		4'b0010: div = 8'd3   ;
		4'b0011: div = 8'd7   ;
		4'b0100: div = 8'd15  ;
		4'b0101: div = 8'd31  ;
		4'b0110: div = 8'd63  ;
		4'b0111: div = 8'd127 ;
		4'b1000: div = 8'd255 ;
		default: div = 8'd0      ;
	endcase
end

assign default_mode    = !div_en & timer_en ;
assign cnt_ctrl_mode_0 = div_en  & timer_en & (div_val == 0);
assign cnt_ctrl_other  = timer_en & div_en & (div_val != 0) & (cnt == div);
assign cnt_en          = (default_mode | cnt_ctrl_mode_0 | cnt_ctrl_other) & !halt_req ;
endmodule	
