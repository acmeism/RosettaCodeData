constant data = {
    "Given$a$text$file$of$many$lines,$where$fields$within$a$line$",
    "are$delineated$by$a$single$'dollar'$character,$write$a$program",
    "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$",
    "column$are$separated$by$at$least$one$space.",
    "Further,$allow$for$each$word$in$a$column$to$be$either$left$",
    "justified,$right$justified,$or$center$justified$within$its$column."
}

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

function align(sequence s, integer width, integer alignment)
    integer n
    n = width - length(s)
    if n <= 0 then
        return s
    elsif alignment < 0 then
        return s & repeat(' ', n)
    elsif alignment > 0 then
        return repeat(' ', n) & s
    else
        return repeat(' ', floor(n/2)) & s & repeat(' ', floor(n/2+0.5))
    end if
end function

integer maxlen
sequence lines
maxlen = 0
lines = repeat(0,length(data))
for i = 1 to length(data) do
    lines[i] = split(data[i],'$')
    for j = 1 to length(lines[i]) do
        if length(lines[i][j]) > maxlen then
            maxlen = length(lines[i][j])
        end if
    end for
end for

for a = -1 to 1 do
    for i = 1 to length(lines) do
        for j = 1 to length(lines[i]) do
            puts(1, align(lines[i][j],maxlen,a) & ' ')
        end for
        puts(1,'\n')
    end for
    puts(1,'\n')
end for
