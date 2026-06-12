on locationToWords({latitude, longitude}, listOfWords)
    script o
        property wordList : listOfWords
    end script

    set intLat to ((latitude + 90) * 10000) as integer
    set intLong to ((longitude + 180) * 10000) as integer
    set output to {intLat div 64, intLat mod 64 * 256 + intLong div 16384, intLong mod 16384}
    repeat with thisIndex in output
        set thisIndex's contents to item (thisIndex + 1) of o's wordList -- AppleScript indices are 1-based.
    end repeat

    return output
end locationToWords

on wordsToLocation(threeWords, listOfWords)
    script o
        property wordList : listOfWords
    end script

    set indices to {}
    repeat with thisWord in threeWords
        set thisWord to thisWord's contents
        set i to 1
        repeat until (item i of o's wordList is thisWord)
            set i to i + 1
            if (i > 28126) then error "wordsToLocation() handler: The word “" & thisWord & "” isn't in the word list."
        end repeat
        set end of indices to i - 1 -- Converted to 0-based index.
    end repeat
    set intLat to (beginning of indices) * 64 + (item 2 of indices) div 256 mod 64
    set intLong to (item 2 of indices) mod 256 * 16384 + (end of indices)

    return {intLat / 10000 - 90, intLong / 10000 - 180}
end wordsToLocation

-- Task code:
local o, location, threeWords, checkLocation
-- Use the words in unixdict.txt. It only has 25110 of them by AppleScript's count,
-- so make up the shortfall with invented plurals and third-persons-singular.
script
    property wordList : words of (read file ((path to desktop as text) & "unixdict.txt") as «class utf8»)
    property additionalWords : {}
end script
set o to result
repeat with i from 1 to (28126 - (count o's wordList))
    tell item i of o's wordList
        if (it ends with "s") then
            set end of o's additionalWords to it & "es"
        else
            set end of o's additionalWords to it & "s"
        end if
    end tell
end repeat
set o's wordList to o's wordList & o's additionalWords

set location to {28.3852, -81.5638}
set threeWords to locationToWords(location, o's wordList)
set checkLocation to wordsToLocation(threeWords, o's wordList)
return {location, threeWords, checkLocation}
