""" Struct to hold data testing NKTG law on varying inertia related stability measures. """
struct NKTG
    p::Float64
    nktg1::Float64
    nktg2::Float64
    tendency1::String
    tendency2::String
    function NKTG(x, v, m, dm_dt)
        p = m * v
        n1 = x * p
        n2 = dm_dt * p
        return new(p, n1, n2, tendency1(n1), tendency2(n2))
    end
end

""" Custom show method for NKTG struct, for output formatting. """
function Base.show(io::IO, n::NKTG)
    println(io, "{ p = $(n.p)\n  nktg1 = $(n.nktg1)\n  nktg2 = $(n.nktg2)")
    println(io, "  tendency1=\"$(n.tendency1)\"\n  tendency2=\"$(n.tendency2)\" }")
end

""" Relates signs to type 1 tendencies (single-expression bodies) """
function tendency1(n)
    n > 0.0  ? "Moving away from stable state" :
    n < 0.0  ? "Moving toward stable state" :
               "Stable equilibrium"
end

""" Relates signs to type 2 tendencies (single-expression bodies) """
function tendency2(n)
    n > 0.0  ? "Mass variation supports movement" :
    n < 0.0  ? "Mass variation resists movement" :
               "No mass variation effect"
end

# Example usage of the NKTG struct and its custom show method.
println(NKTG(2.0, 3.0, 4.0, -0.5))
