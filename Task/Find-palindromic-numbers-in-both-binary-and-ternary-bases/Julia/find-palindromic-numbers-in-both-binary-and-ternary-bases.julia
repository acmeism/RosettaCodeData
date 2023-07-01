ispalindrome(n, bas) = (s = string(n, base=bas); s == reverse(s))
prin3online(n) = println(lpad(n, 15), lpad(string(n, base=2), 40), lpad(string(n, base=3), 30))
reversebase3(n) = (x = 0; while n != 0 x = 3x + (n %3); n = div(n, 3); end; x)

function printpalindromes(N)
    lo, hi, pow2, pow3, count, i = 0, 1, 1, 1, 1, 0
    println(lpad("Number", 15), lpad("Base 2", 40), lpad("Base 3", 30))
    prin3online(0)
    while true
        for j in lo:hi-1
            i = j
            n = (3 * j + 1) * pow3 + reversebase3(j)
            if ispalindrome(n, 2)
                prin3online(n)
                count += 1
                if count >= N
                    return
                end
            end
        end
        if i == pow3
            pow3 *= 3
        else
            pow2 *= 4
        end

        while true
            while pow2 <= pow3
                pow2 *= 4
            end
            lo2 = div(div(pow2, pow3) - 1, 3)
            hi2 = div(div(pow2 * 2, pow3), 3) + 1
            lo3 = div(pow3, 3)
            hi3 = pow3

            if lo2 >= hi3
                pow3 *= 3
            elseif lo3 >= hi2
                pow2 *= 4
            else
                lo = max(lo2, lo3)
                hi = min(hi2, hi3)
                break
            end
        end
    end
end

printpalindromes(6)
