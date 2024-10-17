function flat_recursion(arr)
    res = []
    function grep(v)
        for x in v
            if x isa Array
                grep(x)
            else
                push!(res, x)
            end
        end
    end
    grep(arr)
    res
end
