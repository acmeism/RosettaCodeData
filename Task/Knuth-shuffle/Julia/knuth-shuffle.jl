function knuthshuffle!(r::AbstractRNG, v::AbstractVector)
    for i in length(v):-1:2
        j = rand(r, 1:i)
        v[i], v[j] = v[j], v[i]
    end
    return v
end
knuthshuffle!(v::AbstractVector) = knuthshuffle!(Base.Random.GLOBAL_RNG, v)

v = collect(1:20)
println("# v = $v\n   -> ", knuthshuffle!(v))
