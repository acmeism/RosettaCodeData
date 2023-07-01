using Base.Iterators

function bitmask(u, max_size)
    res = BitArray(undef, max_size)
    res.chunks[1] = u%UInt64
    res
end

function combinations(input_collection::Vector{T}, choice_size::Int)::Vector{Vector{T}} where T
    num_elements = length(input_collection)
    size_filter(x) = Iterators.filter(y -> count_ones(y) == choice_size, x)
    bitmask_map(x) = Iterators.map(y -> bitmask(y, num_elements), x)
    getindex_map(x) = Iterators.map(y -> input_collection[y], x)

    UnitRange(0, (2^num_elements)-1) |>
        size_filter  |>
        bitmask_map  |>
        getindex_map |>
        collect
end
