function binarySearch (list,value)
    local low = 1
    local high = #list
    while low <= high do
        local mid = math.floor((low+high)/2)
        if list[mid] > value then high = mid - 1
        elseif list[mid] < value then low = mid + 1
        else return mid
        end
    end
    return false
end
