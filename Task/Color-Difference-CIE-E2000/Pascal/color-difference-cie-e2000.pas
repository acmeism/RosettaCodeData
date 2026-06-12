Program Test_ciede_2000;
uses
  sysutils,Math;
type
  tColorData =  record
                  l1,a1,b1,l2,a2,b2:Double;
                end;
const
  mytests : array[0..14] of tColorData = (
  (l1: 73.0;a1:  49.0;b1:  39.4;l2:  73.0;a2:  49.0;b2:  39.4),
  (l1: 30.0;a1:- 41.0;b1:-119.1;l2:  30.0;a2:- 41.0;b2:-119.0),
  (l1: 79.0;a1:-117.0;b1:-100.4;l2:  79.5;a2:-117.0;b2:-100.0),
  (l1: 15.0;a1:- 55.0;b1:   6.7;l2:  14.0;a2:- 55.0;b2:   7.0),
  (l1: 83.0;a1:  98.0;b1:- 59.5;l2:  85.2;a2:  98.0;b2:- 59.5),
  (l1: 59.0;a1:- 11.0;b1:- 95.0;l2:  56.3;a2:- 11.0;b2:- 95.0),
  (l1: 74.0;a1:-  1.0;b1:- 68.6;l2:  81.0;a2:-  1.0;b2:- 69.0),
  (l1: 46.4;a1: 125.0;b1:   6.0;l2:  40.0;a2: 125.0;b2:   6.0),
  (l1: 18.0;a1:-  5.0;b1:  68.0;l2:  20.0;a2:   5.0;b2:  82.0),
  (l1: 35.5;a1:- 99.0;b1: 109.0;l2:  25.0;a2:- 99.0;b2: 109.0),
  (l1: 59.0;a1:  77.0;b1:  41.5;l2:  63.3;a2:  77.0;b2:  12.4),
  (l1: 40.0;a1:- 92.0;b1:   7.7;l2:  58.0;a2:- 92.0;b2:-  8.0),
  (l1: 49.0;a1:-  9.0;b1:- 74.5;l2:  51.1;a2:  31.0;b2:  16.0),
  (l1: 88.0;a1:-124.0;b1:  56.0;l2:  97.0;a2:  62.0;b2:- 28.0),
  (l1: 98.0;a1:  75.7;b1:  11.0;l2:   3.0;a2:- 62.0;b2:  11.0)
);

// The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
// "l" ranges from 0 to 100, while "a" and "b" are unbounded and commonly clamped to the range of -128 to 127.
function ciede_2000(dat:tColorData): Double;
var
  k_l, k_c, k_h, n, c_1, c_2, h_1, h_2, h_m, h_d, p, r_t, l, t, h, c: Double;
begin
  // Michel Leonard uses Pascal with the CIEDE2000 color-difference formula.
  // k_l, k_c, k_h are parametric factors to be adjusted according to
  // different viewing parameters such as textures, backgrounds...
  k_l := 1.0;
  k_c := 1.0;
  k_h := 1.0;
  with dat do
  begin
    n := (sqrt(sqr(a1) + sqr(b1)) + sqrt(sqr(a2)+ sqr(b2))) * 0.5;
    n := power(n,7);
    // A factor involving chroma raised to the power of 7 designed to make
    // the influence of chroma on the total color difference more accurate.
    n := 1.0 + 0.5 * (1.0 - sqrt(n / (n + 6103515625.0)));
    // Since hypot is not available, sqrt is used here to calculate the
    // Euclidean distance, without avoiding overflow/underflow.
    c_1 := sqrt(sqr(a1 * n) + sqr(b1));
    c_2 := sqrt(sqr(a2 * n) + sqr(b2));
    // atan2 is preferred over atan because it accurately computes the angle of
    // a point (x, y) in all quadrants, handling the signs of both coordinates.
    h_1 := arctan2(b1, a1 * n);
    h_2 := arctan2(b2, a2 * n);
  end;
  // GitHub Project : https://github.com/michel-leonard/ciede2000-color-matching
  if h_1 < 0.0 then
    h_1 += 2.0 * Pi;
  if h_2 < 0.0 then
    h_2 += 2.0 * Pi;
  n := abs(h_2 - h_1);
  // Cross-implementation consistent rounding.
  if abs(Pi - n) < 1E-14 then
    n := Pi;
  // When the hue angles lie in different quadrants, the straightforward
  // average can produce a mean that incorrectly suggests a hue angle in
  // the wrong quadrant, the next lines handle this issue.
  h_m := (h_1 + h_2) * 0.5;
  h_d := (h_2 - h_1) * 0.5;
  if Pi < n then
  begin
    if 0.0 < h_d then
      h_d -= Pi
    else
      h_d += Pi;
    h_m += Pi;
  end;
  p := 36.0 * h_m - 55.0 * Pi;
  n := (c_1 + c_2) * 0.5;
  n := n * n * n * n * n * n * n;
  // The hue rotation correction term is designed to account for the
  // non-linear behavior of hue differences in the blue region.
  r_t := -2.0 * sqrt(n / (n + 6103515625.0))
      * sin(Pi / 3.0 * exp(p * p / (-25.0 * Pi * Pi)));
  with dat do
  Begin
    n :=  (l1 + l2) * 0.5;
    n := (n - 50.0) * (n - 50.0);
    // Lightness.
    l := (l2 - l1) / (k_l * (1.0 + 0.015 * n / sqrt(20.0 + n)));
  end;
  // These coefficients adjust the impact of different harmonic
  // components on the hue difference calculation.
  t := 1.0  + 0.24 * sin(2.0 * h_m + Pi / 2.0)
      + 0.32 * sin(3.0 * h_m + 8.0 * Pi / 15.0)
      - 0.17 * sin(h_m + Pi / 3.0)
      - 0.20 * sin(4.0 * h_m + 3.0 * Pi / 20.0);
  n := c_1 + c_2;
  // Hue.
  h := 2.0 * sqrt(c_1 * c_2) * sin(h_d) / (k_h * (1.0 + 0.0075 * n * t));
  // Chroma.
  c := (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n));
  // Returning the square root ensures that the result reflects the actual geometric
  // distance within the color space, which ranges from 0 to approximately 185.
  Exit(sqrt(l * l + h * h + c * c + c * h * r_t));
end;

var
  t : tColorData;
Begin
  writeln('   L1      a1      b1     L2     a2    b2       ΔE2000');
  writeln('------------------------------------------------------------');
  for t in mytests do
    with t do
      writeln(Format('%6.1f   %6.1f  %6.1f %6.1f %6.1f  %6.1f %14.10f',
               [l1,a1,b1,l2,a2,b2,ciede_2000(t)]));
end.
