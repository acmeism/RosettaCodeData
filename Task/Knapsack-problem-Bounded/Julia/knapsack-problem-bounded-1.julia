using MathProgBase, Cbc

struct KPDSupply{T<:Integer}
    item::String
    weight::T
    value::T
    quant::T
end
Base.show(io::IO, kdps::KPDSupply) = print(io, kdps.quant, " ", kdps.item, " ($(kdps.weight) kg, $(kdps.value) €)")

function solve(gear::Vector{KPDSupply{T}}, capacity::Integer) where T<:Integer
    w = getfield.(gear, :weight)
    v = getfield.(gear, :value)
    q = getfield.(gear, :quant)
    sol = mixintprog(-v, w', '<', capacity, :Int, 0, q, CbcSolver())
    sol.status == :Optimal || error("this problem could not be solved")

    if all(q .== 1) # simpler case
        return gear[sol.sol == 1.0]
    else
        pack = similar(gear, 0)
        s = round.(Int, sol.sol)
        for (i, g) in enumerate(gear)
            iszero(s[i]) && continue
            push!(pack, KPDSupply(g.item, g.weight, g.value, s[i]))
        end
        return pack
    end
end
