module apb_slave (
	input  wire        pclk      ,
	input  wire        preset_n  ,
	input  wire        psel      ,
	input  wire        pwrite    ,
	input  wire        penable   ,
	output wire        pready    ,
	output wire        wr_en     ,
	output wire        rd_en     
);

reg        pready_r   ;

assign wr_en = psel & pwrite & penable;
assign rd_en = psel & !pwrite & penable           ;


//pready
//after 1 cycle when receiving penable and psel (1,1) then pready = 1
assign pready  = (!psel && !penable) ? 0 : pready_r;

always @(posedge pclk or negedge preset_n) begin
	if (!preset_n)
	begin
		pready_r   <= 0;
	end
	else begin
		if (psel && !penable && !pwrite) begin //read
			pready_r <= 0;
		end
		else if (psel && penable && !pwrite) begin //read
			pready_r <= 1;
		end
		else if (psel && !penable && pwrite) begin //write
			pready_r <= 0;
		end
		else if (psel && penable && pwrite) begin //write
			pready_r <= 1;
		end
		else
			pready_r <=  0;
	end
end
endmodule
