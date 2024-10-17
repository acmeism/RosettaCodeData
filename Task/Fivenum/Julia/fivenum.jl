function mediansorted(x::AbstractVector{T}, i::Integer, l::Integer)::T where T
    len = l - i + 1
    len > zero(len) || throw(ArgumentError("Array slice cannot be empty."))
    mid = i + len ÷ 2
    return isodd(len) ? x[mid] : (x[mid-1] + x[mid]) / 2
end

function fivenum(x::AbstractVector{T}) where T<:AbstractFloat
    r = Vector{T}(5)
    xs = sort(x)
    mid::Int = length(xs) ÷ 2
    lowerend::Int = isodd(length(xs)) ? mid : mid - 1
    r[1] = xs[1]
    r[2] = mediansorted(xs, 1, lowerend)
    r[3] = mediansorted(xs, 1, endof(xs))
    r[4] = mediansorted(xs, mid, endof(xs))
    r[end] = xs[end]
    return r
end

for v in ([15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0],
          [36.0, 40.0, 7.0, 39.0, 41.0, 15.0],
          [0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
          -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
          -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
           0.75775634,  0.32566578])
    println("# ", v, "\n -> ", fivenum(v))
end
