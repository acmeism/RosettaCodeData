function maxSubseq(sequence s)
    integer sum, maxsum, first, last
    maxsum = 0
    first = 1
    last = 0
    for i = 1 to length(s) do
        sum = 0
        for j = i to length(s) do
            sum += s[j]
            if sum > maxsum then
                maxsum = sum
                first = i
                last = j
            end if
        end for
    end for
    return s[first..last]
end function

? maxSubseq({-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1})
? maxSubseq({})
? maxSubseq({-1, -5, -3})
