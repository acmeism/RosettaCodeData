/// @Author: Alexandre Felipe (o.alexandre.felipe@gmail.com)
/// @Date: 2018-Jan-25
///
class fft_definition_checker #(
  parameter LOG2_NS = 3,
  parameter NS = 1<<LOG2_NS,
  parameter NB = 10);
    rand logic [NB:0] x_bits[0:NS-1][1:0];
    static real TWO_PI = 2.0*math_pkg::atan2(0.0, -1.0);
    real w[0:NS-1][1:0];
    function new;
      foreach(w[i]) begin
        w[i][0] = math_pkg::cos(TWO_PI * i / real'(NS));
        w[i][1] =-math_pkg::sin(TWO_PI * i / real'(NS));
      end
    endfunction
    function void post_randomize;
       real x[0:NS-1][1:0];
       real X[0:NS-1][1:0];
       real X_ref[0:NS-1][1:0];
       real errorEnergy;
    begin
      // Convert randomized binary numbers to real (floating point)
      foreach(x_bits[i]) begin
        x[i][0] = x_bits[i][0];
        x[i][1] = x_bits[i][1];
      end

      ////               START THE MAGIC HERE           ////
      fft_fp #(.LOG2_NS(LOG2_NS), .NS(NS))::transform(x, X);
      ////                 END OF THE MAGIC            ////


      /// Calculate X_ref, the discrete Fourier transform by the definition ///
      foreach(X_ref[k]) begin
        X_ref[k] = '{0.0, 0.0};
        foreach(x[i]) begin
          X_ref[k][0] = X_ref[k][0] + x[i][0] * w[(i*k) % NS][0] - x[i][1] * w[(i*k) % NS][1];
          X_ref[k][1] = X_ref[k][1] + x[i][0] * w[(i*k) % NS][1] + x[i][1] * w[(i*k) % NS][0];
        end
      end

      // Measure the error
      errorEnergy = 0.0;
      foreach(X[k]) begin
        errorEnergy = errorEnergy + (X_ref[k][0] - X[k][0]) * (X_ref[k][0] - X[k][0]);
        errorEnergy = errorEnergy + (X_ref[k][1] - X[k][1]) * (X_ref[k][1] - X[k][1]);
      end
      $display("FFT of %d integers %d bits (error @ %g)", NS, NB, errorEnergy / real'(NS));
    end
    endfunction
endclass
