module register #(parameter N = 32)
(
	input  wire         sys_clk      ,
     input  wire         sys_rst_n    ,
	input  wire         wr_en        ,
	input  wire         rd_en        ,
	input  wire [11:0]  addr         ,
	input  wire [N-1:0] pwdata       ,
	input  wire [63:0]  cnt          ,
	input  wire         dbg_mode     ,
     input  wire [3:0]   pstrb        ,
	output wire [N-1:0] rdata        ,
	output wire         div_en       ,
	output wire [3:0]   div_val      ,
	output wire         halt_req     ,
	output wire         timer_en     ,
     output wire         timer_en_out ,
	output wire [1:0]   wr_sel       ,
	output wire         pslverr      ,
	output wire         tim_int      ,
	output wire [N-1:0] wdt       
);
		

//address 12 bit
//apb -> addr 32 bit
//ss base_address == 4000_1 -> khop -->
//khong khop --> pslverr = 1

parameter ADDR_TCR     = 12'h00;
parameter ADDR_TDR0    = 12'h04;
parameter ADDR_TDR1    = 12'h08;
parameter ADDR_TCMP0   = 12'h0C;
parameter ADDR_TCMP1   = 12'h10;
parameter ADDR_TIER    = 12'h14;
parameter ADDR_TISR    = 12'h18;
parameter ADDR_THCSR   = 12'h1C;

parameter TCR_DEFAULT   = 32'h100 ;
parameter TDR0_DEFAULT  = 32'h0   ;
parameter TDR1_DEFAULT  = 32'h0   ;
parameter TIER_DEFAULT  = 32'b0    ;
parameter TISR_DEFAULT  = 32'b0    ;
parameter THCSR_DEFAULT = 32'b0    ;

parameter TCMP0_DEFAULT = 32'hFFFF_FFFF ;
parameter TCMP1_DEFAULT = 32'hFFFF_FFFF ;


reg [7:0]    sel_reg      ;
reg [N-1:0]  tcr_r        ;
reg [N-1:0]  tcmp0_r      ;
reg [N-1:0]  tcmp1_r      ;
reg [N-1:0]  tisr_r       ;
reg [N-1:0]  tier_r       ;
reg [N-1:0]  thcsr_r      ;
reg [N-1:0]  rdata_r      ;
reg          timer_en_r   ;

wire [N-1:0] tcmp0_tmp    ;
wire [N-1:0] tcmp1_tmp    ;

wire         int_clr      ;
wire         int_set      ;
wire         int_st       ; 
wire         int_en       ;
wire         ctrl         ;
wire         halt_ack     ;
wire         halt_req_tmp ;
wire         err_div_en   ;
wire [N-1:0]   tcr_tmp      ;
wire         div_val_tmp  ;
wire         err_div_val_0  ;
wire         err_div_val_1  ;
//address decoder
always @(*) begin
	case (addr)
		ADDR_TCR   : sel_reg = 8'b0000_0001;
		ADDR_TDR0  : sel_reg = 8'b0000_0010;
		ADDR_TDR1  : sel_reg = 8'b0000_0100;
		ADDR_TCMP0 : sel_reg = 8'b0000_1000;
		ADDR_TCMP1 : sel_reg = 8'b0001_0000;
		ADDR_TIER  : sel_reg = 8'b0010_0000;
          ADDR_TISR  : sel_reg = 8'b0100_0000;
          ADDR_THCSR : sel_reg = 8'b1000_0000;
		default    : sel_reg = 8'b0000_0000;
	endcase
end

//TCR
//reg_sel[0]
assign ctrl         = wr_en & sel_reg[0]     ;
assign timer_en_out = ~tcr_r[0] & timer_en_r ;

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          timer_en_r <= 1'b0;
     end else begin
          timer_en_r <= tcr_r[0];
     end
end

//div_val
assign pslverr     = err_div_en | err_div_val_1 | err_div_val_0;
assign div_val_tmp = ctrl && pstrb[1] && (pwdata[11:8] <= 4'h8)            ;
assign div_val     = div_val_tmp & ~pslverr ? pwdata[11:8] : tcr_r[11:8] ;

//div_en
assign div_en      = ctrl & pstrb[0] & ~pslverr ? pwdata [1] : tcr_r[1]  ;

//timer_en
assign timer_en    = ctrl & pstrb[0] & ~pslverr ? pwdata [0] : tcr_r[0]  ;

assign err_div_en = tcr_r[0] & ctrl & pstrb[0] & (pwdata[1] != tcr_r[1]);

assign err_div_val_1 = ctrl && pstrb[1] && (pwdata[11:8] > 8);
assign err_div_val_0 = tcr_r[0] && ctrl && pstrb[1] && (pwdata[11:8] != tcr_r[11:8]);

assign tcr_tmp = {20'h0, div_val, 6'h0, div_en, timer_en};
always @(posedge sys_clk or negedge sys_rst_n) begin
	if (!sys_rst_n) begin
		tcr_r <= TCR_DEFAULT; 
	end
	else begin
		tcr_r <= tcr_tmp;
	end
end

assign wr_sel    = wr_en & sel_reg[1] ? 2'b01   :
			    wr_en & sel_reg[2] ? 2'b10   :
								2'b00   ;
assign wdt     = (|wr_sel == 1) ? pwdata : 32'h0 ;
 
//TCMP0
//sel_reg[3]
assign tcmp0_tmp[7:0]    = wr_en & sel_reg[3] & pstrb[0] ? pwdata[7:0]   : tcmp0_r[7:0]   ;
assign tcmp0_tmp[15:8]   = wr_en & sel_reg[3] & pstrb[1] ? pwdata[15:8]  : tcmp0_r[15:8]  ;
assign tcmp0_tmp[23:16]  = wr_en & sel_reg[3] & pstrb[2] ? pwdata[23:16] : tcmp0_r[23:16] ;
assign tcmp0_tmp[31:24]  = wr_en & sel_reg[3] & pstrb[3] ? pwdata[31:24] : tcmp0_r[31:24] ;

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          tcmp0_r <= TCMP0_DEFAULT;
     end
     else begin
          tcmp0_r <= tcmp0_tmp;
     end
end

//TCMP1
//sel_reg[4]
assign tcmp1_tmp[7:0]    = wr_en & sel_reg[4] & pstrb[0] ? pwdata[7:0]   : tcmp1_r[7:0]   ;
assign tcmp1_tmp[15:8]   = wr_en & sel_reg[4] & pstrb[1] ? pwdata[15:8]  : tcmp1_r[15:8]  ;
assign tcmp1_tmp[23:16]  = wr_en & sel_reg[4] & pstrb[2] ? pwdata[23:16] : tcmp1_r[23:16] ;
assign tcmp1_tmp[31:24]  = wr_en & sel_reg[4] & pstrb[3] ? pwdata[31:24] : tcmp1_r[31:24] ;

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          tcmp1_r <= TCMP1_DEFAULT;
     end
     else begin
          tcmp1_r <= tcmp1_tmp;
     end
end

//TIER
//sel_reg[5]
assign int_en = wr_en & sel_reg[5] & pstrb[0] ? pwdata[0] : tier_r[0];

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          tier_r <= TIER_DEFAULT;
     end
     else begin
          tier_r <= {31'h0, int_en};
     end
end

//TISR
//sel_reg[6]
assign int_clr  = wr_en & sel_reg[6] & pstrb[0] & (pwdata[0] == 1'b1) & (tisr_r[0] == 1'b1) ;
assign int_set  = (cnt[63:0] == {tcmp1_r,tcmp0_r});
assign int_st   = int_clr ? 1'b0        :
			   int_set ? 1'b1        :
					   tisr_r[0]   ;

always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          tisr_r <= TISR_DEFAULT;
     end
     else begin
          tisr_r <={31'h0, int_st};
     end
end

//assign tim_int = tier_r[0] & tisr_r[0];
assign tim_int = int_en & int_st;
//THCSR
//sel_reg[7]
assign halt_req_tmp = (wr_en & sel_reg[7] & pstrb[0])? pwdata[0] : thcsr_r[0] ;
assign halt_ack     = dbg_mode & halt_req_tmp;
assign halt_req     = halt_ack       ;
always @(posedge sys_clk or negedge sys_rst_n) begin
     if (!sys_rst_n) begin
          thcsr_r <= THCSR_DEFAULT;
     end 
     else begin
          thcsr_r <= {30'h0, halt_ack, halt_req_tmp};
     end 
end

//rdata
assign rdata       = rdata_r;
     always @(*) begin
         if (rd_en) begin
               case (addr)
                    ADDR_TCR   : rdata_r = tcr_r      ;
                    ADDR_TDR0  : rdata_r = cnt[31:0]  ; 
          		ADDR_TDR1  : rdata_r = cnt[63:32] ;
          		ADDR_TCMP0 : rdata_r = tcmp0_r    ;
          		ADDR_TCMP1 : rdata_r = tcmp1_r    ;
          		ADDR_TIER  : rdata_r = tier_r     ;
          		ADDR_TISR  : rdata_r = tisr_r     ;
          		ADDR_THCSR : rdata_r = thcsr_r    ;
                    default    : rdata_r = 32'h0      ;
               endcase
          end
          else begin
               rdata_r = 32'h0;
          end
     end

     endmodule
