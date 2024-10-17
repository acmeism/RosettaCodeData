function toposort(data::Dict{T,Set{T}}) where T
    data = copy(data)
    for (k, v) in data
        delete!(v, k)
    end
    extraitems = setdiff(reduce(∪, values(data)), keys(data))
    for item in extraitems
        data[item] = Set{T}()
    end
    rst = Vector{T}()
    while true
        ordered = Set(item for (item, dep) in data if isempty(dep))
        if isempty(ordered) break end
        append!(rst, ordered)
        data = Dict{T,Set{T}}(item => setdiff(dep, ordered) for (item, dep) in data if item ∉ ordered)
    end
    @assert isempty(data) "a cyclic dependency exists amongst $(keys(data))"
    return rst
end

data = Dict{String,Set{String}}(
    "des_system_lib" => Set(split("std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee")),
    "dw01" =>           Set(split("ieee dw01 dware gtech")),
    "dw02" =>           Set(split("ieee dw02 dware")),
    "dw03" =>           Set(split("std synopsys dware dw03 dw02 dw01 ieee gtech")),
    "dw04" =>           Set(split("dw04 ieee dw01 dware gtech")),
    "dw05" =>           Set(split("dw05 ieee dware")),
    "dw06" =>           Set(split("dw06 ieee dware")),
    "dw07" =>           Set(split("ieee dware")),
    "dware" =>          Set(split("ieee dware")),
    "gtech" =>          Set(split("ieee gtech")),
    "ramlib" =>         Set(split("std ieee")),
    "std_cell_lib" =>   Set(split("ieee std_cell_lib")),
    "synopsys" =>       Set(),
    )

println("# Topologically sorted:\n - ", join(toposort(data), "\n - "))
