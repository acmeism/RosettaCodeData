def tol = 0.000000001  // tolerance: acceptable "wrongness" to account for rounding error

println 'Demo 1: functionality as requested'
def a = [5,3] as Complex
println 'a == ' + a
def b = [0.5,6] as Complex
println 'b == ' + b

println "a + b == (${a}) + (${b}) == " + (a + b)
println "a * b == (${a}) * (${b}) == " + (a * b)
assert a + (-a) == 0
println "-a == -(${a}) == " + (-a)
assert (a * a.recip() - 1).abs() < tol
println "1/a == (${a}).recip() == " + (a.recip())
println()

println 'Demo 2: other functionality not requested, but important for completeness'
println "a - b == (${a}) - (${b}) == " + (a - b)
println "a / b == (${a}) / (${b}) == " + (a / b)
println "a ** b == (${a}) ** (${b}) == " + (a ** b)
println 'a.real == ' + a.real
println 'a.imag == ' + a.imag
println 'a.rho == ' + a.rho
println 'a.theta == ' + a.theta
println '|a| == ' + a.abs()
println 'a_bar == ' + ~a

def rho = 10
def piOverTheta = 3
def theta = Math.PI / piOverTheta
def fromPolar1 = Complex.fromPolar(rho, theta)          // direct polar-to-cartesian conversion
def fromPolar2 = Complex.exp(Complex.I * theta) * rho     // Euler's equation
println "rho*cos(theta) +  rho*i*sin(theta) == ${rho}*cos(pi/${piOverTheta}) +  ${rho}*i*sin(pi/${piOverTheta}) == " + fromPolar1
println "rho * exp(i * theta) == ${rho} * exp(i * pi/${piOverTheta}) == " + fromPolar2
assert (fromPolar1 - fromPolar2).abs() < tol
println()
