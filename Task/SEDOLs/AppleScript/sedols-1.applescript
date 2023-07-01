on appendCheckDigitToSEDOL(sedol)
    if ((count sedol) is not 6) then ¬
        return {false, "Error in appendCheckDigitToSEDOL handler: " & sedol & " doesn't have 6 characters."}
    set chars to "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    set vowels to "AEIOU"
    set weights to {1, 3, 1, 7, 3, 9}

    set s to 0
    considering diacriticals but ignoring case -- In case these are set otherwise when this handler's called.
        repeat with i from 1 to 6
            set thisCharacter to character i of sedol
            set o to (offset of thisCharacter in chars)
            if ((o is 0) or (thisCharacter is in vowels)) then ¬
                return {false, "Error in appendCheckDigitToSEDOL handler: " & sedol & " contains invalid character(s)."}
            set s to s + (o - 1) * (item i of weights)
        end repeat
    end considering

    return {true, sedol & ((10 - (s mod 10)) mod 10)}
end appendCheckDigitToSEDOL

-- Test code:
set input to "710889
B0YBKJ
406566
B0YBLH
228276
B0YBKL
557910
B0YBKR
585284
B0YBKT
B00030"
set output to {}
repeat with thisSEDOL in paragraphs of input
    set {valid, theResult} to appendCheckDigitToSEDOL(thisSEDOL)
    set end of output to theResult
end repeat
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
