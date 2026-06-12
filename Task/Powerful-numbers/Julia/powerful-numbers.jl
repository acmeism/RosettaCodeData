using Primes

is_kpowerful(n, k) = all(x -> x[2] >= k, factor(n)) # not used here

is_squarefree(n) = all(x -> x[2] == 1, factor(n))
rootdiv(n, m, r) = Int128(floor(div(n, m)^(1/r) + 0.0000001))

function genkpowerful(n, k)
    ret = Int128[]
    function inner(m, r)
        if r < k
            push!(ret, m)
        else
            for a in 1:rootdiv(n, m, r)
                if r <= k || (gcd(a, m) == 1 && is_squarefree(a))
                    inner(m * Int128(a)^r, r - 1)
                end
            end
        end
    end
    inner(1, 2 * k - 1)
    return unique(sort(Int.(ret)))
end

function kpowerfulcount(n, k)
    count = Int128(0)
    function inner(m, r)
        if r <= k
            count += rootdiv(n, m, r)
        else
            for a in 1:rootdiv(n, m, r)
                if gcd(a, m) == 1 && is_squarefree(a)
                    inner(m * a^r, r - 1)
                end
            end
        end
    end
    inner(1, 2*k - 1)
    return Int(count)
end

for k in 2:10
    a = genkpowerful(10^k, k)
    len = length(a)
    print("The set of $k-powerful numbers between 1 and 10^$k has $len members:\n[")
    for i in [1:5 ; len-5:len]
        print(a[i], i == 5 ? " ... " : i == len ? "]\n" : ", ")
    end
end
for k in 2:10
    print("The count of $k-powerful numbers from 1 to 10^j for j in 0:$(k+9) is: ",
        [kpowerfulcount(Int128(10)^j, k) for j in 0:(k+9)], "\n")
end
