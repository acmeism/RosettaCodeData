using Printf

""" Ecapsulate data used in NKTg₁ and NKTg₂ calculations for Mercury's orbit """
struct MercuryData
    date::String
    x::Float64 # position (m)
    v::Float64 # velocity (m/s)
    m::Float64 # mass (kg)
end

""" Perform the Mercury experiment using NASA data and NKTg calculations. """
function mercuryexperiment()
    # 1. NASA 2024 Reference Data
    reference_2024 = MercuryData("31/12/2024", 4.64e10, 5.81e4, 3.30e23)

    p_ref = reference_2024.m * reference_2024.v
    nktg1_constant = reference_2024.x * p_ref

    @printf("NKTg₁ reference constant: %3e\n", nktg1_constant)
    println("========================================\n")

    # 2. NASA 2025 Real Data
    nasa_2025 = [
        MercuryData("01/01/2025", 5.16e10, 5.34e4, 3.30e23),
        MercuryData("01/04/2025", 6.97e10, 3.89e4, 3.30e23),
        MercuryData("01/07/2025", 5.49e10, 5.04e4, 3.30e23),
        MercuryData("01/10/2025", 6.83e10, 3.98e4, 3.30e23),
        MercuryData("31/12/2025", 4.61e10, 5.89e4, 3.30e23),
    ]

    # Mass variation rate (MESSENGER data)
    dm_dt = -0.5 # kg/s

    println("Date        v_NKTg     v_NASA      Rel.Error(%)    NKTg₂∇")
    println("-----------------------------------------------------------------------\n")

    for data in nasa_2025
        # Interpolated velocity from constant NKTg1
        v_nktg = nktg1_constant / (data.x * data.m);

        # Relative error
        rel_error = ((v_nktg - data.v) / data.v) * 100.0;

        # Momentum
        p = data.m * v_nktg;

        # NKTg2 calculation
        nktg2 = dm_dt * p;

        @printf("%10s %10.3e %10.3e %10.4f %16.3e\n",
            data.date,
            v_nktg,
            data.v,
            rel_error,
            nktg2)
    end

    println("\n========================================\n")
    println("Interpretation:");
    println("NKTg₁ maintained as constant.");
    println("NKTg₂ negative → mass variation resists motion.");
end

mercuryexperiment()
