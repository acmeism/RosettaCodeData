function rms(sequence s)
    atom sum
    if length(s) = 0 then
        return 0
    end if
    sum = 0
    for i = 1 to length(s) do
        sum += power(s[i],2)
    end for
    return sqrt(sum/length(s))
end function

constant s = {1,2,3,4,5,6,7,8,9,10}
? rms(s)
