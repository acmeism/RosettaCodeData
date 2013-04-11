function merge(sequence left, sequence right)
    sequence result
    result = {}
    while length(left) > 0 and length(right) > 0 do
        if left[$] <= right[1] then
            exit
        elsif right[$] <= left[1] then
            return result & right & left
        elsif left[1] < right[1] then
            result = append(result,left[1])
            left = left[2..$]
        else
            result = append(result,right[1])
            right = right[2..$]
        end if
    end while
    return result & left & right
end function

function strand_sort(sequence s)
    integer j
    sequence result
    result = {}
    while length(s) > 0 do
        j = length(s)
        for i = 1 to length(s)-1 do
            if s[i] > s[i+1] then
                j = i
                exit
            end if
        end for

        result = merge(result,s[1..j])
        s = s[j+1..$]
    end while
    return result
end function

constant s = rand(repeat(1000,10))
puts(1,"Before: ")
? s
puts(1,"After:  ")
? strand_sort(s)
