task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 3: DEFAULT MODE---------------------------");
          $display("====================================================================");
          $display("-----------------Count from random, no divide-----------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TDR0, 32'hFFFF, 4'b1111, 0);
          write(ADDR_TDR1, 32'hFFFF, 4'b1111, 0);
          write(ADDR_TCR, 32'h01, 4'b1111, 0); 
          repeat (1000) @(posedge sys_clk);
          #0.5;
          read_compare(ADDR_TDR1, 32'hFFFF);
          read_compare(ADDR_TDR0, 32'h1_03ef);
     end 
endtask

