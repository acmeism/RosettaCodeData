function rat(x::AbstractFloat, tol::Real=eps(x))::Rational
    p, q, pp, qq  = copysign(1,x), 0, 0, 1
    x, y = abs(x), 1.0
    r, a = modf(x)
    nt, t, tt = tol, 0.0, tol

    while r > nt        # convergents of the continued fraction: np//nq = (p*a + pp) // (q*a + qq)
        np, nq = Int(a).*(p,q) .+ (pp,qq)
        p, pp, q, qq = np, p, nq, q

        x, y = y, r     # instead of the inexact 1/r...
        a, r = divrem(x,y)

        t, tt = nt, t   # maintain x = (p + (-1)^i * r) / q
        nt = a*t+tt
    end

    i = Int(cld(x-tt,y+t))   # find optimal semiconvergent: smallest i such that x-i*y < i*t+tt
    return (i*p+pp) // (i*q+qq)
end
