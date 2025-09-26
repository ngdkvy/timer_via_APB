`timescale 1ns/1ns

module test_bench;
	reg        sys_clk      ;   
     reg        sys_rst_n    ;   
     reg        tim_psel     ;   
     reg        tim_pwrite   ;   
     reg        tim_penable  ;
     reg [11:0] tim_paddr    ;   
     reg [31:0] tim_pwdata   ;   
     reg [3:0]  tim_pstrb    ;   
     wire        tim_pready  ;   
     reg        dbg_mode     ;   
     wire [31:0] tim_prdata  ;   
     wire        tim_pslverr ;
     wire        tim_int     ;

	parameter ADDR_TCR     = 12'h00;
	parameter ADDR_TDR0    = 12'h04;
	parameter ADDR_TDR1    = 12'h08;
	parameter ADDR_TCMP0   = 12'h0C;
	parameter ADDR_TCMP1   = 12'h10;
	parameter ADDR_TIER    = 12'h14;
	parameter ADDR_TISR    = 12'h18;
	parameter ADDR_THCSR   = 12'h1C;

	timer_top u_dut(
					.sys_clk     ( sys_clk     ),
					.sys_rst_n   ( sys_rst_n   ),
					.tim_psel    ( tim_psel    ),
					.tim_pwrite  ( tim_pwrite  ),
					.tim_penable ( tim_penable ),
					.tim_paddr   ( tim_paddr   ),
					.tim_pwdata  ( tim_pwdata  ),
					.tim_pstrb   ( tim_pstrb   ),
					.tim_pready  ( tim_pready  ),
					.dbg_mode    ( dbg_mode    ),
					.tim_prdata  ( tim_prdata  ),
					.tim_pslverr ( tim_pslverr ),
					.tim_int     ( tim_int     )
				);
	`include "../sim/run_test.v"
     initial begin
          sys_clk = 0;
          forever #5 sys_clk = ~sys_clk;
     end 
     initial begin
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
     end 
	initial begin
		tim_psel    = 0;
		tim_pwrite  = 0;
		tim_penable = 0;
		tim_paddr   = 32'h0;
		tim_pwdata  = 32'h0;
		tim_pstrb   = 4'b0;
		dbg_mode    = 0;
          @(posedge sys_rst_n);
          #0.5;
		run_test();
	end
	initial begin
		#100000;
     	$finish;
	end
     task write (input [31:0] addr, input [31:0] data, input [3:0] strb, input debug_mode);
          begin
               @(posedge sys_clk);
               #1;
			tim_paddr  = addr;
			tim_pwrite = 1;
			tim_psel   = 1;
			tim_pwdata = data;
			tim_pstrb  = strb;
			dbg_mode   = debug_mode;
			$display("%0t Register: %h. Data: 32'h%h. Pstrb: 4'b%b", $time, addr, data, strb);
               @(posedge sys_clk);
               #1;
			tim_penable = 1;
			repeat (2) @(posedge sys_clk);
			#1;
               tim_paddr  = 32'h00;
               tim_pwrite = 0;
               tim_psel   = 0;
               tim_pwdata = 0;
               tim_pstrb  = 4'b0;
			tim_penable = 0;
          end
     endtask
     task read_compare (input [31:0] addr, input [31:0] rdata);
          begin
               @(posedge sys_clk);
               #0.5;
               tim_paddr   = addr;
               tim_pwrite  = 0;
               tim_psel    = 1;
               tim_pstrb   = 4'b1111;
               @(posedge sys_clk);
               #0.5;
               tim_penable = 1;
               #0.5;
               if (tim_prdata == rdata)
                    $display("%0t: Register: %2h. Data is matching", $time, addr);
               else 
                    $display("%0t: Register: %2h. Data is not matching. Exp: 32'h%h. Act: 32'h%h", $time, addr, rdata, tim_prdata);
               repeat (2) @(posedge sys_clk);
               #0.5;
               tim_paddr   = 32'h00;
               tim_pwrite  = 0;
               tim_psel    = 0;
               tim_pwdata  = 0;
               tim_pstrb   = 4'b0;
               tim_penable = 0;
          end
     endtask
	task write_pslverr (input [31:0] addr, input [31:0] data, input [3:0] strb, input debug_mode);
     	begin
          	@(posedge sys_clk);
          	#1;
          	tim_paddr  = addr;
          	tim_pwrite = 1;
          	tim_psel   = 1;
          	tim_pwdata = data;
          	tim_pstrb  = strb;
          	dbg_mode   = debug_mode;
          	@(posedge sys_clk);
          	#1;
          	tim_penable = 1;
          	@(posedge sys_clk);
          	#1;
          	if (tim_pslverr)
               	$display("%0t: WRITE - the tim_pslverr signal actives correctly", $time);
          	else begin
               	$display("%0t: WRITE - the tim_pslverr signal doesn't active correctly", $time);
               	#100;
               	$finish;
          	end
          	@(posedge sys_clk);
          	#1;
          	tim_paddr  = 32'h00;
          	tim_pwrite = 0;
          	tim_psel   = 0;
          	tim_pwdata = 0;
          	tim_pstrb  = 4'b0;
          	tim_penable = 0;
     	end 
	endtask
endmodule

