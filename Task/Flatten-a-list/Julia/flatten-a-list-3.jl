function flat_iterators(arr)
    while any(a -> a isa Array, arr)
        arr = collect(Iterators.flatten(arr))
    end
    arr
end
