using LinearAlgebra

"""
    Calculate the NKTg value for a given data matrix and ΔmassΔtime parameter.
    The δmδt parameter is a small correction factor that accounts for a change
    in mass over time such as that seen with micro gas loss to space.
"""
function nktg(dmat::Matrix{Float64}, δmδt::Float64)
    x = dmat[:, 1]
    v = dmat[:, 2]
    m = dmat[:, 3]

    # Momentum magnitude
    pabs = abs.(m .* v)

    # Common geometric factor
    geom = sqrt.(x.^2 .+ δmδt^2)

    # Final NKTg
    NKTg = pabs .* geom

    println("\nInput Matrix D = ")
    println(dmat)
    println("\nMomentum magnitude |p| = ")
    println(pabs)
    println("\nGeometric factor sqrt(x^2 + δmδt^2) = ")
    println(geom)
    println("\nTotal NKTg = ")
    println(NKTg, "\n")

    return NKTg
end

""" Run the Neptune experiment using data from 2023 and 2024. """
function neptunexperiment()
    println("\n============================================")
    println("NKTg Law - Neptune 2023 NASA Data")
    println("============================================")

    ΔmΔt = -0.00002000
    data2023 = [
        4498396440.0  5.43  1.02430000e26;
        4503443661.0  5.43  1.02429980e26;
        4553946490.0  5.43  1.02429960e26;
        4503443661.0  5.43  1.02429940e26;
        4498396440.0  5.43  1.02429920e26
    ]
    nktg(data2023, ΔmΔt)
    println("\n============================================")
    println("NKTg Law - Neptune 2024 Simulation")
    println("============================================")

    data2024 = [
        4498396440.0  5.43  1.02429900e26;
        4503443661.0  5.43  1.02429880e26;
        4553946490.0  5.43  1.02429860e26;
        4503443661.0  5.43  1.02429840e26;
        4498396440.0  5.43  1.02429820e26
    ]
    nktg(data2024, ΔmΔt)
    println("============================================")
    println("Experiment Completed")
    println("============================================")
end

neptunexperiment()
