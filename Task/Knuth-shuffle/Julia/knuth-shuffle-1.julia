function shuffle!(r::AbstractRNG, a::AbstractVector)
    for i = length(a):-1:2
        j = rand(r, 1:i)
        a[i], a[j] = a[j], a[i]
    end
    return a
end
