include misc.e

function encode(sequence s)
    sequence out
    integer prev_char,count
    if length(s) = 0 then
        return {}
    end if
    out = {}
    prev_char = s[1]
    count = 1
    for i = 2 to length(s) do
        if s[i] != prev_char then
            out &= {count,prev_char}
            prev_char = s[i]
            count = 1
        else
            count += 1
        end if
    end for
    out &= {count,prev_char}
    return out
end function

function decode(sequence s)
    sequence out
    out = {}
    for i = 1 to length(s) by 2 do
        out &= repeat(s[i+1],s[i])
    end for
    return out
end function

sequence s
s = encode("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
pretty_print(1,s,{3})
puts(1,'\n')
puts(1,decode(s))
