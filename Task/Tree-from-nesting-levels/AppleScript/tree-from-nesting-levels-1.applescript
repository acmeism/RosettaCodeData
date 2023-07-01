on treeFromNestingLevels(input)
    set maxLevel to 0
    repeat with thisLevel in input
        if (thisLevel > maxLevel) then set maxLevel to thisLevel
    end repeat
    if (maxLevel < 2) then return input

    set emptyList to {}
    repeat with testLevel from maxLevel to 2 by -1
        set output to {}
        set subnest to {}
        repeat with thisLevel in input
            set thisLevel to thisLevel's contents
            if ((thisLevel's class is integer) and (thisLevel < testLevel)) then
                if (subnest ≠ emptyList) then set subnest to {}
                set end of output to thisLevel
            else
                if (subnest = emptyList) then set end of output to subnest
                set end of subnest to thisLevel
            end if
        end repeat
        set input to output
    end repeat

    return output
end treeFromNestingLevels

-- Task code:
local output, astid, input, part1, errMsg
set output to {}
set astid to AppleScript's text item delimiters
repeat with input in {{}, {1, 2, 4}, {3, 1, 3, 1}, {1, 2, 3, 1}, {3, 2, 1, 3}, {3, 3, 3, 1, 1, 3, 3, 3}}
    set input to input's contents
    set AppleScript's text item delimiters to ", "
    set part1 to "{" & input & "} nests to:  {"
    -- It's a pain having to parse nested lists to text, so throw a deliberate error and parse the error message instead.
    try
        || of treeFromNestingLevels(input)
    on error errMsg
        set AppleScript's text item delimiters to {"{", "}"}
        set end of output to part1 & ((text from text item 2 to text item -2 of errMsg) & "}")
    end try
end repeat
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
