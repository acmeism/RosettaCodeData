on wordsContaining(textfile, searchText, minLength)
    script o
        property wordList : missing value
        property output : {}
    end script

    -- Extract the text's 'words' and return any that meet both the search text and minimum length requirements.
    set o's wordList to words of (read (textfile as alias) as «class utf8»)
    repeat with thisWord in o's wordList
        if ((thisWord contains searchText) and (thisWord's length ≥ minLength)) then
            set end of o's output to thisWord's contents
        end if
    end repeat

    return o's output
end wordsContaining
