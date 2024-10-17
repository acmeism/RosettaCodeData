module SpatialVectors

export SpatialVector

struct SpatialVector{N, T}
    coord::NTuple{N, T}
end

SpatialVector(s::NTuple{N,T}, e::NTuple{N,T}) where {N,T} =
    SpatialVector{N, T}(e .- s)
function SpatialVector(∠::T, val::T) where T
    θ = atan(∠)
    x = val * cos(θ)
    y = val * sin(θ)
    return SpatialVector((x, y))
end

angularcoef(v::SpatialVector{2, T}) where T = v.coord[2] / v.coord[1]
Base.norm(v::SpatialVector) = sqrt(sum(x -> x^2, v.coord))

function Base.show(io::IO, v::SpatialVector{2, T}) where T
    ∠ = angularcoef(v)
    val = norm(v)
    println(io, """2-dim spatial vector
        - Angular coef ∠: $(∠) (θ = $(rad2deg(atan(∠)))°)
        - Magnitude: $(val)
        - X coord: $(v.coord[1])
        - Y coord: $(v.coord[2])""")
end

Base.:-(v::SpatialVector) = SpatialVector(.- v.coord)

for op in (:+, :-)
    @eval begin
        Base.$op(a::SpatialVector{N, T}, b::SpatialVector{N, U}) where {N, T, U} =
            SpatialVector{N, promote_type(T, U)}(broadcast($op, a.coord, b.coord))
    end
end

for op in (:*, :/)
    @eval begin
        Base.$op(n::T, v::SpatialVector{N, U}) where {N, T, U} =
            SpatialVector{N, promote_type(T, U)}(broadcast($op, n, v.coord))
        Base.$op(v::SpatialVector, n::Number) = $op(n, v)
    end
end

end  # module Vectors
