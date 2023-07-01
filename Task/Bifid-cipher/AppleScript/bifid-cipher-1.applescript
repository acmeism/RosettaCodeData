(* The "square" here is only notional, the characters' coordinates being calculated
   from their offsets in a linear text key. But a square key is accepted if the
   signaller's careless enough to keep or transmit one in this form. *)
on bifidEncipher(message, square)
    return transcipher(message, square, 1)
end bifidEncipher

on bifidDecipher(message, square)
    return transcipher(message, square, 2)
end bifidDecipher

on transcipher(message, square, code) -- code: 1 = encipher, 2 = decipher.
    -- Check and massage the input.
    set message to join(message's words, "")
    if (message contains ".") then set message to replaceText(".", "", message)
    set square to join(join(square, "")'s words, "")
    set squarea to (count square)
    set sqrt to (squarea ^ 0.5) as integer
    if (sqrt * sqrt ≠ squarea) then error "Invalid key."
    ignoring case
        if ((sqrt < 6) and (message contains "J")) then ¬
            set message to replaceText("J", "I", message)
    end ignoring
    -- Calculate coordinates from the message characters' offsets in the "square" text
    -- and either split and recombine them (when enciphering) or not (deciphering).
    set list1 to {}
    set list2 to {{}, list1}'s item code
    set astid to AppleScript's text item delimiters
    ignoring case and diacriticals
        repeat with chr in message
            set AppleScript's text item delimiters to chr
            set |offset - 1| to (count square's first text item)
            set list1's end to |offset - 1| div sqrt + 1
            set list2's end to |offset - 1| mod sqrt + 1
        end repeat
    end ignoring
    set AppleScript's text item delimiters to astid
    set coords to {list1 & list2, list1}'s item code
    -- Calculate new offsets from the appropriate numbers in the coords list
    -- and get the characters offset by those amounts in the "square" text.
    set chrs to {}
    set nCoords to (count coords)
    set indexDifference to {1, nCoords div 2}'s item code
    repeat with i from 1 to (nCoords div code) by (3 - code)
        set |offset| to ((coords's item i) - 1) * sqrt + (coords's item (i + indexDifference))
        set chrs's end to square's character |offset|
    end repeat
    return join(chrs, "")
end transcipher

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on replaceText(searchText, replacement, mainText)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to searchText
    set textItems to mainText's text items
    set AppleScript's text item delimiters to replacement
    set mainText to textItems as text
    set AppleScript's text item delimiters to astid
    return mainText
end replaceText

on task()
    set output to {}
    repeat with this in {{"Given example:", "ATTACKATDAWN", "ABCDEFGHIKLMNOPQRSTUVWXYZ"}, ¬
        {"Wikipedia example:", "FLEEATONCE", {"BGWKZ", "QPNDS", "IOAXE", "FCLUM", "THYVR"}}, ¬
        {"A 6 x 6 square allows all 36 letters & digits to be encoded:", ¬
            "The invasion will start on the 1st of January", ¬
            "THEQUI
                    9CKBR0
                    1OWNF8
                    7XJMP2
                    3SVLA6
                    5ZYDG4"}}
        set {heading, message, square} to this
        set encrypted to bifidEncipher(message, square)
        set decrypted to bifidDecipher(encrypted, square)
        set output's end to heading
        set output's end to message & " --> " & encrypted & " --> " & decrypted
    end repeat

    return join(output, linefeed)
end task

task()
