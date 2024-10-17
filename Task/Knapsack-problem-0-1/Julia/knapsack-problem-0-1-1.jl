struct KPDSupply{T<:Integer}
    item::String
    weight::T
    value::T
    quant::T
end

KPDSupply{T<:Integer}(itm::AbstractString, w::T, v::T, q::T=one(T)) = KPDSupply(itm, w, v, q)
Base.show(io::IO, kdps::KPDSupply) = print(io, kdps.quant, " ", kdps.item, " ($(kdps.weight) kg, $(kdps.value) €)")

using MathProgBase, Cbc
function solve(gear::Vector{<:KPDSupply}, capacity::Integer)
    w = getfield.(gear, :weight)
    v = getfield.(gear, :value)
    sol = mixintprog(-v, w', '<', capacity, :Bin, 0, 1, CbcSolver())
    gear[sol.sol .≈ 1]
end
