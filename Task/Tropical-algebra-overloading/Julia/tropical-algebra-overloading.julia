⊕(x, y) = max(x, y)
⊗(x, y) = x + y
↑(x, y) = (@assert round(y) == y && y > 0; x * y)

@show 2 ⊗ -2
@show -0.001 ⊕ -Inf
@show 0 ⊗ -Inf
@show 1.5 ⊕ -1
@show -0.5 ⊗ 0
@show 5↑7
@show 5 ⊗ (8 ⊕ 7)
@show 5 ⊗ 8 ⊕ 5 ⊗ 7
@show 5 ⊗ (8 ⊕ 7) == 5 ⊗ 8 ⊕ 5 ⊗ 7
