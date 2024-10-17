function merge(sequence left, sequence right)
    sequence result
    result = {}
    while length(left) > 0 and length(right) > 0 do
        if compare(left[1], right[1]) <= 0 then
            result = append(result, left[1])
            left = left[2..$]
        else
            result = append(result, right[1])
            right = right[2..$]
        end if
    end while
    return result & left & right
end function

function mergesort(sequence m)
    sequence left, right
    integer middle
    if length(m) <= 1 then
        return m
    else
        middle = floor(length(m)/2)
        left = mergesort(m[1..middle])
        right = mergesort(m[middle+1..$])
        if compare(left[$], right[1]) <= 0 then
            return left & right
        elsif compare(right[$], left[1]) <= 0 then
            return right & left
        else
            return merge(left, right)
        end if
    end if
end function

constant s = rand(repeat(1000,10))
? s
? mergesort(s)
