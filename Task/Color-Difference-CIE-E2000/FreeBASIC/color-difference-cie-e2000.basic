' The classic CIE ΔE2000 implementation, which operates on two L*a*b* colors, and returns their difference.
Public Function ciede_2000(l_1 As Double, a_1 As Double, b_1 As Double, l_2 As Double, a_2 As Double, b_2 As Double) As Double
    ' Michel Leonard uses VBA with the CIEDE2000 color-difference formula.
    ' k_l, k_c, k_h are parametric factors to be adjusted according to
    ' different viewing parameters such as textures, backgrounds...
    Const PI = 3.14159265358979323846264338328, k_l = 1.0, k_c = 1.0, k_h = 1.0
    Dim n As Double, c_1 As Double, c_2 As Double, h_1 As Double, h_2 As Double
    Dim h_m As Double, h_d As Double, p As Double, r_t As Double, l As Double
    Dim t As Double, h As Double, c As Double
    n = (Sqr(a_1 * a_1 + b_1 * b_1) + Sqr(a_2 * a_2 + b_2 * b_2)) * 0.5
    n = n * n * n * n * n * n * n
    ' GitHub Project :
    ' https://github.com/michel-leonard/ciede2000-color-matching
    n = 1.0 + 0.5 * (1.0 - Sqr(n / (n + 6103515625.0)))
    ' Since hypot is not available, sqrt is used here to calculate the
    ' Euclidean distance, without avoiding overflow/underflow.
    c_1 = Sqr(a_1 * a_1 * n * n + b_1 * b_1)
    c_2 = Sqr(a_2 * a_2 * n * n + b_2 * b_2)
    ' Using 20 lines to simulate atan2, as VBA does not have this built-in.
    c = a_1 * n
    If 0 < c Then
        h_1 = Atn(b_1 / c)
    Elseif c < 0 Then
        h_1 = Atn(b_1 / c) + PI * Sgn(b_1)
        If b_1 = 0 Then h_1 = h_1 + PI
    Else
        h_1 = PI * 0.5 * Sgn(b_1)
    End If
    c = a_2 * n
    If 0 < c Then
        h_2 = Atn(b_2 / c)
    Elseif c < 0 Then
        h_2 = Atn(b_2 / c) + PI * Sgn(b_2)
        If b_2 = 0 Then h_2 = h_2 + PI
    Else
        h_2 = PI * 0.5 * Sgn(b_2)
    End If
    ' The atan2 polyfill is complete.
    If h_1 < 0.0 Then h_1 = h_1 + 2.0 * PI
    If h_2 < 0.0 Then h_2 = h_2 + 2.0 * PI
    n = Abs(h_2 - h_1)
    ' Cross-implementation consistent rounding.
    If PI - 1E-14 < n And n < PI + 1E-14 Then n = PI
    ' When the hue angles lie in different quadrants, the straightforward
    ' average can produce a mean that incorrectly suggests a hue angle in
    ' the wrong quadrant, the next lines handle this issue.
    h_m = (h_1 + h_2) * 0.5
    h_d = (h_2 - h_1) * 0.5
    If PI < n Then
        If 0.0 < h_d Then h_d = h_d - PI Else h_d = h_d + PI
        h_m = h_m + PI
    End If
    p = 36.0 * h_m - 55.0 * PI
    n = (c_1 + c_2) * 0.5
    n = n * n * n * n * n * n * n
    ' The hue rotation correction term is designed to account for the
    ' non-linear behavior of hue differences in the blue region.
    r_t = -2.0 * Sqr(n / (n + 6103515625.0)) _
    * Sin(PI / 3.0 * Exp(p * p / (-25.0 * PI * PI)))
    n = (l_1 + l_2) * 0.5
    n = (n - 50.0) * (n - 50.0)
    ' Lightness.
    l = (l_2 - l_1) / (k_l * (1.0 + 0.015 * n / Sqr(20.0 + n)))
    ' These coefficients adjust the impact of different harmonic
    ' components on the hue difference calculation.
    t = 1.0		+ 0.24 * Sin(2.0 * h_m + PI * 0.5) _
    + 0.32 * Sin(3.0 * h_m + 8.0 * PI / 15.0) _
    - 0.17 * Sin(h_m + PI / 3.0) _
    - 0.2 * Sin(4.0 * h_m + 3.0 * PI / 20.0)
    n = c_1 + c_2
    ' Hue.
    h = 2.0 * Sqr(c_1 * c_2) * Sin(h_d) / (k_h * (1.0 + 0.0075 * n * t))
    ' Chroma.
    c = (c_2 - c_1) / (k_c * (1.0 + 0.0225 * n))
    ' Returning the square root ensures that the result represents
    ' the "true" geometric distance in the color space.
    ciede_2000 = Sqr(l * l + h * h + c * c + c * h * r_t)
End Function

' Main program
Dim i As Integer
Dim res As Double
Dim tests(14, 5) As Double => { _
{73.0, 49.0, 39.4, 73.0, 49.0, 39.4}, _
{30.0, -41.0, -119.1, 30.0, -41.0, -119.0}, _
{79.0, -117.0, -100.4, 79.5, -117.0, -100.0}, _
{15.0, -55.0, 6.7, 14.0, -55.0, 7.0}, _
{83.0, 98.0, -59.5, 85.2, 98.0, -59.5}, _
{59.0, -11.0, -95.0, 56.3, -11.0, -95.0}, _
{74.0, -1.0, 68.6, 81.0, -1.0, 69.0}, _
{46.4, 125.0, 6.0, 40.0, 125.0, 6.0}, _
{18.0, -5.0, 68.0, 20.0, 5.0, 82.0}, _
{35.5, -99.0, 109.0, 25.0, -99.0, 109.0}, _
{59.0, 77.0, 41.5, 63.3, 77.0, 12.4}, _
{40.0, -92.0, 7.7, 58.0, -92.0, -8.0}, _
{49.0, -9.0, -74.5, 51.1, 31.0, 16.0}, _
{88.0, -124.0, 56.0, 97.0, 62.0, -28.0}, _
{98.0, 75.7, 11.0, 3.0, -62.0, 11.0} }

Print "   L1 	    a1 	    b1     L2     a2 	  b2       ΔE2000"
Print String (60, "-")

For i = 0 To Ubound(tests)
    res = ciede_2000(tests(i, 0), tests(i, 1), tests(i, 2), tests(i, 3), tests(i, 4), tests(i, 5))
    Print Using "####.#   ####.#  ####.# ####.# ####.#  ####.# ###.##########"; tests(i, 0); tests(i, 1); tests(i, 2); tests(i, 3); tests(i, 4); tests(i, 5); res
Next i

Sleep
