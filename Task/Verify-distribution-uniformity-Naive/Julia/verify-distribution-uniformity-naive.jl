using Printf

function distcheck(f::Function, rep::Int=10000, Δ::Int=3)
    smpl = f(rep)
    counts = Dict(k => count(smpl .== k) for k in unique(smpl))
    expected = rep / length(counts)
    lbound = expected * (1 - 0.01Δ)
    ubound = expected * (1 + 0.01Δ)
    noobs = count(x -> !(lbound ≤ x ≤ ubound), values(counts))
    if noobs > 0 warn(@sprintf "%2.4f%% values out of bounds" noobs / rep) end
    return counts
end

# Dice5 check
distcheck(x -> rand(1:5, x))
# Dice7 check
distcheck(dice7)
