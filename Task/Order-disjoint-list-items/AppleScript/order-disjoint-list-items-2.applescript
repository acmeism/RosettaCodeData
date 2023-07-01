(*
    The task description talks about items in lists, but the examples are space-delimited substrings of strings.
    The handler here deals with items in lists and leaves it to the calling code to sort out the rest.
*)
on odli(m, n)
    -- Use shallow copies of the lists in case the calling process wants the passed originals to remain intact.
    set m to m's items
    set n_source to n's items
    set n_check to n's items

    repeat with i from 1 to (count m)
        set thisItem to item i of m
        if ({thisItem} is in n_check) then
            set item i of m to beginning of n_source
            set n_source to rest of n_source
            if (n_source is {}) then exit repeat
            repeat with j from 1 to (count n_check)
                if (item j of n_check is thisItem) then
                    set item j of n_check to beginning of n_check
                    set n_check to rest of n_check
                    exit repeat
                end if
            end repeat
        end if
    end repeat

    return m
end odli

-- Task code:
set textPairs to {{"the cat sat on the mat", "mat cat"}, {"the cat sat on the mat", "cat mat"}, ¬
    {"A B C A B C A B C", "C A C A"}, {"A B C A B D A B E", "E A D A"}, ¬
    {"A B", "B"}, {"A B", "B A"}, {"A B B A", "B A"}}
set output to {}
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to space
repeat with thisPair in textPairs
    set {m, n} to thisPair
    set spiel to "Data M:  '" & m & "'\tOrder N:  '" & n & "'\t-->  '"
    set end of output to spiel & odli(m's text items, n's text items) & "'"
end repeat
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
