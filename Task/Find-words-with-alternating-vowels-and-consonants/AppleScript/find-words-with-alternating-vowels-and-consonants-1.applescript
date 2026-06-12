(*
    With AppleScript's text item delimiters set to all the vowels, the 'text items' of a word with alternating
    vowels and consonants are single-character strings (the consonants), with the possibility of an empty
    string at the beginning and/or end representing a leading and/or trailing vowel.
*)

on findWordsWithAlternatingVowelsAndConsonants from theText given minLength:minLength, yAsVowel:yAsVowel
    script o
        property wordList : theText's words
        property output : {}
    end script

    set astid to AppleScript's text item delimiters
    if (yAsVowel) then
        set AppleScript's text item delimiters to {"a", "e", "i", "o", "u", "y"}
    else
        set AppleScript's text item delimiters to {"a", "e", "i", "o", "u"}
    end if
    ignoring case and diacriticals
        repeat with thisWord in o's wordList
            set thisWord to thisWord's contents
            if ((count thisWord) ≥ minLength) then
                set textItems to thisWord's text items
                set a to 1
                if ((count beginning of textItems) is 0) then set a to 2
                set b to (count textItems)
                if ((count end of textItems) is 0) then set b to b - 1
                repeat with i from a to b
                    set alternating to ((count item i of textItems) is 1)
                    if (not alternating) then exit repeat
                end repeat
                if (alternating) then set end of o's output to thisWord
            end if
        end repeat
    end ignoring
    set AppleScript's text item delimiters to astid
    return o's output
end findWordsWithAlternatingVowelsAndConsonants

-- Task code:
local theText
set theText to (read file ((path to desktop as text) & "unixdict.txt") as «class utf8»)
findWordsWithAlternatingVowelsAndConsonants from theText without yAsVowel given minLength:10
