using Printf
# arbitrary precision
setprecision(2000)

# Task 1
function seq(n)
    len = maximum(n)
    r = Vector{BigFloat}(len)
    r[1] = 2
    if len > 1 r[2] = -4 end

    for i in 3:len
        r[i] = 111 - 1130 / r[i-1] + 3000 / (r[i-1] * r[i-2])
    end

    return r[n]
end

n = [1, 2, 3, 5, 10, 100]
v = seq(n)
println("Task 1 - Sequence convergence:\n", join((@sprintf("v%-3i = %23.20f", i, s) for (i, s) in zip(n, v)), '\n'))

# Task 2: solution with big float (precision can be set with setprecision function)
function chaoticbankfund(years::Integer)
    balance = big(e) - 1
    for y in 1:years
        balance = (balance * y) - 1
    end

    return balance
end

println("\nTask 2 - Chaotic Bank fund after 25 years:\n", @sprintf "%.20f" chaoticbankfund(25))

# Task 3: solution with big float
f(a::Union{BigInt,BigFloat}, b::Union{BigInt,BigFloat}) =
    333.75b ^ 6 + a ^ 2 * ( 11a ^ 2 * b ^ 2 - b ^ 6 - 121b ^ 4 - 2 ) + 5.5b ^ 8 + a / 2b

println("\nTask 3 - Siegfried Rump's example:\nf(77617.0, 33096.0) = ", @sprintf "%.20f" f(big(77617.0), big(33096.0)))
