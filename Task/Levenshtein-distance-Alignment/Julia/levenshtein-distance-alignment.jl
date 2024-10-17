function levenshteinalign(a::AbstractString, b::AbstractString)
    a = lowercase(a)
    b = lowercase(b)
    len_a = length(a)
    len_b = length(b)

    costs = Matrix{Int}(len_a + 1, len_b + 1)
    costs[1, :] .= 0:len_b
    @inbounds for i in 2:(len_a + 1)
        costs[i, 1] = i
        for j in 2:(len_b + 1)
            tmp = ifelse(a[i-1] == b[j-1], costs[i-1, j-1], costs[i-1, j-1] + 1)
            costs[i, j] = min(1 + min(costs[i-1, j], costs[i, j-1]), tmp)
        end
    end

    apathrev = IOBuffer()
    bpathrev = IOBuffer()
    local i = len_a + 1
    local j = len_b + 1
    @inbounds while i != 1 && j != 1
        tmp = ifelse(a[i-1] == b[j-1], costs[i-1, j-1], costs[i-1, j-1] + 1)
        if costs[i, j] == tmp
            i -= 1
            j -= 1
            print(apathrev, a[i])
            print(bpathrev, b[j])
        elseif costs[i, j] == 1 + costs[i-1, j]
            i -= 1
            print(apathrev, a[i])
            print(bpathrev, '-')
        elseif costs[i, j] == 1 + costs[i, j-1]
            j -= 1
            print(apathrev, '-')
            print(bpathrev, b[j])
        end
    end

    return reverse(String(take!(apathrev))), reverse(String(take!(bpathrev)))
end

foreach(println, levenshteinalign("rosettacode", "raisethysword"))
foreach(println, levenshteinalign("place", "palace"))
