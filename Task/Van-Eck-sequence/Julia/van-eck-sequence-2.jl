function vanecksequence(N, startval=0)
    ret = zeros(Int, N)
    ret[1] = startval
    lastseen = Dict{Int, Int}()
    for i in 1:N-1
        if haskey(lastseen, ret[i])
            ret[i + 1] = i - lastseen[ret[i]]
        end
        lastseen[ret[i]] = i
    end
    ret
end
