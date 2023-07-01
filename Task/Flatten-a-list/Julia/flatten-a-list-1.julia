isflat(x) = isempty(x) || first(x) === x

function flat_mapreduce(arr)
    mapreduce(vcat, arr, init=[]) do x
        isflat(x) ? x : flat(x)
    end
end
