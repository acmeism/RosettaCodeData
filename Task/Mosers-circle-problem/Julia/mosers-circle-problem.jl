moserpoly(n) = (n^4 - 6n^3 + 23n^2 - 18n + 24) ÷ 24
moserbino(n) = binomial(n, 4) + binomial(n, 2) + 1
moserpasc(n) = sum(binomial(n-1, k) for k in 0:min(n-1, 4))
mosertran(n) = sum(binomial(n-1, k) * (k < 5) for k in 0:n-1)
println(" n  Moser(n)\n=============")
for n in 1:20
    mpoly, mbinom, mpascal, mtrans = moserpoly(n), moserbino(n), moserpasc(n), mosertran(n)
    @assert mpoly == mbinom == mpascal == mtrans
    println(lpad(n, 2), lpad(mpoly, 7))
end
