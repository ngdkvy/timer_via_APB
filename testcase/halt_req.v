task run_test();
     begin
          $display("====================================================================");
          $display("---------------------TEST CASE 6: HALT_REQ--------------------------");
          $display("====================================================================");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5;
          sys_rst_n = 1;
          write(ADDR_THCSR, 32'h01, 4'b0001, 0);
          write(ADDR_TCR, 32'h00, 4'b1111, 0);
          write(ADDR_TCR, 32'h01, 4'b1111, 1);
          write(ADDR_TCR, 32'h01, 4'b1111, 0);
          write(ADDR_THCSR, 32'h00, 4'b0001, 0);
          write(ADDR_THCSR, 32'h01, 4'b0001, 1);
    end
endtask


