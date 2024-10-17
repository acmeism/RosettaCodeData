julia> function f(n)
    s = 0.0
    for k = 1:n
      s += 1/k^2
    end
    return s
end

julia> f(1000)
1.6439345666815615
