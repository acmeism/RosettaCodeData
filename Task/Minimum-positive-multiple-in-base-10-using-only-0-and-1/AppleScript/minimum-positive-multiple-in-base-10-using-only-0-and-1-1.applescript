on b10(n)
    if (n < 1) then error
    -- Each factor of n that's either 10, 2, or 5 will contribute just a zero each to the end of the B10.
    -- Count and lose any such factors here to leave a potentially much smaller n (nx) to process.
    -- The relevant number of zeros will be appended to the shorter result afterwards.
    set nx to n
    set endZeroCount to 0
    repeat with factor in {10, 5, 2}
        repeat while (nx mod factor = 0)
            set endZeroCount to endZeroCount + 1
            set nx to nx div factor
        end repeat
    end repeat

    script o
        -- 'val' and 'pow' are uninformative and misleading labels for these lists, but I've
        -- kept them for code comparison purposes and because I can't think of anything better.
        property val : {} -- Will be successive powers of 10, mod nx.
        property pow : {} -- Initially nx placeholders, some or all of which will be replaced with indices to slots in val.
        property digits : {} -- Digits for output.
    end script

    if (nx = 1) then
        set end of o's digits to 1 -- Clever stuff not needed.
    else
        set placeholder to missing value
        repeat nx times
            set end of o's pow to placeholder
        end repeat

        -- Calculate successive powers of 10, mod nx, (hereafter "powers"), storing them in val and
        -- finding all the sums-mod-nx ("sums") that can be made from them and sums already obtained.
        -- The range of possible sums (0 to nx - 1) is represented by positions in pow (index = sum + 1
        -- with AppleScript's 1-based indices). Assign the index in val of the first power to produce
        -- each sum to pow's slot for that sum. Stop when the index of the current power turns up in
        -- pow's first slot, indicating that a subset of the powers obtained sums to nx (sum mod nx = 0)
        -- and thus that the sum of the corresponding /un/modded powers of 10 is a multiple of nx.

        -- The first power of 10 is always 1, its index in val is always 1, and its only possible sum is itself.
        set p10 to 1 -- 10 ^ 0 mod nx.
        set end of o's val to p10
        set valIndex to 1
        set item (p10 + 1) of o's pow to valIndex
        -- Subsequent settings depend on the value of nx.
        repeat until (beginning of o's pow = valIndex)
            -- Get the next power of 10, mod nx.
            set p10 to p10 * 10 mod nx
            set end of o's val to p10
            set valIndex to valIndex + 1
            -- "Add" it to any existing sums by inserting its val index into the pow slot p10 places after (mod nx)
            -- each slot already set for a lower-order p10, provided the target slot itself isn't already set.
            repeat with powIndex from 1 to nx
                set this to item powIndex of o's pow
                if (this is placeholder) then
                else if (this < valIndex) then
                    set targetIndex to (powIndex + p10 - 1) mod nx + 1
                    if (item targetIndex of o's pow is placeholder) then set item targetIndex of o's pow to valIndex
                end if
            end repeat
            -- Ensure that it's also treated as a sum in its own right.
            set targetIndex to p10 + 1
            if (item targetIndex of o's pow is placeholder) then set item targetIndex of o's pow to valIndex
        end repeat

        -- To identify the powers-mod-nx which summed to nx, use pow unnecessarily to look up the index
        -- of the power still in p10 which allowed the sum, subtract that power from the sum, use pow again
        -- to find the lower-order power that allowed what's left, and so on until the sum's reduced to 0.
        -- Append a 1 to the digit list for each power identified and a 0 each for any intervening ones.
        set sum to nx
        set previousIndex to 0
        repeat until (sum = 0)
            set valIndex to (item (sum mod nx + 1) of o's pow)
            repeat (previousIndex - valIndex - 1) times
                set end of o's digits to 0
            end repeat
            set end of o's digits to 1
            set previousIndex to valIndex
            set sum to (sum - (item valIndex of o's val) + nx) mod nx
        end repeat
    end if

    -- Append any trailing zeros due from factors removed at the beginning.
    repeat endZeroCount times
        set end of o's digits to 0
    end repeat

    -- Coerce the list of 1s and 0s to text.
    set bTen to join(o's digits, "")
    -- Replace the list's contents with the results of dividing by the original n.
    set digitCount to (count o's digits)
    set remainder to 0
    repeat with i from 1 to digitCount
        set dividend to remainder * 10 + (item i of o's digits)
        set item i of o's digits to dividend div n
        set remainder to dividend mod n
    end repeat
    -- Zap any leading zeros in the result and coerce what's left to text.
    repeat with i from 1 to digitCount
        if (item i of o's digits > 0) then exit repeat
        set item i of o's digits to ""
    end repeat
    set multiplier to join(o's digits, "")

    return {n:n, b10:bTen, multiplier:multiplier}
end b10

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

local output, n, bTen, multiplier
set output to {}
repeat with n in {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, ¬
    297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878}
    set {b10:bTen, multiplier:multiplier} to b10(n's contents)
    set end of output to (n as text) & " * " & multiplier & ("  =  " & bTen)
end repeat
return join(output, linefeed)
