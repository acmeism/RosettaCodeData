function split(sequence s, integer c)
    sequence out
    integer first, delim
    out = {}
    first = 1
    while first<=length(s) do
        delim = find_from(c,s,first)
        if delim = 0 then
            delim = length(s)+1
        end if
        out = append(out,s[first..delim-1])
        first = delim + 1
    end while
    return out
end function

sequence s
s = split("Hello,How,Are,You,Today", ',')

for i = 1 to length(s) do
    puts(1, s[i] & ',')
end for
