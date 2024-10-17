import Statistics: mean

function diversitytheorem(truth::T, pred::Vector{T}) where T<:Number
    μ = mean(pred)
    avgerr = mean((pred .- truth) .^ 2)
    crderr = (μ - truth) ^ 2
    divers = mean((pred .- μ) .^ 2)
    avgerr, crderr, divers
end

for (t, s) in [(49, [48, 47, 51]),
               (49, [48, 47, 51, 42])]
    avgerr, crderr, divers = diversitytheorem(t, s)
    println("""
    average-error : $avgerr
    crowd-error   : $crderr
    diversity     : $divers
    """)
end
