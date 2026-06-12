on hcf(a, b)
    repeat until (b = 0)
        set x to a
        set a to b
        set b to x mod b
    end repeat

    if (a < 0) then return -a
    return a
end hcf

on coprimeTriplets(max)
    if (max < 3) then return {}
    script o
        property candidates : {}
        property output : {1, 2}
    end script

    -- When repeatedly searching for lowest unused numbers, it's faster in
    -- AppleScript to take numbers from a preset list of candidates which
    -- grows shorter from at or near the low end as used numbers are removed
    -- than it is to test increasing numbers of previous numbers each time
    -- against a list that's growing longer with them.
    -- Generate the list of candidates here.
    repeat with i from 3 to max
        set end of o's candidates to i
    end repeat
    set candidateCount to max - 2
    set {p1, p2} to o's output
    set ok to true
    repeat while (ok) -- While suitable coprimes found and candidates left.
        repeat with i from 1 to candidateCount
            set q to item i of o's candidates
            set ok to ((hcf(p1, q) is 1) and (hcf(p2, q) is 1))
            if (ok) then -- q is coprime with both p1 and p2.
                set end of o's output to q
                set p1 to p2
                set p2 to q
                -- Remove q from the candidate list.
                set item i of o's candidates to missing value
                set o's candidates to o's candidates's numbers
                set candidateCount to candidateCount - 1
                set ok to (candidateCount > 0)
                exit repeat
            end if
        end repeat
    end repeat

    return o's output
end coprimeTriplets

-- Task code:
return coprimeTriplets(49)
