function josephus(n::T, k::T, m::T=one(T)) where T <: Integer
    p, i, seq = collect(0:n-1), 0, [zero(T)]
    while length(p) > m
        i = (i + k - 1) % length(p)
        push!(seq, splice!(p, i + 1))
    end
    return seq, p
end

seq, surv = josephus(41, 3)
println("Prisoner killing in order: $seq\nSurvivor: $surv")

seq, surv = josephus(41, 3, 3)
println("Prisoner killing in order: $seq\nSurvivor: $surv")
