using Base.Iterators

function bitmask(u, max_size)
    res = BitArray(undef, max_size)
    res.chunks[1] = u%UInt64
    res
end

function powerset(input_collection::Vector{T})::Vector{Vector{T}} where T
    num_elements = length(input_collection)
    bitmask_map(x) = Iterators.map(y -> bitmask(y, num_elements), x)
    getindex_map(x) = Iterators.map(y -> input_collection[y], x)

    UnitRange(0, (2^num_elements)-1) |>
        bitmask_map |>
        getindex_map |>
        collect
end
