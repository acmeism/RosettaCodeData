use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later
use sorter : script "Heap Sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Heapsort#AppleScript>

on uniqueCharactersInEachString(listOfStrings)
    script o
        property allCharacters : {}
        property uniques : {}

        on isInAllStrings(thisCharacter)
            repeat with thisString in listOfStrings
                if (thisCharacter is not in thisString) then return false
            end repeat

            return true
        end isInAllStrings
    end script

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set o's allCharacters to text items of (listOfStrings as text)
    set AppleScript's text item delimiters to astid

    set characterCount to (count o's allCharacters)
    tell sorter to sort(o's allCharacters, 1, characterCount)

    set i to 1
    set stringCount to (count listOfStrings)
    set currentCharacter to beginning of o's allCharacters
    repeat with j from 2 to characterCount
        set thisCharacter to item j of o's allCharacters
        if (thisCharacter is not currentCharacter) then
            if ((j - i = stringCount) and (o's isInAllStrings(currentCharacter))) then ¬
                set end of o's uniques to currentCharacter
            set i to j
            set currentCharacter to thisCharacter
        end if
    end repeat
    if ((j + 1 - i = stringCount) and (o's isInAllStrings(currentCharacter))) then ¬
        set end of o's uniques to currentCharacter

    return o's uniques
end uniqueCharactersInEachString

considering case
    uniqueCharactersInEachString({"1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"})
end considering
