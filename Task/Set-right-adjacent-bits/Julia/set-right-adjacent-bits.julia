function setrightadj(s, n)
    if n < 1
        return s
    else
       arr = reverse(collect(s))
       for (i, c) in enumerate(reverse(s))
           if c == '1'
               arr[max(1, i - n):i] .= '1'
           end
       end
       return String(reverse(arr))
    end
end

@show setrightadj("1000", 2)
@show setrightadj("0100", 2)
@show setrightadj("0010", 2)
@show setrightadj("0000", 2)

@show setrightadj("010000000000100000000010000000010000000100000010000010000100010010", 0)
@show setrightadj("010000000000100000000010000000010000000100000010000010000100010010", 1)
@show setrightadj("010000000000100000000010000000010000000100000010000010000100010010", 2)
@show setrightadj("010000000000100000000010000000010000000100000010000010000100010010", 3)
