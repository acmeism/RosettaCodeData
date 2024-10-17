using LinearAlgebra

const a = [3, 4, 5]
const b = [4, 3, 5]
const c = [-5, -12, -13]

println("Test Vectors:")
@show a b c

println("\nVector Products:")
@show a ⋅ b
@show a × b
@show a ⋅ (b × c)
@show a × (b × c)
