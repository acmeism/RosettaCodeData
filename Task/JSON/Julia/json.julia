# Pkg.add("JSON") ... an external library http://docs.julialang.org/en/latest/packages/packagelist/
using JSON

sample = Dict()
sample["blue"] = [1, 2]
sample["ocean"] = "water"

@show sample jsonstring = json(sample)
@show jsonobj = JSON.parse(jsonstring)

@assert jsonstring == "{\"ocean\":\"water\",\"blue\":[1,2]}"
@assert jsonobj == Dict("ocean" => "water", "blue" => [1, 2])
@assert typeof(jsonobj) == Dict{String, Any}
