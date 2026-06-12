on wordsContaining(textFile, searchText, minLength)
    -- Set up and execute a shell script which uses grep to find words containing the search text
    -- (matching AppleScript's current case-sensitivity setting) and awk to pass those which
    -- satisfy the minimum length requirement.
    if ("A" = "a") then
        set part1 to "grep -io "
    else
        set part1 to "grep -o "
    end if
    set shellCode to part1 & quoted form of ("\\b\\w*" & searchText & "\\w*\\b") & ¬
        (" <" & quoted form of textFile's POSIX path) & ¬
        (" | awk " & quoted form of ("// && length($0) >= " & minLength))

    return paragraphs of (do shell script shellCode)
end wordsContaining
