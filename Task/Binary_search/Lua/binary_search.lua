function binarySearch (list,value)
    local low = 1
    local high = #list
    local mid = 0
    while low <= high do
        mid = math.floor((low+high)/2)
        if list[mid] > value then high = mid - 1
        else if list[mid] < value then low = mid + 1
             else return mid
             end
        end
    end
    return false
end
