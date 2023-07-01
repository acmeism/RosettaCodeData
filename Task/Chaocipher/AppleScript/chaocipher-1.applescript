-- Chaocipher algorithm by J.F.Byrne 1918.
on chaocipher(input, |key|, mode)
    -- input: text to be enciphered or deciphered.
    -- |key|: script object or record with leftAlpha and rightAlpha properties, each of whose values is a shuffled alphabet text.
    -- mode: the text "encipher" or "decipher".
    script o
        property inputChars : input's characters
        property leftAlpha : |key|'s leftAlpha's characters
        property rightAlpha : |key|'s rightAlpha's characters
        property inAlpha : leftAlpha
        property outAlpha : rightAlpha
        property output : {}
    end script

    set alphaLen to (count o's leftAlpha)
    if ((count o's rightAlpha) ≠ alphaLen) then error
    if (mode is "encipher") then
        set {o's inAlpha, o's outAlpha} to {o's rightAlpha, o's leftAlpha}
    else if (mode is not "decipher") then
        error
    end if
    set zenith to 1
    set nadir to alphaLen div 2 + 1
    repeat with char in o's inputChars
        set char to char's contents
        set found to false
        repeat with i from 1 to alphaLen
            if (o's inAlpha's item i = char) then
                set end of o's output to o's outAlpha's item i
                set found to true
                exit repeat
            end if
        end repeat
        if (found) then
            rotate(o's leftAlpha, zenith, alphaLen, -(i - zenith))
            rotate(o's leftAlpha, zenith + 1, nadir, -1)
            rotate(o's rightAlpha, zenith, alphaLen, -i)
            rotate(o's rightAlpha, zenith + 2, nadir, -1)
        end if
    end repeat

    return join(o's output, "")
end chaocipher

on rotate(theList, l, r, amount)
    set listLength to (count theList)
    if (listLength < 2) then return
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    script o
        property lst : theList
        property storage : missing value
    end script

    set rangeLength to r - l + 1
    set amount to (rangeLength + rangeLength - amount) mod rangeLength
    if (amount is 0) then return
    set o's storage to o's lst's items l thru (l + amount - 1)
    repeat with i from (l + amount) to r
        set o's lst's item (i - amount) to o's lst's item i
    end repeat
    set j to r - amount
    repeat with i from 1 to amount
        set o's lst's item (j + i) to o's storage's item i
    end repeat
end rotate

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

-- Return a script object containing a couple of randomised alphabets to use as a choacipher key.
on makeKey()
    set lAlpha to "ABCDEFGHIJKLMNOPQRSTUVWXYZ"'s characters
    copy lAlpha to rAlpha
    script |key|
        property leftAlpha : join(shuffle(lAlpha, 1, -1), "")
        property rightAlpha : join(shuffle(rAlpha, 1, -1), "")
    end script

    return |key|
end makeKey

-- Fisher-Yates (aka Durstenfeld, aka Knuth) shuffle.
on shuffle(theList, l, r)
    set listLength to (count theList)
    if (listLength < 2) then return array
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    script o
        property lst : theList
    end script

    repeat with i from l to (r - 1)
        set j to (random number from i to r)
        set v to o's lst's item i
        set o's lst's item i to o's lst's item j
        set o's lst's item j to v
    end repeat

    return theList
end shuffle

-- Demo using the two-alphabet key from the Rubin paper and another generated at random.
-- Decription must be with the key that was used for the encription.
on demo(originalText)
    set key1 to {leftAlpha:"HXUCZVAMDSLKPEFJRIGTWOBNYQ", rightAlpha:"PTLNBQDEOYSFAVZKGJRIHWXUMC"}
    set key2 to makeKey()
    set enciphered to chaocipher(originalText, key1, "encipher")
    set doubleEnciphered to chaocipher(enciphered, key2, "encipher")
    set deDoubleEnciphered to chaocipher(doubleEnciphered, key2, "decipher")
    set deciphered to chaocipher(deDoubleEnciphered, key1, "decipher")
    return join({"Original text = " & originalText, ¬
        "Enciphered = " & enciphered, "Double enciphered = " & doubleEnciphered, ¬
        "De-double enciphered = " & deDoubleEnciphered, "Deciphered  = " & deciphered}, linefeed)
end demo
demo("WELLDONEISBETTERTHANWELLSAID")
