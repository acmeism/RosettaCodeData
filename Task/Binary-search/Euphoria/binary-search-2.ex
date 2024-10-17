function binary_search(sequence s, object val)
    integer low, high, mid, cmp
    low = 1
    high = length(s)
    while low <= high do
        mid = floor( (low + high) / 2 )
        cmp = compare(s[mid], val)
        if cmp > 0 then
            high = mid - 1
        elsif cmp < 0 then
            low = mid + 1
        else
            return mid
        end if
    end while
    return 0 -- not found
end function
