function lineplanecollision(planenorm::Vector, planepnt::Vector, raydir::Vector, raypnt::Vector)
    ndotu = dot(planenorm, raydir)
    if ndotu ≈ 0 error("no intersection or line is within plane") end

    w  = raypnt - planepnt
    si = -dot(planenorm, w) / ndotu
    ψ  = w .+ si .* raydir .+ planepnt
    return ψ
end

# Define plane
planenorm = Float64[0, 0, 1]
planepnt  = Float64[0, 0, 5]

# Define ray
raydir = Float64[0, -1, -1]
raypnt = Float64[0,  0, 10]

ψ = lineplanecollision(planenorm, planepnt, raydir, raypnt)
println("Intersection at $ψ")
