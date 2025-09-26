task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 2: CONTROL MODE---------------------------");
          $display("====================================================================");
          $display("----------------------Count from 0, divide by 128-------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TCR, 32'h703, 4'b1111, 0); 
          repeat (1000) @(posedge sys_clk);
          #0.5;
          read_compare(ADDR_TDR1, 32'h00);
          read_compare(ADDR_TDR0, 32'h7);
     end 
endtask

