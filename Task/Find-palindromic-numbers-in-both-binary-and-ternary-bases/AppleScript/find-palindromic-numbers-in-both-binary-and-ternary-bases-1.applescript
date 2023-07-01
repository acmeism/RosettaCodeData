on intToText(int, base) -- Simple version for brevity.
    script o
        property digits : {int mod base as integer}
    end script

    set int to int div base
    repeat until (int = 0)
        set beginning of o's digits to int mod base as integer
        set int to int div base
    end repeat

    return join(o's digits, "")
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set output to {"0  0  0", "1  1  1"} -- Results for 0 and 1 taken as read.

    set b3Hi to 0 -- Integer value of a palindromic ternary number, minus its low end.
    set msdCol to 1 -- Column number (0-based) of its leftmost ternary digit.
    set lsdCol to 1 -- Column number of the high end's rightmost ternary digit.
    set lsdUnit to 3 ^ lsdCol as integer -- Value of 1 in this column.
    set lrdCol to 1 -- Column number of the rightmost hi end digit to mirror in the low end.
    set lrdUnit to 3 ^ lrdCol as integer -- Value of 1 in this column.
    set columnTrigger to 3 ^ (msdCol + 1) as integer -- Next value that will need an additional column.
    repeat until ((count output) = 6)
        -- Notionally increment the high end's rightmost column.
        set b3Hi to b3Hi + lsdUnit
        -- If this carries through to start an additional column, adjust the presets.
        if (b3Hi = columnTrigger) then
            set lrdCol to lrdCol + msdCol mod 2
            set lrdUnit to 3 ^ lrdCol as integer
            set msdCol to msdCol + 1
            set lsdCol to (msdCol + 1) div 2
            set lsdUnit to 3 ^ lsdCol as integer
            set columnTrigger to columnTrigger * 3
        end if
        -- Work out a mirroring low end value and add it in.
        set b3Lo to b3Hi div lrdUnit mod 3
        repeat with p from (lrdCol + 1) to msdCol
            set b3Lo to b3Lo * 3 + b3Hi div (3 ^ p) mod 3
        end repeat
        set n to b3Hi + b3Lo

        -- See if the result's palindromic in base 2 too. It must be an odd number and the value of the
        -- reverse of its low end (including any overlap) must match that of its truncated high end.
        set oL2b to n mod 2
        if (oL2b = 1) then
            set b2Hi to n
            repeat while (b2Hi > oL2b)
                set b2Hi to b2Hi div 2
                if (b2Hi > oL2b) then set oL2b to oL2b * 2 + b2Hi mod 2
            end repeat
            -- If it is, append its decimal, binary, and ternary representations to the output.
            if (b2Hi = oL2b) then ¬
                set end of output to join({intToText(n, 10), intToText(n, 2), intToText(n, 3)}, "  ")
        end if
    end repeat
    set beginning of output to "decimal  binary  ternary:"

    return join(output, linefeed)
end task

task()
