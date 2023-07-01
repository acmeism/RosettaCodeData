/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date: 2018-Jan-25
///
module fft_test_by_definition;
  genvar LOG2_NS;
  generate for(LOG2_NS = 3; LOG2_NS < 7; LOG2_NS = LOG2_NS + 1) begin
    initial begin
      fft_definition_checker #(.NB(10), .LOG2_NS(LOG2_NS), .NS(1<<LOG2_NS)) chkInst;
      chkInst = new;
      repeat(5) assert(chkInst.randomize()); // randomize and check the outputs
    end
  end
  endgenerate
endmodule
