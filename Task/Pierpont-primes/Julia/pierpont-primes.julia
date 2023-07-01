using Primes

function pierponts(N, firstkind = true)
    ret, incdec = BigInt[], firstkind ? 1 : -1
    for k2 in 0:10000, k3 in 0:k2, switch in false:true
        i, j = switch ? (k3, k2) : (k2, k3)
        n = BigInt(2)^i * BigInt(3)^j + incdec
        if isprime(n) && !(n in ret)
            push!(ret, n)
            if length(ret) == N * 2
                return sort(ret)[1:N]
            end
        end
    end
    throw("Failed to find $(N * 2) primes")
end

println("The first 50 Pierpont primes (first kind) are: ", pierponts(50))

println("\nThe first 50 Pierpont primes (second kind) are: ", pierponts(50, false))

println("\nThe 250th Pierpont prime (first kind) is: ", pierponts(250)[250])

println("\nThe 250th Pierpont prime (second kind) is: ", pierponts(250, false)[250])

println("\nThe 1000th Pierpont prime (first kind) is: ", pierponts(1000)[1000])

println("\nThe 1000th Pierpont prime (second kind) is: ", pierponts(1000, false)[1000])

println("\nThe 2000th Pierpont prime (first kind) is: ", pierponts(2000)[2000])

println("\nThe 2000th Pierpont prime (second kind) is: ", pierponts(2000, false)[2000])
