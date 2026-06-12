use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on redact(theText, redactionTargets, options)
    set |⌘| to current application
    -- Set up a regex search pattern for the target or list of targets supplied.
    -- Since it has to be able to match grapheme characters which may be combinations of
    -- others in the same string, include catches for "Zero Width Joiner" characters.
    set targets to |⌘|'s class "NSMutableArray"'s arrayWithArray:(redactionTargets as list)
    repeat with thisTarget in targets
        set thisTarget's contents to (|⌘|'s class "NSRegularExpression"'s escapedPatternForString:(thisTarget))
    end repeat
    set targetPattern to "(?<!\\u200d)(?:" & (targets's componentsJoinedByString:("|")) & ")(?!\\u200d)"
    -- If necessary, modify the pattern according to the requested options. Only "w", "o", "i", and "s" need attention.
    if (options contains "w") then
        -- Don't match where preceded or followed by either a hyphen or anything which isn't punctuation or white space.
        set targetPattern to "(?<![-[^[:punct:]\\s]])" & targetPattern & "(?![-[^[:punct:]\\s]])"
    else if (options contains "o") then
        -- Include any preceding or following run of hyphens and/or non-(punctuation or white-space).
        set targetPattern to "[-[^[:punct:]\\s]]*" & targetPattern & "[-[^[:punct:]\\s]]*+"
    end if
    -- Default to case-insensitivity as in vanilla AppleScript unless otherwise indicated by option or AS 'considering' attribute.
    if ((options contains "i") or ((options does not contain "s") and ("i" = "I"))) then ¬
        set targetPattern to "(?i)" & targetPattern

    -- Locate all the matches in the text.
    set mutableText to |⌘|'s class "NSMutableString"'s stringWithString:(theText)
    set regexObject to |⌘|'s class "NSRegularExpression"'s regularExpressionWithPattern:(targetPattern) ¬
        options:(0) |error|:(missing value)
    set matchObjects to regexObject's matchesInString:(mutableText) options:(0) range:({0, mutableText's |length|()})
    set matchRanges to matchObjects's valueForKey:("range")
    -- Replace each character or grapheme in the matched ranges with "X".
    set regexSearch to |⌘|'s NSRegularExpressionSearch
    repeat with i from (count matchRanges) to 1 by -1
        tell mutableText to replaceOccurrencesOfString:(".(?:\\u200d.)*+") withString:("X") ¬
            options:(regexSearch) range:(item i of matchRanges)
    end repeat

    return mutableText as text
end redact

-- Test code:
set theText to "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom."
set output to {}
repeat with redactionTarget in {"Tom", "tom"}
    set end of output to "Redact " & redactionTarget & ":"
    repeat with options in {"[w|s|n]", "[w|i|n]", "[p|s|n]", "[p|i|n]", "[p|s|o]", "[p|i|o]"}
        set end of output to options & ": " & redact(theText, redactionTarget, options)
    end repeat
    set end of output to ""
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
