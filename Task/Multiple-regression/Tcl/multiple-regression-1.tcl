package require math::linearalgebra
namespace eval multipleRegression {
    namespace export regressionCoefficients
    namespace import ::math::linearalgebra::*

    # Matrix inversion is defined in terms of Gaussian elimination
    # Note that we assume (correctly) that we have a square matrix
    proc invert {matrix} {
	solveGauss $matrix [mkIdentity [lindex [shape $matrix] 0]]
    }
    # Implement the Ordinary Least Squares method
    proc regressionCoefficients {y x} {
	matmul [matmul [invert [matmul $x [transpose $x]]] $x] $y
    }
}
namespace import multipleRegression::regressionCoefficients
