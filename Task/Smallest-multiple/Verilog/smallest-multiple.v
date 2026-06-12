module main;
    integer temp, smalmul, lim;

  initial begin
    temp = 2*3*5*7*11*13*17*19;
    smalmul = temp;
    lim = 1;

    while (lim <= 20) begin
	lim = lim + 1;
	while (smalmul % lim != 0) begin
          lim = 1;
          smalmul = smalmul + temp;
        end
    end

      $display(smalmul);
      $finish ;
    end
endmodule
