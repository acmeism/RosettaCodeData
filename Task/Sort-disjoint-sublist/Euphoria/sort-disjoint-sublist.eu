include sort.e

function uniq(sequence s)
    sequence out
    out = s[1..1]
    for i = 2 to length(s) do
        if not find(s[i], out) then
            out = append(out, s[i])
        end if
    end for
    return out
end function

function disjointSort(sequence s, sequence idx)
    sequence values
    idx = uniq(sort(idx))
    values = repeat(0, length(idx))
    for i = 1 to length(idx) do
        values[i] = s[idx[i]]
    end for
    values = sort(values)
    for i = 1 to length(idx) do
        s[idx[i]] = values[i]
    end for
    return s
end function

constant data = {7, 6, 5, 4, 3, 2, 1, 0}
constant indexes = {7, 2, 8}
