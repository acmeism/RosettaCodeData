function _ciclesort!(arr::Vector, lo::Int, hi::Int, swaps::Int)
    lo == hi && return swaps
    high = hi
    low  = lo
    mid  = (hi - lo) ÷ 2
    while lo < hi
        if arr[lo] > arr[hi]
            arr[lo], arr[hi] = arr[hi], arr[lo]
            swaps += 1
        end
        lo += 1
        hi -= 1
    end
    if lo == hi
        if arr[lo] > arr[hi+1]
            arr[lo], arr[hi+1] = arr[hi+1], arr[lo]
            swaps += 1
        end
    end
    swaps = _ciclesort!(arr, low, low + mid, swaps)
    swaps = _ciclesort!(arr, low + mid + 1, high, swaps)
    return swaps
end

function ciclesort!(arr::Vector)
    while !iszero(_ciclesort!(arr, 1, endof(arr), 0)) end
    return arr
end

v = rand(10)
println("# $v\n -> ", ciclesort!(v))
