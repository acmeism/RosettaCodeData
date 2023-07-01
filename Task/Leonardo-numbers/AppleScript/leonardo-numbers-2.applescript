-- spec: record containing none, some, or all of the 'L0', 'L1', and 'add' values.
on leonardos(spec, quantity)
    -- Assign the spec values to variables, using defaults for any not given.
    set {L0:a, L1:b, add:inc} to spec & {L0:1, L1:1, add:1}
    -- Build the output list.
    script o
        property output : {a, b}
    end script
    repeat (quantity - 2) times
        set c to a + b + inc
        set end of o's output to c
        set a to b
        set b to c
    end repeat

    return o's output
end leonardos

local output, astid
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
set output to "1st 25 Leonardos:
" & leonardos({}, 25) & "
1st 25 Fibonaccis:
" & leonardos({L0:0, L1:1, add:0}, 25)
set AppleScript's text item delimiters to astid
return output
