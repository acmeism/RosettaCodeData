using Formatting

setprecision(BigFloat, 300)

function integerterm(n)
    p = BigInt(532) * n * n + BigInt(126) * n + 9
    return (p * BigInt(2)^5 * factorial(BigInt(6) * n)) ÷ (3 * factorial(BigInt(n))^6)
end

exponentterm(n) = -(6n + 3)

nthterm(n) = integerterm(n) * big"10.0"^exponentterm(n)

println("  N                       Integer Term              Power of 10     Nth Term")
println("-"^90)
for n in 0:9
    println(lpad(n, 3), lpad(integerterm(n), 48), lpad(exponentterm(n), 4),
        lpad(format("{1:22.19e}", nthterm(n)), 35))
end

function AlmkvistGuillera(floatprecision)
    summed = nthterm(0)
    for n in 1:10000000
        next = summed + nthterm(n)
        if abs(next - summed) < big"10.0"^(-floatprecision)
            return next
        end
        summed = next
    end
end

println("\nπ to 70 digits is ", format(big"1.0" / sqrt(AlmkvistGuillera(70)), precision=70))

println("Computer π is     ", format(π + big"0.0", precision=70))
