""" https://rosettacode.org/wiki/Long_stairs """

using Statistics

struct LongStairs
    startstep::Int
    startlength::Int
    climbersteps::Int
    addsteps::Int
end

Base.length(LongStairs) = typemax(Int)
Base.eltype(ls::LongStairs) = Vector{Int}

function Base.iterate(s::LongStairs, param = (s.startstep, s.startlength))
     pos, len = param
     pos += s.climbersteps
     pos += sum(pos .> rand(1:len, s.addsteps))
     len += s.addsteps
     return [pos, len], (pos, len)
end

ls = LongStairs(1, 100, 1, 5)

println("Seconds  Behind  Ahead\n----------------------")
for (secs, (pos, len)) in enumerate(collect(Iterators.take(ls, 609))[600:609])
    println(secs + 599, "      ", pos, "    ", len - pos)
end

println("Ten thousand trials to top:")
times, heights = Int[], Int[]
for trial in 1:10_000
    trialstairs = LongStairs(1, 100, 1, 5)
    for (sec, (step, height)) in Iterators.enumerate(trialstairs)
        if step >= height
            push!(times, sec)
            push!(heights, height)
            break
        end
    end
end
@show mean(times), mean(heights)
