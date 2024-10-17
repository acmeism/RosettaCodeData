function maprange(s, a, b)
    a₁, a₂ = minimum(a), maximum(a)
    b₁, b₂ = minimum(b), maximum(b)
    return b₁ + (s - a₁) * (b₂ - b₁) / (a₂ - a₁)
end

@show maprange(6, 1:10, -1:0)
@show maprange(0:10, 0:10, -1:0)
