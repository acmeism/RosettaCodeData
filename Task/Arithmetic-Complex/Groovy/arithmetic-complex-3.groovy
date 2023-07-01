import static Complex.*

Number.metaClass.mixin ComplexCategory
Integer.metaClass.mixin ComplexCategory

def ε = 0.000000001  // tolerance (epsilon): acceptable "wrongness" to account for rounding error

println 'Demo 1: functionality as requested'
def a = [5,3] as Complex
def a1 = [real:5, imag:3] as Complex
def a2 = 5 + 3.i
def a3 = 5 + 3*i
assert a == a1 && a == a2 && a == a3
println 'a == ' + a
def b = [0.5,6] as Complex
println 'b == ' + b

println "a + b == (${a}) + (${b}) == " + (a + b)
println "a * b == (${a}) * (${b}) == " + (a * b)
assert a + (-a) == 0
println "-a == -(${a}) == " + (-a)
assert (a * a.recip - 1).abs < ε
println "1/a == (${a}).recip == " + (a.recip)
println "a * 1/a == " + (a * a.recip)
println()

println 'Demo 2: other functionality not requested, but important for completeness'
def c = 10
def d = 10 as Complex
assert d instanceof Complex && c instanceof Number && d == c
assert a + c == c + a
println "a + 10 == 10 + a == " + (c + a)
assert c - a == -(a - c)
println "10 - a == -(a - 10) == " + (c - a)
println "a - b == (${a}) - (${b}) == " + (a - b)
assert c * a == a * c
println "10 * a == a * 10 == " + (c * a)
assert (c / a - (a / c).recip).abs < ε
println "10 / a == 1 / (a / 10) == " + (c / a)
println "a / b == (${a}) / (${b}) == " + (a / b)
assert (a ** 2 - a * a).abs < ε
println "a ** 2 == a * a == " + (a ** 2)
println "0.9 ** b == " + (0.9 ** b)
println "a ** b == (${a}) ** (${b}) == " + (a ** b)
println 'a.real == ' + a.real
println 'a.imag == ' + a.imag
println '|a| == ' + a.abs
println 'a.rho == ' + a.rho
println 'a.ρ == ' + a.ρ
println 'a.theta == ' + a.theta
println 'a.θ == ' + a.θ
println '~a (conjugate) == ' + ~a

def ρ = 10
def π = Math.PI
def n = 3
def θ = π / n

def fromPolar1 = fromPolar(ρ, θ)    // direct polar-to-cartesian conversion
def fromPolar2 = exp(θ.i) * ρ       // Euler's equation
println "ρ*cos(θ) + i*ρ*sin(θ) == ${ρ}*cos(π/${n}) + i*${ρ}*sin(π/${n})"
println "                      == 10*0.5      + i*10*√(3/4)    == " + fromPolar1
println "ρ*exp(i*θ)            == ${ρ}*exp(i*π/${n})                == " + fromPolar2
assert (fromPolar1 - fromPolar2).abs < ε
