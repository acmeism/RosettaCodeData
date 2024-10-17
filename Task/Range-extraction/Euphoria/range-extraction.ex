function extract_ranges(sequence s)
    integer first
    sequence out
    out = ""
    if length(s) = 0 then
        return out
    end if
    first = 1
    for i = 2 to length(s) do
        if s[i] != s[i-1]+1 then
            if first = i-1 then
                out &= sprintf("%d,", s[first])
            elsif first = i-2 then
                out &= sprintf("%d,%d,", {s[first],s[i-1]})
            else
                out &= sprintf("%d-%d,", {s[first],s[i-1]})
            end if
            first = i
        end if
    end for
    if first = length(s) then
        out &= sprintf("%d", s[first])
    elsif first = length(s)-1 then
        out &= sprintf("%d,%d", {s[first],s[$]})
    else
        out &= sprintf("%d-%d", {s[first],s[$]})
    end if
    return out
end function

puts(1, extract_ranges({0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19,
    20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39}))
