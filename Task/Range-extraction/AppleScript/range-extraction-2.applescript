(*
    The task description doesn't explicitly state that the integers are unique or what to do if they're not.
    This script treats runs of equal integers as single instances of those integers.
*)

on rangeDescription(orderedListOfIntegers)
    script o
        property lst : orderedListOfIntegers
        property entries : {}

        on addEntry(startInt, endInt)
            set rangeDifference to endInt - startInt
            if (rangeDifference > 1) then
                set end of my entries to (startInt as text) & "-" & endInt
            else if (rangeDifference is 1) then
                set end of my entries to (startInt as text) & "," & endInt
            else
                set end of my entries to startInt
            end if
        end addEntry
    end script

    -- if ((orderedListOfIntegers's class is not list) or ((count o's lst's integers) < (count orderedListOfIntegers))) then error

    -- Work through the list, identifying gaps in the sequence and adding range or individual results to o's entries.
    set startInt to beginning of o's lst
    set endInt to startInt
    repeat with i from 2 to (count orderedListOfIntegers)
        set thisInt to item i of o's lst
        if (thisInt - endInt > 1) then
            tell o to addEntry(startInt, endInt)
            set startInt to thisInt
        end if
        set endInt to thisInt
    end repeat
    tell o to addEntry(startInt, thisInt)

    -- Coerce the entries list to text using a comma delimiter.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ","
    set output to o's entries as text
    set AppleScript's text item delimiters to astid

    return output
end rangeDescription

-- Test code:
set listOfIntegers to {0, 1, 2, 4, 6, 7, 8, 11, 12, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 35, 36, 37, 38, 39}
return rangeDescription(listOfIntegers)
