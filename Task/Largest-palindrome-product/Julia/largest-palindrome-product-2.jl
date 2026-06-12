""" taken from https://leetcode.com/problems/largest-palindrome-product/discuss/150954/Fast-algorithm-by-constrains-on-tail-digits """

const T = [Set([(0, 0)])]

function double(it)
    arr = empty(it)
    for p in it
        push!(arr, p, reverse(p))
    end
    return arr
end

""" Construct a pair of n-digit numbers such that their product ends with 99...9 pattern """
function tails(n)
    if length(T) <= n
        l = Set()
        for i in 0:9, j in i:9
            I = i * 10^(n-1)
            J = j * 10^(n-1)
            it = collect(tails(n - 1))
            I != J && (it = double(it))
            for (t1, t2) in it
                if ((I + t1) * (J + t2) + 1) % 10^n == 0
                    push!(l, (I + t1, J + t2))
                end
            end
        end
        push!(T, l)
    end
    return T[n + 1]
end

""" find the largest palindrome that is a product of n-digit numbers """
function largestpalindrome(n)
    m, tail = 0, n ÷ 2
    head = n - tail
    up = 10^head
    for L in 1 : 9 * 10^(head-1)
        # Consider small shell (up-L)^2 < (up-i)*(up-j) <= (up-L)^2, 1<=i<=L<=j
        m, sol = 0, (0, 0)
        for i in 1:L
            lo = max(Int128(i), Int128(up - (up - L + 1)^2 ÷ (up - i)) + 1)
            hi = Int128(up - (up - L)^2 ÷ (up - i))
            for j in lo:hi
                I = (up - i) * 10^tail
                J = (up - j) * 10^tail
                it = collect(tails(tail))
                I != J && (it = double(it))
                for (t1, t2) in it
                    val = (I + t1) * (J + t2)
                    s = string(val)
                    if s == reverse(s) && val > m
                        sol = (I + t1, J + t2)
                        m = val
                    end
                end
            end
        end
        if m > 0
            println(lpad(n, 2), "    ", lpad(m % 1337, 4), " $sol $(sol[1] * sol[2])")
            return m % 1337
        end
    end
    return 0
end

@time for k in 1:16
    largestpalindrome(k)
end
