function binarySearch (list, value)
    local function search(low, high)
        if low > high then return false end
        local mid = math.floor((low+high)/2)
        if list[mid] > value then return search(low,mid-1) end
        if list[mid] < value then return search(mid+1,high) end
        return mid
    end
    return search(1,#list)
end
