/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date: 2018-Jan-25
///

package math_pkg;
  // Inspired by the post
  // https://community.cadence.com/cadence_blogs_8/b/fv/posts/create-a-sine-wave-generator-using-systemverilog
  // import functions directly from C library
  //import dpi task      C Name = SV function name
  import "DPI" pure function real cos (input real rTheta);
  import "DPI" pure function real sin(input real y);
  import "DPI" pure function real atan2(input real y, input real x);
endpackage : math_pkg


// Encapsulates the functions in a parameterized class
// The FFT is implemented using floating point arithmetic (systemverilog real)
// Complex values are represented as a real vector [1:0], the index 0 is the real part
// and the index 1 is the imaginary part.
class fft_fp #(
  parameter LOG2_NS = 7,
  parameter NS = 1<<LOG2_NS
);


  static function void bit_reverse_order(input real buffer_in[0:NS-1][1:0], output real buffer[0:NS-1][1:0]);
  begin
    for(reg [LOG2_NS:0] j = 0; j < NS; j = j + 1) begin
      reg [LOG2_NS-1:0] ij;
      ij = {<<{j[LOG2_NS-1:0]}}; // Right to left streaming
      buffer[j][0] = buffer_in[ij][0];
      buffer[j][1] = buffer_in[ij][1];
    end
  end
  endfunction
  // SystemVerilog FFT implementation translated from Java
  static function void transform(input real buffer_in[0:NS-1][1:0], output real buffer[0:NS-1][1:0]);
  begin
    static real pi = math_pkg::atan2(0.0, -1.0);
    bit_reverse_order(buffer_in, buffer);
    for(int N = 2; N <= NS; N = N << 1) begin
      for(int i = 0; i < NS; i = i + N) begin
        for(int k =0; k < N/2; k = k + 1) begin
          int evenIndex;
          int oddIndex;
          real theta;
          real wr, wi;
          real zr, zi;
          evenIndex = i + k;
          oddIndex  = i + k + (N/2);
          theta     = (-2.0*pi*k/real'(N));
          // Call to the DPI C functions
          // (it could be memorized to save some calls but I dont think it worthes)
          // w = exp(-2j*pi*k/N);
          wr = math_pkg::cos(theta);
          wi = math_pkg::sin(theta);
          // x = w * buffer[oddIndex]
          zr = buffer[oddIndex][0] * wr - buffer[oddIndex][1] * wi;
          zi = buffer[oddIndex][0] * wi + buffer[oddIndex][1] * wr;
          // update oddIndex before evenIndex
          buffer[ oddIndex][0] = buffer[evenIndex][0] - zr;
          buffer[ oddIndex][1] = buffer[evenIndex][1] - zi;
          // because evenIndex is in the rhs
          buffer[evenIndex][0] = buffer[evenIndex][0] + zr;
          buffer[evenIndex][1] = buffer[evenIndex][1] + zi;
        end
      end
    end
  end
  endfunction
  // Implements the inverse FFT using the following identity
  // ifft(x) = conj(fft(conj(x))/NS;
  static function void invert(input real buffer_in[0:NS-1][1:0], output real buffer[0:NS-1][1:0]);
    real tmp[0:NS-1][1:0];
  begin
    // Conjugates the input
    for(int i = 0; i < NS; i = i + 1) begin
      tmp[i][0] = buffer_in[i][0];
      tmp[i][1] = -buffer_in[i][1];
    end
    transform(tmp, buffer);
    // Conjugate and scale the output
    for(int i = 0; i < NS; i = i + 1) begin
      buffer[i][0] = buffer[i][0]/NS;
      buffer[i][1] = -buffer[i][1]/NS;
    end
  end
  endfunction

endclass
