task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 1: REGISTER TEST--------------------------");
          $display("====================================================================");
          $display("-----------------Check interrupt in TISR register-------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TIER, 32'h01, 4'b01, 0);
          write(ADDR_TCMP0, 32'hFFFF_FFF0, 4'b1111, 0);
          write(ADDR_TCR, 32'h01, 4'b0101, 0); 
          @(posedge tim_int);
          #0.5;
          write(ADDR_TISR, 32'h00, 4'b1111, 0);
          read_compare(ADDR_TISR, 32'h01);
          write(ADDR_TISR, 32'h01, 4'b1111, 0); 
          read_compare(ADDR_TISR, 32'h00);
     end
endtask



