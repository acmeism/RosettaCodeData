Rebol [
    title: "Rosetta code: Polynomial regression"
    file:  %Polynomial_regression.r3
    url:   https://rosettacode.org/wiki/Polynomial_regression
]

eval: function [
    "Evaluate a quadratic polynomial a + bx + cx^^2 at x using Horner's method."
    a [number!] "Constant term"
    b [number!] "Linear coefficient"
    c [number!] "Quadratic coefficient"
    x [number!] "Point at which to evaluate"
][
    a + ((b + (c * x)) * x)
]

regression: function [
    "Fit a quadratic y = a + bx + cx^2 to data points via least squares. Prints coefficients and residuals."
    xa [block! vector!] "Block of x values"
    ya [block! vector!] "Block of y values; must match length of xa"
][
    n: length? xa
    ;; accumulate raw moment sums
    xm: ym: x2m: x3m: x4m: xym: x2ym: 0.0

    repeat i n [
        xi: xa/:i
        yi: ya/:i
        xm:   xm   +  xi
        ym:   ym   +  yi
        x2m:  x2m  + (xi * xi)
        x3m:  x3m  + (xi * xi * xi)
        x4m:  x4m  + (xi * xi * xi * xi)
        xym:  xym  + (xi * yi)
        x2ym: x2ym + (xi * xi * yi)
    ]

    ;; convert sums to means
    xm:   xm   / n
    ym:   ym   / n
    x2m:  x2m  / n
    x3m:  x3m  / n
    x4m:  x4m  / n
    xym:  xym  / n
    x2ym: x2ym / n

    ;; central moments (variance/covariance terms)
    sxx:   x2m  - (xm  * xm)
    sxy:   xym  - (xm  * ym)
    sxx2:  x3m  - (xm  * x2m)
    sx2x2: x4m  - (x2m * x2m)
    sx2y:  x2ym - (x2m * ym)

    ;; solve 3x3 normal equations for a, b, c
    denom:  sxx  * sx2x2 - (sxx2 * sxx2)
        b: (sxy  * sx2x2 - (sx2y * sxx2)) / denom
        c: (sx2y * sxx   - (sxy  * sxx2)) / denom
        a: ym - (b * xm) - (c * x2m)

    print ajoin ["y = " a " + " b "x + " c "x^^2" LF]
    ;; print input points alongside fitted values
    print " Input  Approximation"
    print " x   y        y1"
    repeat i n [
        printf [-2 -4 /green -10.0 /reset] [xa/:i  ya/:i  eval a b c xa/:i]
    ]
]

xa: [0 1  2  3  4  5   6   7   8   9  10]
ya: [1 6 17 34 57 86 121 162 209 262 321]
regression xa ya
