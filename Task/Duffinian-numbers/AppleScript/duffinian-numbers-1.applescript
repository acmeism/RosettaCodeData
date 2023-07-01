on aliquotSum(n)
    if (n < 2) then return 0
    set sum to 1
    set sqrt to n ^ 0.5
    set limit to sqrt div 1
    if (limit = sqrt) then
        set sum to sum + limit
        set limit to limit - 1
    end if
    repeat with i from 2 to limit
        if (n mod i is 0) then set sum to sum + i + n div i
    end repeat

    return sum
end aliquotSum

on hcf(a, b)
    repeat until (b = 0)
        set x to a
        set a to b
        set b to x mod b
    end repeat

    if (a < 0) then return -a
    return a
end hcf

on isDuffinian(n)
    set aliquot to aliquotSum(n) -- = sigma sum - n. = 1 if n's prime.
    return ((aliquot > 1) and (hcf(n, aliquot + n) = 1))
end isDuffinian

-- Task code:
on matrixToText(matrix, w)
    script o
        property matrix : missing value
        property row : missing value
    end script

    set o's matrix to matrix
    set padding to "          "
    repeat with r from 1 to (count o's matrix)
        set o's row to o's matrix's item r
        repeat with i from 1 to (count o's row)
            set o's row's item i to text -w thru end of (padding & o's row's item i)
        end repeat
        set o's matrix's item r to join(o's row, "")
    end repeat

    return join(o's matrix, linefeed)
end matrixToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task(duffTarget, tupTarget, tupSize)
    if ((duffTarget < 1) or (tupTarget < 1) or (tupSize < 2)) then error "Duff parameter(s)."
    script o
        property duffinians : {}
        property tuplets : {}
    end script

    -- Populate o's duffinians and tuplets lists.
    set n to 1
    set tuplet to {}
    repeat while (((count o's tuplets) < tupTarget) or ((count o's duffinians) < duffTarget))
        if (isDuffinian(n)) then
            if ((count o's duffinians) < duffTarget) then set end of o's duffinians to n
            if (tuplet ends with n - 1) then
                set end of tuplet to n
            else
                if ((count tuplet) = tupSize) then set end of o's tuplets to tuplet
                set tuplet to {n}
            end if
        end if
        set n to n + 1
    end repeat

    -- Format for output.
    set duffinians to {}
    repeat with i from 1 to duffTarget by 20
        set j to i + 19
        if (j > duffTarget) then set j to duffTarget
        set end of duffinians to items i thru j of o's duffinians
    end repeat
    set part1 to "First " & duffTarget & " Duffinian numbers:" & linefeed & ¬
        matrixToText(duffinians, (count (end of o's duffinians as text)) + 2)
    set tupletTypes to {missing value, "twins", "triplets:", "quadruplets:", "quintuplets:"}
    set part2 to "First " & tupTarget & " Duffinian " & item tupSize of tupletTypes & linefeed & ¬
        matrixToText(o's tuplets, (count (end of end of o's tuplets as text)) + 2)

    return part1 & (linefeed & linefeed & part2)
end task

return task(50, 20, 3) -- First 50 Duffinians, first 20 3-item tuplets.
