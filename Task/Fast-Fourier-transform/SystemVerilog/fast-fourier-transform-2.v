/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date: 2018-Jan-25
///
module fft_model_sanity;
  initial begin
    real x[0:7][1:0]; // input data
    real X[0:7][1:0]; // transformed data
    real y[0:7][1:0]; // inverted data
    for(int i = 0; i < 8; i = i + 1)x[i][0] = 0.0;
    for(int i = 4; i < 8; i = i + 1)x[i][1] = 0.0;
    for(int i = 0; i < 4; i = i + 1)x[i][0] = 1.0;
    fft_fp #(.LOG2_NS(3), .NS(8))::transform(x, X);
    $display("Direct FFT");
    for(int i = 0; i < 8; i = i + 1) begin
      $display("(%f, %f)", X[i][0], X[i][1]);
    end
    $display("Inverse FFT");
    fft_fp #(.LOG2_NS(3), .NS(8))::invert(X, y);
    for(int i = 0; i < 8; i = i + 1) begin
      $display("(%f, %f)", y[i][0], y[i][1]);
    end
  end
endmodule
