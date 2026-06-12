using BenchmarkTools

"""
	const_pi()::BigFloat

Compute π to current BigFloat precision. Simplification of MPFR's ©2025 implementation
as used in the Debian 13 source code, mpfr package, file `const_pi.c`, which states:
`The algorithm used here is taken from Section 8.2.5 of the book "Fast Algorithms:
A Multitape Turing Machine Implementation" by A. Schönhage, A. F. W. Grotefeld and
E. Vetter, 1994. It is a clever form of Brent-Salamin formula.`
"""
function const_pi()::BigFloat
	a = BigFloat(1)
	b = inv(sqrt(BigFloat(2)))
	t = BigFloat(1) / 4
	p = BigFloat(1)
    an = BigFloat(0)
    diff = BigFloat(0)
    bigeps = eps(BigFloat)

	# iterate until convergence
	while abs(a - b) > bigeps
		an = (a + b) / 2
		b = sqrt(a * b)
		diff = a - an
		t -= p * diff * diff
		a = an
		p *= 2
	end

	# π ≈ (a + b)^2 / (4t)
	return (a + b)^2 / (4 * t)
end

setprecision(BigFloat, 1_000_000; base = 10) do
	println("Calculating pi using built-in constant...")
	@btime BigFloat(pi)
	bigpi = string(BigFloat(pi))
	println(bigpi[1:30], " ... ", bigpi[999_972:1_000_001])

	println("Calculating pi without compiler constant optimization, using Schönhage-Grotefeld-Vetter formula...")
	@btime const_pi()
	bigpi = string(const_pi())
	println(bigpi[1:30], " ... ", bigpi[999_972:1_000_001])
end
