using Printf

""" Planet struct to hold planetary data """
struct Planet
    name::String
    x::Float64      # position (km)
    v::Float64      # velocity (km/s)
    m::Float64      # NASA mass (kg)
end

momentum(p::Planet) = p.m * p.v
NKTg1(p::Planet) = p.x * momentum(p)
interpolated_mass(p::Planet) = NKTg1(p) / (p.x * p.v)
deltam(p::Planet) = p.m - interpolated_mass(p)
isapproxzero(delta) = isapprox(abs(delta), 0.0, atol = 1e-6)

function verify_nktg()
    # NASA data 30/12/2024
    planets = [
        Planet("Mercury", 6.9817930e7, 38.86, 3.301e23),
        Planet("Venus", 1.0893900e8, 35.02, 4.867e24),
        Planet("Earth", 1.4710000e8, 29.29, 5.972e24),
        Planet("Mars", 2.4923000e8, 24.07, 6.417e23),
        Planet("Jupiter", 8.1662000e8, 13.06, 1.898e27),
        Planet("Saturn", 1.5065300e9, 9.69, 5.683e26),
        Planet("Uranus", 3.0013900e9, 6.8, 8.681e25),
        Planet("Neptune", 4.5589000e9, 5.43, 1.024e26),
    ]

    NKTg1_values = NKTg1.(planets)
    m_interpolated = interpolated_mass.(planets)
    delta_m = deltam.(planets)
    zeros = isapproxzero.(delta_m)

    println("=== NKTg Law Verification (31/12/2024) ===\n")
    println("Planet     NKTg1            Interpolated m   NASA m           Delta m          ≈ 0 ?")
    println("-"^85)
    for (i, p) in enumerate(planets)
        @printf("%-10s %-16.6e %-16.6e %-16.6e %-16.6e %s\n",
            p.name, NKTg1_values[i], m_interpolated[i], p.m, delta_m[i], zeros[i] ? "Yes" : "No")
    end

    println("\nConclusion: If Delta m ≈ 0, interpolation is exact.")
end

verify_nktg()
