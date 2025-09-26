task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 1: REGISTER TEST--------------------------");
          $display("====================================================================");
          $display("-----------------------Read default value--------------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          read_compare(ADDR_TCR, 32'h100);
          read_compare(ADDR_TDR0, 32'h00);
          read_compare(ADDR_TDR1, 32'h00);
          read_compare(ADDR_TCMP0, 32'hFFFF_FFFF);
          read_compare(ADDR_TCMP1, 32'hFFFF_FFFF);
          read_compare(ADDR_TIER, 32'h00);
          read_compare(ADDR_TISR, 32'h00);
          read_compare(ADDR_THCSR, 32'h00);     
     end
endtask

