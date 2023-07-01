-- Return a script object containing the main handlers.
-- It could be loaded as a library instead if there were any point in having such a library.
on getWorks()
    script theWorks
        property outerX11 : missing value
        property countLimit : missing value
        property to_skip : missing value
        property palcount : missing value
        property skipd : {{}, {}, {}, {}, {}, {}, {}, {}, {}}
        property skipdOuter : missing value
        property pals : missing value

        -- Work out the remainder from the division of the positive decimal integer value which is
        -- one or two instances of digit 'digit' separated by 'gap' zeros and followed by 'shift' zeros
        -- (which may not be realisable as an AppleScript number) by 'outerX11', a multiple of 11.
        on rmdr(digit, gap, shift)
            -- Remainders from the division of left-shifted decimals by multiples of 11 reliably repeat
            -- every six places shifted > 2, so use a dividend with the equivalent digit shifts < 9.
            set coefficient to 10 ^ ((shift - 3) mod 6 + 3)
            if (gap > -1) then set coefficient to coefficient + 10 ^ ((gap + shift - 2) mod 6 + 3)

            return (digit * coefficient mod outerX11) as integer
        end rmdr

        -- Recursively infer from remainder arithmetic any palindromic gapful numbers with
        -- ((count lhs) * 2 + gap) digits whose outer digit is the first value in lhs.
        -- Append text versions of any falling in the current keep range to the 'pals' list.
        on palindromicGapfuls(lhs, gap, remainder)
            -- lhs: eg {9, 4, 5} of a potential 945…549 result.
            -- gap: length of inner to be filled in
            -- remainder: remainder of outer, eg 9400049 mod 11, but derived from rmdr() results.
            set shift to (count lhs) --  left shift of inner (same as its right shift).
            -- This translation's 'skipd' is a four-deep AppleScript list structure indexed with the elements
            -- of the original dictionary's keys: (skipd) -> outermost digit -> shift -> gap -> remainder (+ 1).
            -- The outermost digit element doesn't change during a search based on it, so the script property
            -- 'skipdOuter' has been preset to skipd's outer-th sublist in the set-up for the current search.
            -- Populate it just enough here to ensure that the slot about to be checked for a 'skip' value exists.
            repeat (shift - (count my skipdOuter)) times
                set end of my skipdOuter to {}
            end repeat
            repeat (gap - (count item shift of my skipdOuter)) times
                set end of item shift of my skipdOuter to {}
            end repeat
            repeat (remainder + 1 - (count item gap of item shift of my skipdOuter)) times
                set end of item gap of item shift of my skipdOuter to missing value
            end repeat
            set skip to item (remainder + 1) of item gap of item shift of my skipdOuter
            if ((skip is missing value) or (palcount + skip > to_skip)) then
                set skip to 0
                set nextGap to gap - 2
                repeat with d from 0 to 9
                    set nextRem to (remainder + rmdr(d, nextGap, shift)) mod outerX11
                    if (gap > 2) then
                        set skip to skip + palindromicGapfuls(lhs & d, nextGap, nextRem)
                    else if (nextRem is 0) then
                        -- A palindrome of lhs's contents around gap ds would be … gapful.
                        set palcount to palcount + 1
                        if (palcount > to_skip) then
                            -- This one would be in the current keep range, so realise it as text and store it.
                            if (gap is 2) then set d to {d, d} -- Not d * 11 as d could be 0.
                            set end of my pals to (lhs & d & reverse of lhs) as text
                        else
                            set skip to skip + 1
                        end if
                    end if
                    if (palcount = countLimit) then exit repeat
                end repeat
                if (palcount < to_skip) then set item (remainder + 1) of item gap of item shift of my skipdOuter to skip
            else
                set palcount to palcount + skip
            end if

            return skip
        end palindromicGapfuls

        -- Set up a search for the last 'keep' of the first 'countLimit' PGNs > 100 whose outer digit is 'outer',
        -- call the recursive process for each palindrome width, and eventually return the stored numeric texts.
        on collect(outer, countLimit, keep)
            -- Initialise script object properties for the current search.
            set outerX11 to outer * 11
            set my countLimit to countLimit
            set to_skip to countLimit - keep
            set palcount to 0
            set skipdOuter to item outer of my skipd
            set pals to {}
            -- Also locals and TIDs.
            set lhs to {outer}
            set gap to 1 -- Number of digits between outer pair.
            set astid to AppleScript's text item delimiters
            set AppleScript's text item delimiters to "" -- For list-to-text coercions.
            repeat until (palcount = countLimit)
                set remainder to rmdr(outer, gap, 0)
                palindromicGapfuls(lhs, gap, remainder)
                set gap to gap + 1
            end repeat
            set AppleScript's text item delimiters to astid

            return pals
        end collect
    end script

    return theWorks
end getWorks

(* Test code *)

-- Return an integer as text with the appropriate English ordinal suffix
on ordinalise(n)
    -- Adapted from Victor Yee (adapted from NG (adapted from Jason Bourque) & Paul Skinner)
    set units to n mod 10
    if ((units > 3) or ((n - units) mod 100 is 10) or (units < 1) or (units mod 1 > 0)) then return (n as text) & "th"
    return (n as text) & item units of {"st", "nd", "rd"}
end ordinalise

on doTask()
    set tests to {{20, 20, 1, 9}, {100, 15, 1, 9}, {1000, 10, 1, 9}, {10000, 5, 1, 9}, ¬
        {100000, 1, 1, 9}, {1000000, 1, 1, 9}, {10000000, 1, 1, 9}, ¬
        {100000000, 1, 9, 9}, {1.0E+9, 1, 9, 9}, {1.0E+10, 1, 9, 9}, ¬
        {1.0E+11, 1, 9, 9}, {1.0E+12, 1, 9, 9}, ¬
        {1.0E+13, 1, 9, 9}, {1.0E+14, 1, 9, 9}, ¬
        {1.0E+15, 1, 2, 4}}
    -- set tests to {{20, 20, 1, 9}, {100, 15, 1, 9}, {1000, 10, 1, 9}} -- The RC task.

    set output to {}
    set theWorks to getWorks()
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "  "
    repeat with i from 1 to (count tests)
        set {countLimit, keep, firstOuter, lastOuter} to item i of tests
        if (countLimit = keep) then
            set h to "First " & countLimit
        else if (keep > 1) then
            set h to "Last " & keep & (" of first " & countLimit)
        else
            set h to ordinalise(countLimit)
        end if
        if ((keep = 1) and (firstOuter = lastOuter)) then
            set h to h & " palindromic gapful number > 100 ending with " & firstOuter & ":"
        else if (firstOuter = lastOuter) then
            set h to h & " palindromic gapful numbers > 100 ending with " & firstOuter & ":"
        else
            set h to h & " palindromic gapful numbers > 100 ending with digits from " & firstOuter & (" to " & lastOuter & ":")
        end if
        if (i > 1) then set end of output to ""
        set end of output to h
        repeat with outer from firstOuter to lastOuter
            set end of output to theWorks's (collect(outer, countLimit, keep)) as text
        end repeat
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end doTask

doTask()
