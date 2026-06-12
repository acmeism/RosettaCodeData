import cmath
import math
import numpy as np

def characteristicPolynomialCoefficients(matrix: list[list[float]]) -> tuple[float, float, float, float]:
    """
    Computes the coefficients (a, b, c, d) of the characteristic polynomial
    det(λI - M) = λ³ + bλ² + cλ + d for a 3x3 real matrix M.

    Parameters:
        matrix (list[list[float]]): A 3x3 matrix.

    Returns:
        tuple[float, float, float, float]: Coefficients (a=1, b, c, d).

    Raises:
        ValueError: If the input is not a 3x3 matrix.
    """
    if len(matrix) != 3 or any(len(row) != 3 for row in matrix):
        raise ValueError("matrix must be 3x3")

    m = matrix
    # Coefficient of λ³ is always 1 for a monic polynomial
    a = 1.0
    # Coefficient of λ² is -trace(M)
    b = -m[0][0] - m[1][1] - m[2][2]
    # Coefficient of λ is sum of principal 2x2 minors
    c = (m[0][0] * m[1][1] + m[1][1] * m[2][2] + m[2][2] * m[0][0]) - (m[1][2] * m[2][1] + m[2][0] * m[0][2] + m[0][1] * m[1][0])
    # Constant term is -det(M)
    d = (
        - m[0][0] * m[1][1] * m[2][2] - m[0][1] * m[1][2] * m[2][0]
        - m[0][2] * m[1][0] * m[2][1] + m[0][0] * m[2][1] * m[1][2]
        + m[0][1] * m[1][0] * m[2][2] + m[0][2] * m[1][1] * m[2][0]
    )

    return a, b, c, d

def evaluatePolynomial(coefficients: list[complex], x: complex) -> complex:
    """
    Evaluates a cubic polynomial a*x³ + b*x² + c*x + d at a complex point x
    using Horner's method for numerical stability.

    Parameters:
        coefficients (list[complex]): [a, b, c, d] — polynomial coefficients.
        x (complex): Point at which to evaluate the polynomial.

    Returns:
        complex: Value of the polynomial at x.
    """
    a, b, c, d = coefficients
    return ((a * x + b) * x + c) * x + d

def residuals(roots: list[complex], coefficients: list[float]) -> list[complex]:
    """
    Computes the residuals (i.e., polynomial evaluation errors) for candidate roots.

    Parameters:
        roots (list[complex]): Candidate eigenvalues (roots of the polynomial).
        coefficients (list[float]): Real coefficients [a, b, c, d] of the polynomial.

    Returns:
        list[complex]: Residuals for each root (should be near zero if root is accurate).
    """
    complexCoefficients = [complex(c, 0.0) for c in coefficients]
    return [evaluatePolynomial(complexCoefficients, r) for r in roots]

def _cubeRoot(z: complex) -> complex:
    """
    Computes the principal cube root of a complex number z.

    For real numbers, returns the real cube root (preserving sign).
    For complex numbers, uses the complex logarithm and exponential.

    Parameters:
        z (complex or float): Input number.

    Returns:
        complex: Principal cube root of z.
    """
    if isinstance(z, complex):
        # Treat nearly-real numbers as real to avoid numerical artifacts
        if abs(z.imag) < 1e-16:
            x = z.real
            return complex(math.copysign(abs(x)**(1.0/3.0), x), 0.0)
        # General complex cube root via polar form
        return cmath.exp(cmath.log(z)/3.0)
    else:
        # Handle real input
        return complex(math.copysign(abs(z)**(1.0/3.0), z), 0.0)

def cardanoRoots(a: float, b: float, c: float, d: float, tol: float = 1e-14) -> list[complex]:
    """
    Solves the cubic equation a*x³ + b*x² + c*x + d = 0 using Cardano's method.

    Handles degenerate cases (quadratic, linear, or constant polynomials) when a ≈ 0.

    Parameters:
        a, b, c, d (float): Polynomial coefficients.
        tol (float): Numerical tolerance for zero checks.

    Returns:
        list[complex]: Three roots (some may be NaN for degenerate cases).
    """
    # Handle degenerate cases where leading coefficient is zero
    if abs(a) < tol:
        if abs(b) < tol:
            if abs(c) < tol:
                # Constant polynomial: no meaningful roots
                return [complex("nan"), complex("nan"), complex("nan")]
            # Linear: c*x + d = 0 → x = -d/c
            return [complex(-d/c), complex(float("nan")), complex(float("nan"))]
        # Quadratic: b*x² + c*x + d = 0
        disc = c * c - 4 * b * d
        sqrtDisc = cmath.sqrt(disc)
        r0 = (-c + sqrtDisc) / (2 * b)
        r1 = (-c - sqrtDisc) / (2 * b)
        return [r0, r1, complex("nan")]

    # Normalise to monic polynomial: x³ + A x² + B x + C = 0
    A = b / a
    B = c / a
    C = d / a
    # Depress the cubic via substitution x = y - A/3 → eliminates quadratic term
    offset = A / 3.0
    p = (3.0 * B - A * A) / 3.0
    q = (2.0 * (A ** 3) - 9.0 * A * B + 27.0 * C) / 27.0
    # Discriminant of the depressed cubic y³ + p y + q = 0
    D = (q / 2.0) ** 2 + (p / 3.0) ** 3

    # Clamp near-zero discriminant to zero to avoid numerical noise
    if abs(D) <= tol:
        D = 0.0

    if D > 0.0:
        # One real root, two complex conjugate roots
        sqrtD = math.sqrt(D)
        u = _cubeRoot(-q/2.0+sqrtD)
        v = _cubeRoot(-q/2.0-sqrtD)
        y0 = u + v
        # Complex cube roots of unity used to get other roots
        y1 = -(u + v) / 2.0 + complex(0, math.sqrt(3)/2.0) * (u - v)
        y2 = -(u + v) / 2.0 - complex(0, math.sqrt(3)/2.0) * (u - v)
        roots = [y0-offset, y1-offset, y2-offset]
    elif D == 0.0:
        # All roots real, at least two equal
        u = _cubeRoot(-q/2.0)
        y0 = 2.0 * u
        y1 = -u
        roots = [y0-offset, y1-offset, y1-offset]
    else:
        # Three distinct real roots (casus irreducibilis)
        rho = math.sqrt(-(p**3)/27.0)
        # Clamp argument to [-1, 1] to avoid math domain errors due to floating-point noise
        cosArg = max(-1.0, min(1.0, -q/(2.0*rho)))
        theta = math.acos(cosArg)
        r = 2.0 * math.sqrt(-p/3.0)
        y0 = r * math.cos(theta/3.0)
        y1 = r * math.cos((theta/3.0)-2.0*math.pi/3.0)
        y2 = r * math.cos((theta/3.0)+2.0*math.pi/3.0)
        roots = [complex(y0-offset, 0.0), complex(y1-offset, 0.0), complex(y2-offset, 0.0)]

    return roots

def eigenvalues(matrix: list[list[float]], numpyEnabled: bool = True) -> tuple[list[complex], list[complex]]:
    """
    Computes eigenvalues of a 3x3 real matrix either via NumPy or via analytic Cardano method.

    Parameters:
        matrix (list[list[float]]): 3x3 real matrix.
        numpyEnabled (bool): If True, uses np.linalg.eigvals; otherwise uses Cardano's method.

    Returns:
        tuple[list[complex], list[complex]]: (eigenvalues, residuals)
    """
    if numpyEnabled:
        # Use NumPy's robust eigensolver
        arr = np.array(matrix, dtype=float)
        values = np.linalg.eigvals(arr)
        # np.poly returns coefficients of characteristic polynomial (highest degree first)
        coefficients = np.poly(arr)
        roots = [complex(v) for v in values]
        # Convert coefficients to real floats (they should be real for real matrices)
        res = residuals(roots, list(map(float, coefficients[:4])))
    else:
        # Use analytic method
        a, b, c, d = characteristicPolynomialCoefficients(matrix)
        roots = cardanoRoots(a, b, c, d)
        res = residuals(roots, [a, b, c, d])
    return roots, res

if __name__ == "__main__":
    r = 1.0 / math.sqrt(2.0)
    matrices = [
        [[ 1, -1,  0], [ 0,  1,  1], [0,  0,  1]],  # Upper triangular (eigenvalues on diag)
        [[-2, -4,  2], [-2,  1,  2], [4,  2,  5]],  # General matrix
        [[ 1, -1,  0], [ 0,  1, -1], [0,  0,  1]],  # Repeated eigenvalue with Jordan block
        [[ 2,  0,  0], [ 0, -1,  0], [0,  0, -1]],  # Diagonal
        [[ 2,  0,  0], [ 0,  3,  4], [0,  4,  9]],  # Block diagonal
        [[ 1,  0,  0], [ 0,  r, -r], [0,  r,  r]]   # Rotation-scaling block
    ]

    for matrix in matrices:
        coefficients = characteristicPolynomialCoefficients(matrix)
        roots, errs = eigenvalues(matrix)

        print(
            f"Matrix: {matrix}\n"
            f"Characteristic polynomial coefficients: {coefficients}\n"
            f"Eigenvalues: {roots}\n"
            f"Errors: {errs}\n"
        )
