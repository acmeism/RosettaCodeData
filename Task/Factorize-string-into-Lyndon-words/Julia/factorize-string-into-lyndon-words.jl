function chenfoxlyndonfactorization(s)
    n = length(s)
    i = 1
    factorization = String[]
    while i <= n
        j = i + 1
        k = i
        while j <= n && s[k] <= s[j]
            if s[k] < s[j]
                k = i
            else
                k += 1
            end
            j += 1
        end
        while i <= k
            push!(factorization, s[i:i+j-k-1])
            i += j - k
        end
    end
    @assert s == prod(factorization)
    return factorization
end

let m = "0"
    for i in 1:7
        m *= replace(m, '0' => '1', '1' => '0')
    end
    println(chenfoxlyndonfactorization(m))
end
