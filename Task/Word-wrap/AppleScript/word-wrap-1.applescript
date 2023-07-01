on wrapParagraph(para, lineWidth)
    if (para is "") then return para
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to {space, tab} -- Doesn't include character id 160 (NO-BREAK SPACE).
    script o
        property wrds : para's text items -- Space- or tab-delimited chunks.
    end script

    set spaceWidth to (count space) -- ;-)
    set spaceLeft to lineWidth
    set theLines to {}
    set i to 1
    repeat with j from 1 to (count o's wrds)
        set wordWidth to (count item j of o's wrds)
        if (wordWidth + spaceWidth > spaceLeft) then
            set end of theLines to text 1 thru (-1 - wordWidth) of (text from text item i to text item j of para)
            set i to j
            set spaceLeft to lineWidth - wordWidth
        else
            set spaceLeft to spaceLeft - (wordWidth + spaceWidth)
        end if
    end repeat
    set end of theLines to text from text item i to end of para

    set AppleScript's text item delimiters to character id 8232 -- U+2028 (LINE SEPARATOR).
    set output to theLines as text
    set AppleScript's text item delimiters to astid

    return output
end wrapParagraph

local para
set para to "If there is a way to do this that is built-in, trivial, or provided in a standard library, show that. Otherwise implement the minimum length greedy algorithm from Wikipedia."
return wrapParagraph(para, 70) & (linefeed & linefeed) & wrapParagraph(para, 40)
