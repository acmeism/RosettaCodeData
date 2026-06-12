type
  Coeffs2 = (float, float, float)
  Coeffs3 = (float, float, float, float)

# Subprogram (1).
func monomialToBernsteinDegree2(monomialCoefficients: Coeffs2): Coeffs2 =
    let (a0, a1, a2) = monomialCoefficients
    result = (a0, a0 + ((1/2) * a1), a0 + a1 + a2)

# Subprogram (2).
func evaluateBernsteinDegree2(bernsteinCoefficients: Coeffs2; t: float): float =
    let (b0, b1, b2) = bernsteinCoefficients
    # de Casteljau’s algorithm.
    let s = 1 - t
    let b01 = (s * b0) + (t * b1)
    let b12 = (s * b1) + (t * b2)
    result = (s * b01) + (t * b12)

# Subprogram (3).
func monomialToBernsteinDegree3(monomialCoefficients: Coeffs3): Coeffs3 =
    let (a0, a1, a2, a3) = monomialCoefficients
    result = (a0, a0 + ((1/3) * a1), a0 + ((2/3) * a1) + ((1/3) * a2), a0 + a1 + a2 + a3)

# Subprogram (4).
func evaluateBernsteinDegree3(bernsteinCoefficients: Coeffs3; t: float): float =
    let (b0, b1, b2, b3) = bernsteinCoefficients
    # de Casteljau’s algorithm.
    let s = 1 - t
    let b01 = (s * b0) + (t * b1)
    let b12 = (s * b1) + (t * b2)
    let b23 = (s * b2) + (t * b3)
    let b012 = (s * b01) + (t * b12)
    let b123 = (s * b12) + (t * b23)
    result = (s * b012) + (t * b123)

# Subprogram (5).
func bernsteinDegree2ToDegree3(bernsteinCoefficients: Coeffs2): Coeffs3 =
    let (b0, b1, b2) = bernstein_coefficients
    result = (b0, ((1/3) * b0) + ((2/3) * b1), ((2/3) * b1) + ((1/3) * b2), b2)

func evaluateMonomialDegree2(monomialCoefficients: Coeffs2; t: float): float =
    let (a0, a1, a2) = monomialCoefficients
    # Horner’s rule.
    result = a0 + (t * (a1 + (t * a2)))

func evaluateMonomialDegree3(monomialCoefficients: Coeffs3; t: float): float =
    let (a0, a1, a2, a3) = monomialCoefficients
    # Horner’s rule.
    result = a0 + (t * (a1 + (t * (a2 + (t * a3)))))

#
# For the following polynomials, use Subprogram (1) to find
# coefficients in the degree-2 Bernstein basis:
#
#   p(x) = 1
#   q(x) = 1 + 2x + 3x²
#
# Display the results.
#
let pmono2 = (1.0, 0.0, 0.0)
let qmono2 = (1.0, 2.0, 3.0)
let pbern2 = monomialToBernsteinDegree2(pmono2)
let qbern2 = monomialToBernsteinDegree2(qmono2)
echo "Subprogram (1) examples:"
echo "  mono ", pmono2, " --> bern ", pbern2
echo "  mono ", qmono2, " --> bern ", qbern2

#
# Use Subprogram (2) to evaluate p(x) and q(x) at x = 0.25, 7.50.
# Display the results. Optionally also display results from evaluating
# in the original monomial basis.
#
echo "Subprogram (2) examples:"
for x in [0.25, 7.50]:
  echo "  p(", x, ") = ", evaluateBernsteinDegree2(pbern2, x),
       " (mono: ", evaluateMonomialDegree2(pmono2, x), ')'
for x in [0.25, 7.50]:
  echo "  q(", x, ") = ", evaluateBernsteinDegree2(qbern2, x),
       " (mono: ", evaluateMonomialDegree2(qmono2, x), ')'

#
# For the following polynomials, use Subprogram (3) to find
# coefficients in the degree-3 Bernstein basis:
#
#   p(x) = 1
#   q(x) = 1 + 2x + 3x²
#   r(x) = 1 + 2x + 3x² + 4x³
#
# Display the results.
#
let pmono3 = (1.0, 0.0, 0.0, 0.0)
let qmono3 = (1.0, 2.0, 3.0, 0.0)
let rmono3 = (1.0, 2.0, 3.0, 4.0)
let pbern3 = monomialToBernsteinDegree3(pmono3)
let qbern3 = monomialToBernsteinDegree3(qmono3)
let rbern3 = monomialToBernsteinDegree3(rmono3)
echo "Subprogram (3) examples:"
echo "  mono ", pmono3, " --> bern ", pbern3
echo "  mono ", qmono3, " --> bern ", qbern3
echo "  mono ", rmono3, " --> bern ", rbern3

#
# Use Subprogram (4) to evaluate p(x), q(x), and r(x) at x = 0.25,
# 7.50.  Display the results. Optionally also display results from
# evaluating in the original monomial basis.
#
echo "Subprogram (4) examples:"
for x in [0.25, 7.50]:
  echo "  p(", x, ") = ", evaluateBernsteinDegree3(pbern3, x),
       " (mono: ", evaluateMonomialDegree3(pmono3, x), ')'
for x in [0.25, 7.50]:
   echo "  q(", x, ") = ", evaluateBernsteinDegree3(qbern3, x),
       " (mono: ", evaluateMonomialDegree3(qmono3, x), ')'
for x in [0.25, 7.50]:
  echo "  r(", x, ") = ", evaluateBernsteinDegree3(rbern3, x),
       " (mono: ", evaluateMonomialDegree3(rmono3, x), ')'

#
# For the following polynomials, using the result of Subprogram (1)
# applied to the polynomial, use Subprogram (5) to get coefficients
# for the degree-3 Bernstein basis:
#
#   p(x) = 1
#   q(x) = 1 + 2x + 3x²
#
# Display the results.
#
echo "Subprogram (5) examples:"
let pbern3a = bernsteinDegree2ToDegree3(pbern2)
let qbern3a = bernsteinDegree2ToDegree3(qbern2)
echo "  bern ", pbern2, "--> bern ", pbern3a
echo "  bern ", qbern2, "--> bern ", qbern3a
