task run_test();
     begin
          $display("====================================================================");
          $display("----------------TEST CASE 1: REGISTER TEST--------------------------");
          $display("====================================================================");
          $display("-------------------------Reserved register--------------------------");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5;
          sys_rst_n = 1;
          write(12'h1D,  32'hFFFF_FFFF, 4'b1111, 0);
          write(12'hff,  32'hFFFF_FFFF, 4'b1111, 0);
          write(12'h1f,  32'hFFFF_FFFF, 4'b1111, 0);
          read_compare(12'h1D, 32'h00);
          read_compare(12'hff, 32'h00);
          read_compare(12'h1f, 32'h00);
     end
endtask
