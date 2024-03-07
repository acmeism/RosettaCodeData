use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on textonyms(posixPath, query)
    set digits to "23456789"
    set keys to {"", "[abc]", "[def]", "[ghi]", "[jkl]", "[mno]", "[pqrs]", "[tuv]", "[wxyz]"}
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
        set || to current application
        set pathStr to (||'s NSString's stringWithString:(posixPath))'s ¬
            stringByExpandingTildeInPath()
        set {txt, err} to ||'s NSMutableString's stringWithContentsOfFile:(pathStr) ¬
            usedEncoding:(mv) |error|:(reference)
        if (err ≠ mv) then error (err's localizedDescription() as text)
    on error errMsg
        display alert "Textonyms handler: parameter error" message ¬
            errMsg as critical buttons {"Stop"} default button 1
        error number -128
    end try

    -- Lose obvious no-hope words.
    set regex to ||'s NSRegularExpressionSearch
    txt's replaceOccurrencesOfString:("\\R") withString:(LF) ¬
        options:(regex) range:({0, txt's |length|()})
    set |words| to txt's componentsSeparatedByString:(LF)
    if ((reporting) or (digitCount > 9)) then
        set predFormat to "(self MATCHES '(?i)[a-z]++')"
    else
        set predFormat to "(self MATCHES '(?i)[a-z]{" & digitCount & "}+')"
    end if
    set predicate to ||'s NSPredicate's predicateWithFormat:(predFormat)
    set |words| to |words|'s filteredArrayUsingPredicate:(predicate)
    set wordCount to |words|'s |count|()

    -- Derive digit combinations from the rest.
    set txt to (|words|'s componentsJoinedByString:(LF))'s mutableCopy()
    set range to {0, txt's |length|()}
    repeat with d in digits
        (txt's replaceOccurrencesOfString:("(?i)" & keys's item d) withString:(d) ¬
            options:(regex) range:(range))
    end repeat
    set combos to txt's componentsSeparatedByString:(LF)

    -- Return the appropriate result.
    if (reporting) then
        set comboSet to ||'s NSSet's setWithArray:(combos)
        set comboCount to comboSet's |count|()
        set textonymSet to ||'s NSCountedSet's alloc()'s initWithArray:(combos)
        textonymSet's minusSet:(comboSet)
        set textonymCount to textonymSet's |count|()
        set output to (wordCount as text) & " words in '" & ¬
            (pathStr's lastPathComponent()) & ¬
            "' can be represented by the digit key mapping." & ¬
            (LF & comboCount & " digit combinations are required to represent them.") & ¬
            (LF & textonymCount & " of the digit combinations represent Textonyms.")
    else
        set output to {}
        set range to {0, wordCount}
        set i to combos's indexOfObject:(query) inRange:(range)
        repeat until (i > wordCount)
            set output's end to (|words|'s objectAtIndex:(i)) as text
            set range to {i + 1, wordCount - (i + 1)}
            set i to combos's indexOfObject:(query) inRange:(range)
        end repeat
        if ((count output) = 1) then set output to {}
    end if

    return output
end textonyms

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

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
