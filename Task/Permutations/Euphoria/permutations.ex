function reverse(sequence s, integer first, integer last)
    object x
    while first < last do
        x = s[first]
        s[first] = s[last]
        s[last] = x
        first += 1
        last -= 1
    end while
    return s
end function

function nextPermutation(sequence s)
    integer pos, last
    object x
    if length(s) < 1 then
        return 0
    end if

    pos = length(s)-1
    while compare(s[pos], s[pos+1]) >= 0 do
        pos -= 1
        if pos < 1 then
            return -1
        end if
    end while

    last = length(s)
    while compare(s[last], s[pos]) <= 0 do
        last -= 1
    end while
    x = s[pos]
    s[pos] = s[last]
    s[last] = x

    return reverse(s, pos+1, length(s))
end function

object s
s = "abcd"
puts(1, s & '\t')
while 1 do
    s = nextPermutation(s)
    if atom(s) then
        exit
    end if
    puts(1, s & '\t')
end while
