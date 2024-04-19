function solveApollonius(x1, y1, r1, x2, y2, r2, x3, y3, r3, s1, s2, s3)
	local v11 = 2*x2 - 2*x1
	local v12 = 2*y2 - 2*y1
	local v13 = x1*x1 - x2*x2 + y1*y1 - y2*y2 - r1*r1 + r2*r2
	local v14 = 2*s2*r2 - 2*s1*r1

	local v21 = 2*x3 - 2*x2
	local v22 = 2*y3 - 2*y2
	local v23 = x2*x2 - x3*x3 + y2*y2 - y3*y3 - r2*r2 + r3*r3
	local v24 = 2*s3*r3 - 2*s2*r2

	local w12 = v12 / v11
	local w13 = v13 / v11
	local w14 = v14 / v11

	local w22 = v22 / v21 - w12
	local w23 = v23 / v21 - w13
	local w24 = v24 / v21 - w14

	local p = -w23 / w22
	local q = w24 / w22
	local m = -w12*p - w13
	local n = w14 - w12*q

	local a = n*n + q*q - 1
	local b = 2*m*n - 2*n*x1 + 2*p*q - 2*q*y1 + 2*s1*r1
	local c = x1*x1 + m*m - 2*m*x1 + p*p + y1*y1 - 2*p*y1 - r1*r1

	local d = b*b - 4*a*c
	local rs = (-b - math.sqrt(d)) / (2*a)
	local xs = m + n*rs
	local ys = p + q*rs

	return xs, ys, rs
end
