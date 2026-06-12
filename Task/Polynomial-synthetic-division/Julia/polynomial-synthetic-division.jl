function divrem(dividend::Vector, divisor::Vector)
    result = copy(dividend)
    quotientlen = length(divisor) - 1
    for i in 1:length(dividend)-quotientlen
        if result[i] != 0
            result[i] /= divisor[1]
            for j in 1:quotientlen
                result[i + j] -= divisor[j + 1] * result[i]
            end
        end
    end
    return result[1:end-quotientlen], result[end-quotientlen+1:end]
end

testpolys = [([1, -12, 0, -42], [1, -3]), ([1, 0, 0, 0, -2], [1, 1, 1, 1])]

for (n, d) in testpolys
    quotient, remainder = divrem(n, d)
    println("[$n] / [$d] = [$quotient] with remainder [$remainder]")
end
