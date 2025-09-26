task run_test();
     begin
          $display("====================================================================");
          $display("-----------------------TEST CASE 5: ERROR---------------------------");
          $display("====================================================================");
          $display("--------------------------Change div_en-----------------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5; 
          sys_rst_n = 1;
          write(ADDR_TCR, 32'b10, 4'b1111, 0);
          write(ADDR_TCR, 32'b11, 4'b1111, 0);
          write(ADDR_TCR, 32'b01, 4'b1111, 0);
          if (tim_pslverr)
               $display("%0t: The tim_pslverr signal actives correctly", $time);
          else
               $display("%0t: The tim_pslverr signal actives incorrectly", $time);
     end 
endtask

