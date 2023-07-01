function changes(amount::Int, coins::Array{Int})::Int128
    ways = zeros(Int128, amount + 1)
    ways[1] = 1
    for coin in coins, j in coin+1:amount+1
        ways[j] += ways[j - coin]
    end
    return ways[amount + 1]
end

@show changes(100, [1, 5, 10, 25])
@show changes(100000, [1, 5, 10, 25, 50, 100])
