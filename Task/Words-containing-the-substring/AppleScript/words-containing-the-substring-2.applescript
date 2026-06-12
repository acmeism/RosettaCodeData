on wordsContaining(textFile, searchText, minLength)
    script o
        property textItems : missing value
        property output : {}
    end script

    -- Extract the text's search-text-delimited sections.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to searchText
    set o's textItems to text items of (read (textFile as alias) as «class utf8»)
    set AppleScript's text item delimiters to astid

    -- Reconstitute any words containing the search text from the stubs at the section ends and
    -- the search text itself, returning any results which meet the minimum length requirement.
    set thisSection to beginning of o's textItems
    set sectionHasWords to ((count thisSection's words) > 0)
    considering white space
        repeat with i from 2 to (count o's textItems)
            set foundWord to searchText
            if (sectionHasWords) then
                set thisStub to thisSection's last word
                if (thisSection ends with thisStub) then set foundWord to thisStub & foundWord
            end if
            set thisSection to item i of o's textItems
            set sectionHasWords to ((count thisSection's words) > 0)
            if (sectionHasWords) then
                set thisStub to thisSection's first word
                if (thisSection begins with thisStub) then set foundWord to foundWord & thisStub
            end if
            if (foundWord's length ≥ minLength) then set end of o's output to foundWord
        end repeat
    end considering

    return o's output
end wordsContaining
