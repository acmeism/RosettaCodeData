function nthUlam(n)
    ulams = [1, 2]
    memoized = Set([1, 2])
    i = 3
    while true
        count = 0
        for j in 1:length(ulams)
            if i - ulams[j] in memoized && ulams[j] != i - ulams[j]
                (count += 1) > 2 && break
            end
        end
        if count == 2
            push!(ulams, i)
            push!(memoized, i)
            length(ulams) == n && break
        end
        i += 1
    end
    return ulams[n]
end

nthUlam(5)

for n in [10, 100, 1000, 10000]
    @time println("The ", n, "th Ulam number is: ", nthUlam(n))
end
