use AppleScript version "2.3.1" -- OS X 10.9 (Mavericks) or later.
-- https://rosettacode.org/wiki/Sorting_algorithms/Quicksort#Straightforward
use sorter : script "Quicksort"
use scripting additions

on textonyms(posixPath, query)
    set digits to "23456789"
    set keys to {"", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"}
    set {mv, LF} to {missing value, linefeed}
    -- Check input.
    try
        set reporting to (query's class is not text)
        if (not reporting) then
            repeat with chr in query
                if (chr is not in digits) then error "Invalid digit input"
            end repeat
            set digitCount to (count query)
        end if
        script o
            property |words| : (do shell script ("cat " & posixPath))'s paragraphs
            property combos : mv
        end script
    on error errMsg
        display alert "Textonyms handler: parameter error" message ¬
            errMsg as critical buttons {"Stop"} default button 1
        error number -128
    end try

    ignoring case
        -- Lose obvious no-hope words.
        set alphabet to join(keys's rest, "")
        repeat with i from 1 to (count o's |words|)
            set wrd to o's |words|'s item i
            if ((reporting) or (wrd's length = digitCount)) then
                repeat with chr in wrd
                    if (chr is not in alphabet) then
                        set o's |words|'s item i to mv
                        exit repeat
                    end if
                end repeat
            else
                set o's |words|'s item i to mv
            end if
        end repeat
        set o's |words| to o's |words|'s every text
        set wordCount to (count o's |words|)

        -- Derive digit combinations from the rest.
        set txt to join(o's |words|, LF)
        repeat with d in digits
            set d to d's contents
            repeat with letter in keys's item d
                set txt to replaceText(txt, letter's contents, d)
            end repeat
        end repeat
        set o's combos to txt's paragraphs
    end ignoring

    -- Return the appropriate result
    considering case -- Case insensitivity not needed with digits.
        if (reporting) then
            tell sorter to sort(o's combos, 1, wordCount)
            set {previousCombo, comboCount, textonymCount, counting} to ¬
                {"", wordCount, 0, true}
            repeat with i from 1 to wordCount
                set thisCombo to o's combos's item i
                if (thisCombo = previousCombo) then
                    set comboCount to comboCount - 1
                    if (counting) then
                        set textonymCount to textonymCount + 1
                        set counting to false
                    end if
                else
                    set previousCombo to thisCombo
                    set counting to true
                end if
            end repeat
            set output to (wordCount as text) & " words in '" & ¬
                (do shell script ("basename " & posixPath)) & ¬
                "' can be represented by the digit key mapping." & ¬
                (LF & comboCount & " digit combinations are required to represent them.") & ¬
                (LF & textonymCount & " of the digit combinations represent Textonyms.")
        else
            set output to {}
            repeat with i from 1 to wordCount
                if (o's combos's item i = query) then set output's end to o's |words|'s item i
            end repeat
            if ((count output) = 1) then set output to {}
        end if
    end considering

    return output
end textonyms

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on replaceText(mainText, searchText, replacementText)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to searchText
    set textItems to mainText's text items
    set AppleScript's text item delimiters to replacementText
    set mainText to textItems as text
    set AppleScript's text item delimiters to astid
    return mainText
end replaceText

on task()
    set posixPath to "~/Desktop/www.rosettacode.org/unixdict.txt"
    set report to textonyms(posixPath, missing value)
    set output to {report, "", "Examples:"}
    repeat with digitCombo in {"729", "723353", "25287876746242"}
        set foundWords to textonyms(posixPath, digitCombo's contents)
        set output's end to digitCombo & " --> {" & join(foundWords, ", ") & "}"
    end repeat
    return join(output, linefeed)
end task

task()
