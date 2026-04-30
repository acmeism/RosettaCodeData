function to_base(integer i, integer base)
    integer rem
    sequence s
    s = ""
    while i > 0 do
        rem = remainder(i,base)
        if rem < 10 then
            s = prepend(s, '0'+rem)
        else
            s = prepend(s, 'a'-10+rem)
        end if
        i = floor(i/base)
    end while

    if length(s) = 0 then
        s = "0"
    end if

    return s
end function

function from_base(sequence s, integer base)
    integer i,d
    i = 0
    for n = 1 to length(s) do
        i *= base
        if s[n] >= '0' and s[n] <= '9' then
            d = s[n]-'0'
        elsif s[n] >= 'a' then
            d = s[n]-'a'+10
        end if
        i += d
    end for
    return i
end function
