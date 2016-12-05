function binary_search(sequence s, object val, integer low, integer high)
    integer mid, cmp
    if high < low then
        return 0 -- not found
    else
        mid = floor( (low + high) / 2 )
        cmp = compare(s[mid], val)
        if  cmp > 0 then
            return binary_search(s, val, low, mid-1)
        elsif cmp < 0 then
            return binary_search(s, val, mid+1, high)
        else
            return mid
        end if
    end if
end function
