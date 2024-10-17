using Combinatorics, BenchmarkTools

asint(dig) = foldl((i, j) -> 10i + Int128(j), dig)

"""
Algorithm 1(A)
Generate all the permutations of the digits and sort into numeric order.
Find the number in the list.
Return the next highest number from the list.
"""
function nexthighest_1A(N)
    n = Int128(abs(N))
    dig = digits(n)
    perms = unique(sort([asint(arr) for arr in permutations(digits(n))]))
    length(perms) < 2 && return 0
    ((N > 0 && perms[end] == n) || (N < 0 && perms[1] == n)) && return 0
    pos = findfirst(x -> x == n, perms)
    ret = N > 0 ? perms[pos + 1] : -perms[pos - 1]
    return ret == N ? 0 : ret
end

"""
Algorithm 1(B)
Iterate through the permutations of the digits of a number and get the permutation that
represents the integer having a minimum distance above the given number.
Return the number plus the minimum distance. Does not store all the permutations.
This saves memory versus algorithm 1A, but we still go through all permutations (slow).
"""
function nexthighest_1B(N)
    n = Int128(abs(N))
    dig = reverse(digits(n))
    length(dig) < 2 && return 0
    mindelta = n
    for perm in permutations(dig)
        if (perm[1] != 0) && ((N > 0 && perm > dig) || (N < 0 && perm < dig))
            delta = abs(asint(perm) - n)
            if delta < mindelta
                mindelta = delta
            end
        end
    end
    return mindelta < n ? N + mindelta : 0
end

"""
Algorithm 2
Scan right-to-left through the digits of the number until you find a digit with a larger digit somewhere to the right of it.
Exchange that digit with the digit on the right that is both more than it, and closest to it.
Order the digits to the right of this position, after the swap; lowest-to-highest, left-to-right.
Very fast, as it does not need to run through all the permutations of digits.
"""
function nexthighest_2(N)
    n = Int128(abs(N))
    dig, ret = digits(n), N
    length(dig) < 2 && return 0
    for (i, d) in enumerate(dig)
        if N > 0 && i > 1
            rdig = dig[1:i-1]
            if (j = findfirst(x -> x > d, rdig)) != nothing
                dig[i], dig[j] = dig[j], dig[i]
                arr = (i == 2) ? dig : [sort(dig[1:i-1], rev=true); dig[i:end]]
                ret = asint(reverse(arr))
                break
            end
        elseif N < 0 && i > 1
            rdig = dig[1:i-1]
            if (j = findfirst(x -> x < d, rdig)) != nothing
                dig[i], dig[j] = dig[j], dig[i]
                arr = (i == 2) ? dig : [sort(dig[1:i-1]); dig[i:end]]
                ret = -asint(reverse(arr))
                break
            end
        end
    end
    return ret == N ? 0 : ret
end

println(" N                       1A                       1B                       2\n", "="^98)
for n in [0, 9, 12, 21, -453, -8888, 12453, 738440, 45072010, 95322020, -592491602, 9589776899767587796600]
        println(rpad(n, 25), abs(n) > typemax(Int) ? " "^50 : rpad(nexthighest_1A(n), 25) *
            rpad(nexthighest_1B(n), 25), nexthighest_2(n))
end

const n = 7384440
@btime nexthighest_1A(n)
println(" for method 1A and n $n.")
@btime nexthighest_1B(n)
println(" for method 1B and n $n.")
@btime nexthighest_2(n)
println(" for method 2 and n $n.")
