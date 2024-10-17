function isowndigitspowersum(n::Integer, base=10)
    dig = digits(n, base=base)
    exponent = length(dig)
    return mapreduce(x -> x^exponent, +, dig) == n
end

for i in 10^2:10^9-1
    isowndigitspowersum(i) && println(i)
end
