on findWordsWhichContainsMoreThan3EVowels()
    script o
        property wrds : words of ¬
            (read file ((path to desktop as text) & "unixdict.txt") as «class utf8»)
    end script
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "e"
    repeat with thisWord in o's wrds
        set thisWord to thisWord's contents
        if (((count thisWord's text items) > 4) and not ¬
            ((thisWord contains "a") or (thisWord contains "i") or ¬
                (thisWord contains "o") or (thisWord contains "u"))) then
            set end of output to thisWord
        end if
    end repeat
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid
    return output
end findWordsWhichContainsMoreThan3EVowels

findWordsWhichContainsMoreThan3EVowels()
