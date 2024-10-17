# v0.6

using Distributions

function eqdist(data::Vector{T}, α::Float64=0.05)::Bool where T <: Real
    if ! (0 ≤ α ≤ 1); error("α must be in [0, 1]") end
    exp = mean(data)
    chisqval = sum((x - exp) ^ 2 for x in data) / exp
    pval = ccdf(Chisq(2), chisqval)
    return pval > α
end

data1 = [199809, 200665, 199607, 200270, 199649]
data2 = [522573, 244456, 139979,  71531,  21461]

for data in (data1, data2)
    println("Data:\n$data")
    println("Hypothesis test: the original population is ", (eqdist(data) ? "" : "not "), "uniform.\n")
end
