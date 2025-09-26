task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 2: CONTROL MODE---------------------------");
          $display("====================================================================");
          $display("---------------Count from random, divide by 256---------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TDR0, 32'hFFFF_FFA0, 4'b1111, 0); 
          write(ADDR_TCR, 32'h803, 4'b1111, 0); 
          repeat (1000) @(posedge sys_clk);
          #0.5;
          read_compare(ADDR_TDR1, 32'h00);
          read_compare(ADDR_TDR0, 32'hFFFF_FFA3);
     end 
endtask

