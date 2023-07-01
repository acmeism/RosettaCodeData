function min(sequence s)
    atom m
    m = s[1]
    for i = 2 to length(s) do
        if s[i] < m then
            m = s[i]
        end if
    end for
    return m
end function

function levenshtein(sequence s1, sequence s2)
    integer n, m
    sequence d
    n = length(s1) + 1
    m = length(s2) + 1

    if n = 1  then
        return m-1
    elsif m = 1 then
        return n-1
    end if

    d = repeat(repeat(0, m), n)
    for i = 1 to n do
        d[i][1] = i-1
    end for

    for j = 1 to m do
        d[1][j] = j-1
    end for

    for i = 2 to n do
        for j = 2 to m do
            d[i][j] = min({
                d[i-1][j] + 1,
                d[i][j-1] + 1,
                d[i-1][j-1] + (s1[i-1] != s2[j-1])
            })
        end for
    end for

    return d[n][m]
end function

? levenshtein("kitten", "sitting")
? levenshtein("rosettacode", "raisethysword")
