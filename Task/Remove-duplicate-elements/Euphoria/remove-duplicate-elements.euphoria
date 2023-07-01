include sort.e

function uniq(sequence s)
    sequence out
    s = sort(s)
    out = s[1..1]
    for i = 2 to length(s) do
        if not equal(s[i],out[$]) then
            out = append(out, s[i])
        end if
    end for
    return out
end function

constant s = {1, 2, 1, 4, 5, 2, 15, 1, 3, 4}
? s
? uniq(s)
