# 20250609 Raku programming solution

sub hypot(\x, \y) { sqrt(x² + y²) }

# The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
sub ciede_2000(\L1, \A1, \B1, \L2, \A2, \B2) {
   # Kl, Kc, Kh are parametric factors to be adjusted according to
   # different viewing parameters such as textures, backgrounds...
   my (\Kl, \Kc, \Kh) = 1.0 xx 3;

   my $n = ((hypot(A1, B1) + hypot(A2, B2)) * 0.5)⁷;
   $n = 1.0 + 0.5 * (1.0 - sqrt($n / ($n + 6103515625.0)));

   # hypot calculates the Euclidean distance while avoiding overflow/underflow.
   my (\C1, \C2) = ( [A1 * $n, B1], [A2 * $n, B2] ).map: { hypot |$_ };

   # atan2 is preferred over atan because it accurately computes the angle of
   # a point (x, y) in all quadrants, handling the signs of both coordinates.
   my \H1 = $ = atan2(B1, A1 * $n);
   my \H2 = $ = atan2(B2, A2 * $n);

   if H1 < 0.0 { H1 += 2.0 * π }
   if H2 < 0.0 { H2 += 2.0 * π }

   $n = abs(H2 - H1);

   # Cross-implementation consistent rounding.
   $n = π if π - 1e-14 < $n < π + 1e-14;

   # When the hue angles lie in different quadrants, the straightforward
   # average can produce a mean that incorrectly suggests a hue angle in
   # the wrong quadrant, the next lines handle this issue.
   my \Hm = $ = (H1 + H2) * 0.5;
   my \Hd = $ = (H2 - H1) * 0.5;

   if π < $n {
      0.0 < Hd ?? ( Hd -= π ) !! Hd += π;
      Hm += π;
   }

   my \p = 36.0 * Hm - 55.0 * π;
   $n = ((C1 + C2) * 0.5)⁷;

   # The hue rotation correction term is designed to account for the
   # non-linear behavior of hue differences in the blue region.
   my \Rt = -2.0 * sqrt( $n/($n+6103515625.0)) * sin(π/3.0*exp(p²/(-25.0*π²)) );
   $n = ((L1 + L2) * 0.5 - 50.0)²;

   # Lightness.
   my \l = (L2 - L1) / (Kl * (1.0 + 0.015 * $n / sqrt(20.0 + $n)));

   # These coefficients adjust the impact of different harmonic
   # components on the hue difference calculation.
   my \t = 1.0 + 0.24*sin(2.0*Hm + π*0.5) + 0.32*sin(3.0*Hm + 8.0*π/15.0) -
           0.17*sin(Hm + π/3.0) - 0.20*sin(4.0 * Hm + 3.0*π/20.0);
   $n = C1 + C2;

   # Hue.
   my \h = 2.0 * sqrt(C1 * C2) * sin(Hd) / (Kh * (1.0 + 0.0075 * $n * t));

   # Chroma.
   my \c = (C2 - C1) / (Kc * (1.0 + 0.0225 * $n));

   # Returning the square root ensures that the result represents
   # the "true" geometric distance in the color space.
   return sqrt(l² + h² + c² + c * h * Rt)
}

say "   L1     a1     b1     L2     a2     b2        ΔE2000";
say "------------------------------------------------------------";

for [
   [73.0, 49.0, 39.4, 73.0, 49.0, 39.4],
   [30.0, -41.0, -119.1, 30.0, -41.0, -119.0],
   [79.0, -117.0, -100.4, 79.5, -117.0, -100.0],
   [15.0, -55.0, 6.7, 14.0, -55.0, 7.0],
   [83.0, 98.0, -59.5, 85.2, 98.0, -59.5],
   [59.0, -11.0, -95.0, 56.3, -11.0, -95.0],
   [74.0, -1.0, 68.6, 81.0, -1.0, 69.0],
   [46.4, 125.0, 6.0, 40.0, 125.0, 6.0],
   [18.0, -5.0, 68.0, 20.0, 5.0, 82.0],
   [35.5, -99.0, 109.0, 25.0, -99.0, 109.0],
   [59.0, 77.0, 41.5, 63.3, 77.0, 12.4],
   [40.0, -92.0, 7.7, 58.0, -92.0, -8.0],
   [49.0, -9.0, -74.5, 51.1, 31.0, 16.0],
   [88.0, -124.0, 56.0, 97.0, 62.0, -28.0],
   [98.0, 75.7, 11.0, 3.0, -62.0, 11.0],
] { printf "%6.1f " x 6 ~ "%14.10f\n", $_[^6], ciede_2000 |$_[^6] }
