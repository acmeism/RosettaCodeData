using Polynomials

p = Poly([-42,0,-12,1])
q = Poly([-3,1])

d, r = divrem(p,q)

println(p, " divided by ", q, " is ", d, " with remainder ", r, ".")
