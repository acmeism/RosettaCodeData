function flat1(arr)
    rst = Any[]
    grep(v) = for x in v
        if isa(x, Array) grep(x) else push!(rst, x) end
    end
    grep(arr)
    rst
end
