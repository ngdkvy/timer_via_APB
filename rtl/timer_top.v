module timer_top (
	input  wire        sys_clk      ,
	input  wire        sys_rst_n    ,
	input  wire        tim_psel     ,
	input  wire        tim_pwrite   ,
	input  wire        tim_penable  ,
	input  wire [11:0] tim_paddr    ,
	input  wire [31:0] tim_pwdata   ,
	input  wire [3:0]  tim_pstrb    ,
	output wire        tim_pready   ,
	input  wire        dbg_mode     ,
	output wire [31:0] tim_prdata   ,
	output wire        tim_pslverr  ,
	output wire        tim_int      
);
wire [31:0] wdta            ;
wire        write_en        ;
wire        read_en         ;
wire [63:0] count           ;
wire        div_en          ;
wire [3:0]  div_val         ;
wire        halt_req        ;
wire        timer_en_out    ;
wire        timer_en_tmp    ;
wire [1:0]  wr_sel          ;
wire        count_en        ;

		apb_slave u_apb (
						.pclk     ( sys_clk     ),
						.preset_n ( sys_rst_n   ),
						.psel     ( tim_psel    ),
						.pwrite   ( tim_pwrite  ),
						.penable  ( tim_penable ),
						.pready   ( tim_pready  ),
						.wr_en    ( write_en    ),
						.rd_en    ( read_en     )
					);

		register u_reg (
						.sys_clk      ( sys_clk     ),
						.sys_rst_n    ( sys_rst_n   ),
						.wr_en        ( write_en    ),
						.rd_en        ( read_en     ),
						.addr         ( tim_paddr   ),
						.pwdata       ( tim_pwdata  ),
						.cnt          ( count       ),
						.dbg_mode     ( dbg_mode    ),
                              .pstrb        ( tim_pstrb   ),
						.rdata        ( tim_prdata  ),
						.div_en       ( div_en      ),					
						.div_val      ( div_val     ),
						.halt_req     ( halt_req	   ), 
  						.timer_en     ( timer_en_tmp),
                              .timer_en_out ( timer_en_out),
						.wr_sel       ( wr_sel      ),
						.pslverr      ( tim_pslverr ),
						.tim_int      ( tim_int     ),
						.wdt          ( wdta        )
					);

		counter_control u_cnt_ctrl (	
			                         .sys_clk   ( sys_clk      ),
     		                         .sys_rst_n ( sys_rst_n    ),
		                              .div_en    ( div_en       ),    
          		                    .div_val   ( div_val      ),
                    		          .halt_req  ( halt_req     ),
                             			.timer_en  ( timer_en_tmp ),
								.cnt_en    ( count_en     )
							);
		counter u_counter (
                                        .sys_clk   ( sys_clk      ),
                                        .sys_rst_n ( sys_rst_n    ),
                                        .cnt_en    ( count_en     ),
		                              .wr_sel    ( wr_sel       ),
                                        .pstrb     ( tim_pstrb    ),
		                              .wdt       ( wdta         ),
                                        .timer_en  ( timer_en_out ),
								.cnt       ( count        )
						);
endmodule
	
									
