stripChar("She was a soul stripper. She took my heart!", "aei")

on stripChar(str, chrs)
    tell AppleScript
        set oldTIDs to text item delimiters
        set text item delimiters to characters of chrs
        set TIs to text items of str
        set text item delimiters to ""
        set str to TIs as string
        set text item delimiters to oldTIDs
    end tell
    return str
end stripChar
