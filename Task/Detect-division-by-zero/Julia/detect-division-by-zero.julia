isdefinite(n::Number) = !isnan(n) && !isinf(n)

for n in (1, 1//1, 1.0, 1im, 0)
    d = n / 0
    println("Dividing $n by 0 ", isdefinite(d) ? "results in $d." : "yields an indefinite value ($d).")
end
