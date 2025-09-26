task run_test();
     begin
          $display("====================================================================");
          $display("-------------------TEST CASE 4: INTERRUPT---------------------------");
          $display("====================================================================");
          $display("----------------------Check overflow occurred-----------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TIER, 32'h01, 4'b0001, 0);
          write(ADDR_TDR0, 32'hFFFF_FFF1, 4'b1111, 0);
          write(ADDR_TDR1, 32'hFFFF_FFFF, 4'b1111, 0); 
          write(ADDR_TCR, 32'h01, 4'b1111, 0); 
          repeat (12) @(posedge sys_clk);
          #0.5;
          if (tim_int)
               $display("%0t: The tim_int signal actives correctly", $time);
          else
               $display("%0t: The tim_int signal actives incorrectly", $time);
     end 
endtask

