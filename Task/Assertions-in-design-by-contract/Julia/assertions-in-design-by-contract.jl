function volumesphere(r)
    @assert(r > 0, "Sphere radius must be positive")
    return π * r^3 * 4.0 / 3.0
end
