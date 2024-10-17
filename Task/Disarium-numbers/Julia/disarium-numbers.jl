isdisarium(n) = sum(last(p)^first(p) for p in enumerate(reverse(digits(n)))) == n

function disariums(numberwanted)
    n, ret = 0, Int[]
    while length(ret) < numberwanted
        isdisarium(n) && push!(ret, n)
        n += 1
    end
    return ret
end

println(disariums(19))
@time disariums(19)
