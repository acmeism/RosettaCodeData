function split(sequence s, integer c)
    sequence out
    integer first, delim
    out = {}
    first = 1
    while first <= length(s) do
        delim = find_from(c, s, first)
        if delim = 0 then
            delim = length(s) + 1
        end if
        out = append(out, s[first..delim-1])
        first = delim + 1
    end while
    return out
end function

include get.e
function val(sequence s)
    sequence v
    v = value(s)
    return v[2] - v[1] * v[1]
end function

constant fn = open("mlijobs.txt", "r")
integer maxout
sequence jobs, line, maxtime
object x
jobs = {}
maxout = 0
while 1 do
    x = gets(fn)
    if atom(x) then
        exit
    end if
    line = split(x, ' ')
    line[$] = val(line[$])
    if equal(line[2], "OUT") then
        jobs &= line[$]
        if length(jobs) > maxout then
            maxout = length(jobs)
            maxtime = {line[4]}
        elsif length(jobs) = maxout then
            maxtime = append(maxtime, line[4])
        end if
    else
        jobs[find(line[$],jobs)] = jobs[$]
        jobs = jobs[1..$-1]
    end if
end while
close(fn)

printf(1, "Maximum simultaneous license use is %d at the following times:\n", maxout)
for i = 1 to length(maxtime) do
    printf(1, "%s\n", {maxtime[i]})
end for
