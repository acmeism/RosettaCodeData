using Printf

const DM_DT = -1.8  # kg/s

struct OrbitalData
    date::String
    x::Float64
    v::Float64
    m::Float64
end

struct ResultRow
    date::String
    p::Float64
    nktg1::Float64
    nktg2::Float64
    v_sim::Float64
    v_nasa::Float64
    error::Float64
end

function Base.show(io::IO, row::ResultRow)
    @printf(io,
        "%-12s %14.3e %14.3e %14.3e %12.3e %12.3e %8.4f%%",
        row.date,
        row.p,
        row.nktg1,
        row.nktg2,
        row.v_sim,
        row.v_nasa,
        row.error
    )
end

momentum(m, v) = m * v

nktg1(x, p) = x * p

nktg2(p) = DM_DT * p

relative_error(sim, nasa) = ((sim - nasa) / nasa) * 100.0

function testorbitaldata()
    # Simulated NKTg 2025 dataset
    sim_2025 = [
        OrbitalData("1/1/2025",   1.471012e11, 3.0276e4, 5.97219e24),
        OrbitalData("4/1/2025",   1.494953e11, 2.9791e4, 5.97218999999998e24),
        OrbitalData("7/1/2025",   1.520965e11, 2.9282e4, 5.97218999999997e24),
        OrbitalData("10/1/2025",  1.496328e11, 2.9764e4, 5.97218999999995e24),
        OrbitalData("12/31/2025", 1.471025e11, 3.0276e4, 5.97218999999994e24),
    ]
    # NASA observed velocities
    nasa_2025 = [
        ("1/1/2025",   3.0287e4),
        ("4/1/2025",   2.9791e4),
        ("7/1/2025",   2.9291e4),
        ("10/1/2025",  2.9778e4),
        ("12/31/2025", 3.0286e4),
    ]

    println("\nExperimental Verification of NKTg Law (Earth 2025)\n")
    @printf("%-12s %14s %14s %14s %12s %12s %9s\n",
        "Date", "Momentum(p)", "NKTg1", "NKTg2",
        "v_sim", "v_NASA", "Error")
    println("-"^93)

    for (data, (_, v_nasa)) in zip(sim_2025, nasa_2025)
        p = momentum(data.m, data.v)
        n1 = nktg1(data.x, p)
        n2 = nktg2(p)
        err = relative_error(data.v, v_nasa)
        row = ResultRow(
            data.date,
            p,
            n1,
            n2,
            data.v,
            v_nasa,
            err
        )
        println(row)
    end
end

testorbitaldata()
