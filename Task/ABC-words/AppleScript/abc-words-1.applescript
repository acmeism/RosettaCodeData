on abcWords(wordFile)
    -- The word file text is assumed to be UTF-8 encoded and to have one word per line.
    script o
        property wordList : paragraphs of (read wordFile as «class utf8»)
    end script

    set output to {}
    repeat with thisWord in o's wordList
        set thisWord to thisWord's contents
        if ((thisWord contains "c") and ¬
            (text 1 thru (offset of "c" in thisWord) of thisWord contains "b") and ¬
            (text 1 thru (offset of "b" in thisWord) of thisWord contains "a")) then ¬
            set end of output to thisWord
    end repeat

    return output
end abcWords

return abcWords(((path to desktop as text) & "www.rosettacode.org:unixdict.txt") as alias)
