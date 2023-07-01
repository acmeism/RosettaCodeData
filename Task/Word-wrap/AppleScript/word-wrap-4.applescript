use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on wrapParagraph(para, lineWidth)
    if (para is "") then return para
    set str to current application's class "NSMutableString"'s stringWithString:(para)
    -- Replace each run of up to (lineWidth - 1) characters followed by a space or a tab,
    -- or by the end of the paragraph, with itself and a LINE SEPARATOR character.
    tell str to replaceOccurrencesOfString:(".{1," & (lineWidth - 1) & "}(?:[ \\t]|\\Z)") withString:("$0" & character id 8232) ¬
        options:(current application's NSRegularExpressionSearch) range:({0, its |length|()})
    -- Remove the LINE SEPARATOR inserted at the end.
    tell str to replaceOccurrencesOfString:(character id 8232) withString:("") ¬
        options:(0) range:({(its |length|()) - 2, 2})

    return str as text
end wrapParagraph
