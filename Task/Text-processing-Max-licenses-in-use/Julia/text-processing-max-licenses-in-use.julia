function maximumsimultlicenses(io::IO)
    out, maxout, maxtimes = 0, -1, String[]
    for job in readlines(io)
        out += ifelse(occursin("OUT", job), 1, -1)
        if out > maxout
            maxout = out
            empty!(maxtimes)
        end
        if out == maxout
            push!(maxtimes, split(job)[4])
        end
    end
    return maxout, maxtimes
end

let (maxout, maxtimes) = open(maximumsimultlicenses, "data/mlijobs.txt")
    println("Maximum simultaneous license use is $maxout at the following times: \n - ", join(maxtimes, "\n - "))
end
