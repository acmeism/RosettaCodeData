struct WithRepetitionsPermutations{T}
    a::T
    t::Int
end

with_repetitions_permutations(elements::T, len::Integer) where T =
    WithRepetitionsPermutations{T}(unique(elements), len)

Base.iteratorsize(::WithRepetitionsPermutations) = Base.HasLength()
Base.length(p::WithRepetitionsPermutations) = length(p.a) ^ p.t
Base.iteratoreltype(::WithRepetitionsPermutations) = Base.HasEltype()
Base.eltype(::WithRepetitionsPermutations{T}) where T = T
Base.start(p::WithRepetitionsPermutations) = ones(Int, p.t)
Base.done(p::WithRepetitionsPermutations, s::Vector{Int}) = s[end] > endof(p.a)
function Base.next(p::WithRepetitionsPermutations, s::Vector{Int})
    cur = p.a[s]
    s[1] += 1
    local i = 1
    while i < endof(s) && s[i] > length(p.a)
        s[i] = 1
        s[i+1] += 1
        i += 1
    end
    return cur, s
end

println("Permutations of [4, 5, 6] in 3:")
foreach(println, collect(with_repetitions_permutations([4, 5, 6], 3)))
