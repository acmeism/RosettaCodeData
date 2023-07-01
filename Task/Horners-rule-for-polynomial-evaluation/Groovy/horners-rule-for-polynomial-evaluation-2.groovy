def coefficients = [-19g, 7g, -4g, 6g]
println (["p coefficients":coefficients])

def testPoly = hornersRule.curry(coefficients)
println (["p(3)":testPoly(3g)])
println (["p(0)":testPoly(0g)])

def derivativeCoefficients = { coeff -> (1..<(coeff.size())).collect { coeff[it] * it } }
println (["p' coefficients":derivativeCoefficients(coefficients)])

def testDeriv = hornersRule.curry(derivativeCoefficients(coefficients))
println (["p'(3)":testDeriv(3g)])
println (["p'(0)":testDeriv(0g)])

def newtonRaphson = { x, f, fPrime ->
    while (f(x).abs() > 0.0001) {
        x -= f(x)/fPrime(x)
    }
    x
}

def root = newtonRaphson(3g, testPoly, testDeriv)
println ([root:root.toString()[0..5], "p(root)":testPoly(root).toString()[0..5], "p'(root)":testDeriv(root).toString()[0..5]])
