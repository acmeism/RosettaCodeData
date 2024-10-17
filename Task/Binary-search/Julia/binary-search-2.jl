function binarysearch(lst::Vector{T}, value::T, low=1, high=length(lst)) where T
    if isempty(lst) return 0 end
    if low ≥ high
        if low > high || lst[low] != value
            return 0
        else
            return low
        end
    end
    mid = (low + high) ÷ 2
    if lst[mid] > value
        return binarysearch(lst, value, low, mid-1)
    elseif lst[mid] < value
        return binarysearch(lst, value, mid+1, high)
    else
        return mid
    end
end
