function closestpair(P::Vector{Vector{T}}) where T <: Number
    N = length(P)
    if N < 2 return (Inf, ()) end
    mindst = norm(P[1] - P[2])
    minpts = (P[1], P[2])
    for i in 1:N-1, j in i+1:N
        tmpdst = norm(P[i] - P[j])
        if tmpdst < mindst
            mindst = tmpdst
            minpts = (P[i], P[j])
        end
    end
    return mindst, minpts
end

closestpair([[0, -0.3], [1., 1.], [1.5, 2], [2, 2], [3, 3]])
