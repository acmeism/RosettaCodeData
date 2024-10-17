using Printf

function quadroots(x::Real, y::Real, z::Real)
    a, b, c = promote(float(x), y, z)
    if a ≈ 0.0 return [-c / b] end
    Δ = b ^ 2 - 4a * c
    if Δ ≈ 0.0 return [-sqrt(c / a)] end
    if Δ < 0.0 Δ = complex(Δ) end
    d = sqrt(Δ)
    if b < 0.0
        d -= b
        return [d / 2a, 2c / d]
    else
        d = -d - b
        return [2c / d, d / 2a]
    end
end

a = [1, 1, 1.0, 10]
b = [10, 2, -10.0 ^ 9, 1]
c = [1, 1, 1, 1]

for (x, y, z) in zip(a, b, c)
    @printf "The roots of %.2fx² + %.2fx + %.2f\n\tx₀ = (%s)\n" x y z join(round.(quadroots(x, y, z), 2), ", ")
end
