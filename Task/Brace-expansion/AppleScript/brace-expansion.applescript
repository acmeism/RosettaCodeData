use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on braceExpansion(textForExpansion)
    -- Massage the text to pass to a shell script: -
    -- Single-quote it to render everything in it initially immune from brace and file-system expansion.
    -- Include a return at the end to get a new line at the end of each eventual expansion.
    set textForExpansion to quoted form of (textForExpansion & return)
    -- Switch to ASObjC text for a couple of regex substitutions.
    set textForExpansion to current application's class "NSMutableString"'s stringWithString:(textForExpansion)
    -- Increase the escape level of every instance of /two/ backslashes (represented by eight in the
    -- AppleScript string for the search regex) and isolate each result inside its own quote marks.
    tell textForExpansion to replaceOccurrencesOfString:("\\\\\\\\") withString:("''$0$0''") ¬
        options:(current application's NSRegularExpressionSearch) range:({0, its |length|()})
    -- UNquote every run of braces and/or commas not now immediately preceded by a backslash.
    tell textForExpansion to replaceOccurrencesOfString:("(?<!\\\\)[{,}]++") withString:("'$0'") ¬
        options:(current application's NSRegularExpressionSearch) range:({0, its |length|()})

    -- Pass the massaged text to a shell script to be 'echo'-ed. Since a space will still be inserted
    -- between each expansion, also delete the space after each return in the result.
    -- Return a list of the individual expansions.
    return (do shell script ("echo " & textForExpansion & " | sed -E 's/([[:cntrl:]]) /\\1/g'"))'s paragraphs
end braceExpansion

-- Test:
set output to braceExpansion("~/{Downloads,Pictures}/*.{jpg,gif,png}") & ¬
    braceExpansion("It{{em,alic}iz,erat}e{d,}, please.") & ¬
    braceExpansion("{,{,gotta have{ ,\\, again\\, }}more }cowbell!") & ¬
    braceExpansion("{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}")
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid

log output -- To see the result without the backslash-escaping.
