task run_test();
     begin
          $display("====================================================================");
          $display("--------------------TEST CASE 6: APB PROTOCOL-----------------------");
          $display("====================================================================");
          sys_rst_n = 0;
          repeat (2) @(posedge sys_clk);
          #0.5;
          sys_rst_n = 1;
          @(posedge sys_clk);
          tim_psel    = 1;
          tim_penable = 0;
          tim_pwrite  = 0;
          @(posedge sys_clk);
          #0.5;
          if (!tim_pready)
               $display("The module operates correctly according to the APB protocol");
          else
               $display("The module operates incorrectly according to the APB protocol");
          repeat (2) @(posedge sys_clk);
          #0.5;
          tim_psel    = 1;
          tim_penable = 1;
          tim_pwrite  = 0;
          @(posedge sys_clk);
          #0.5;
          if (tim_pready)
               $display("The module operates correctly according to the APB protocol");
          else
               $display("The module operates incorrectly according to the APB protocol");
          repeat (2) @(posedge sys_clk);
          #0.5;
          tim_psel    = 1;
          tim_penable = 0;
          tim_pwrite  = 1;
          @(posedge sys_clk);
          #0.5;
          if (!tim_pready)
               $display("The module operates correctly according to the APB protocol");
          else
               $display("The module operates incorrectly according to the APB protocol");
          repeat (2) @(posedge sys_clk);
          #0.5;
          tim_psel    = 1;
          tim_penable = 1;
          tim_pwrite  = 1;
          @(posedge sys_clk);
          #0.5;
          if (tim_pready)
               $display("The module operates correctly according to the APB protocol");
          else
               $display("The module operates incorrectly according to the APB protocol");
     end
endtask



