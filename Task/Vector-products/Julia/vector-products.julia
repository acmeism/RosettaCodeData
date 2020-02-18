using LinearAlgebra

function scalarproduct(a::AbstractVector{T}, b::AbstractVector{T}, c::AbstractVector{T}) where {T<:Number}
    return dot(a, cross(b, c))
end

function vectorproduct(a::AbstractVector{T}, b::AbstractVector{T}, c::AbstractVector{T}) where {T<:Number}
    return cross(a, cross(b, c))
end

const a = [3, 4, 5]
const b = [4, 3, 5]
const c = [-5, -12, -13]

println("Test Vectors:")
@show a b c

println("\nVector Products:")
@show dot(a, b)
@show cross(a, b)
@show scalarproduct(a, b, c)
@show vectorproduct(a, b, c)
