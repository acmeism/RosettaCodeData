on abcWords(wordFile, theLetters)
    -- The word file text is assumed to be UTF-8 encoded and to have one word per line.
    script o
        property wordList : paragraphs of (read wordFile as «class utf8»)
    end script

    set output to {}
    set letterCount to (count theLetters)
    set astid to AppleScript's text item delimiters
    repeat with thisWord in o's wordList
        set thisWord to thisWord's contents
        set thisLetter to end of theLetters
        if (thisWord contains thisLetter) then
            set matched to true
            repeat with c from (letterCount - 1) to 1 by -1
                set AppleScript's text item delimiters to thisLetter
                set thisLetter to item c of theLetters
                set matched to (thisWord's first text item contains thisLetter)
                if (not matched) then exit repeat
            end repeat
            if (matched) then set end of output to thisWord
        end if
    end repeat
    set AppleScript's text item delimiters to astid

    return output
end abcWords

return abcWords(((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as alias, {"a", "b", "c"})
