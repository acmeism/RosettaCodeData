using Printf

agm1step(x, y) = (x + y) / 2, sqrt(x * y)

function approxπstep(x, y, z, n::Integer)
    a, g = agm1step(x, y)
    k = n + 1
    s = z + 2 ^ (k + 1) * (a ^ 2 - g ^ 2)
    return a, g, s, k
end

approxπ(a, g, s) = 4a ^ 2 / (1 - s)

function testmakepi()
	setprecision(512)
	a, g, s, k = BigFloat(1.0), 1 / √BigFloat(2.0), BigFloat(0.0), 0
	oldπ = BigFloat(0.0)
	println("Approximating π using ", precision(BigFloat), "-bit floats.")
	println("   k     Error  Result")
	for i in 1:100
		a, g, s, k = approxπstep(a, g, s, k)
		estπ = approxπ(a, g, s)
		if abs(estπ - oldπ) < 2eps(estπ) break end
		oldπ = estπ
		err = abs(π - estπ)
		@printf("%4d%10.1e%68.60e\n", i, err, estπ)
	end
end

testmakepi()
