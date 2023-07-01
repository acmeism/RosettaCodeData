function vanecksequence(N, startval=0)
    ret = zeros(Int, N)
    ret[1] = startval
    for i in 1:N-1
        lastseen = findlast(x -> x == ret[i], ret[1:i-1])
        if lastseen != nothing
            ret[i + 1] = i - lastseen
        end
    end
    ret
end

println(vanecksequence(10))
println(vanecksequence(1000)[991:1000])
