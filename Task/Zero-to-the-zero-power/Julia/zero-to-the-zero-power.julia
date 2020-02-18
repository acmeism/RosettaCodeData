using Printf

const types = (Complex, Float64, Rational, Int, Bool)

for Tb in types, Te in types
    zb, ze = zero(Tb), zero(Te)
    r = zb ^ ze
    @printf("%10s ^ %-10s = %7s ^ %-7s = %-12s (%s)\n", Tb, Te, zb, ze, r, typeof(r))
end
