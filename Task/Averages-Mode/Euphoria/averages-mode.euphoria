include misc.e

function mode(sequence s)
    sequence uniques, counts, modes
    integer j,max
    uniques = {}
    counts = {}
    for i = 1 to length(s) do
        j = find(s[i], uniques)
        if j then
            counts[j] += 1
        else
            uniques = append(uniques, s[i])
            counts  = append(counts, 1)
        end if
    end for

    max = counts[1]
    for i = 2 to length(counts) do
        if counts[i] > max then
            max = counts[i]
        end if
    end for

    j = 1
    modes = {}
    while j <= length(s) do
        j = find_from(max, counts, j)
        if j = 0 then
            exit
        end if
        modes = append(modes, uniques[j])
        j += 1
    end while
    return modes
end function

constant s = { 1, "blue", 2, 7.5, 5, "green", "red", 5, 2, "blue", "white" }
pretty_print(1,mode(s),{3})
