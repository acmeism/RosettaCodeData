-- Build a balanced ternary, as text, from an integer value or acceptable AppleScript substitute.
on BTFromInteger(n)
    try
        if (n mod 1 is not 0) then error (n as text) & " isn't an integer value"
        set n to n as integer
    on error errMsg
        display alert "BTFromInteger handler: parameter error" message errMsg buttons {"OK"} default button 1 as critical
        error number -128
    end try
    if (n is 0) then return "0"
    -- Positive numbers' digits will be indexed from the beginning of a list containing them, negatives' from the end.
    -- AppleScript indices are 1-based, so get the appropriate 1 or -1 add-in.
    set one to 1
    if (n < 0) then set one to -1
    set digits to {"0", "+", "-", "0"}
    -- Build the text digit by digit.
    set bt to ""
    repeat until (n = 0)
        set nMod3 to n mod 3
        set bt to (item (nMod3 + one) of digits) & bt
        set n to n div 3 + nMod3 div 2 -- + nMod3 div 2 adds in a carry when nMod3 is either 2 or -2.
    end repeat

    return bt
end BTFromInteger

-- Calculate a balanced ternary's integer value from its characters' Unicode numbers.
on integerFromBT(bt)
    checkInput(bt, "integerFromBT")
    set n to 0
    repeat with thisID in (get bt's id)
        set n to n * 3
        -- Unicode 48 is "0", 43 is "+", 45 is "-".
        if (thisID < 48) then set n to n + (44 - thisID)
    end repeat

    return n
end integerFromBT

-- Add two balanced ternaries together.
on addBTs(bt1, bt2)
    checkInput({bt1, bt2}, "addBTs")
    set {longerLength, shorterLength} to {(count bt1), (count bt2)}
    if (longerLength < shorterLength) then set {bt1, bt2, longerLength, shorterLength} to {bt2, bt1, shorterLength, longerLength}

    -- Add the shorter number's digits into a list of the longer number's digits, adding in carries too where appropriate.
    set resultList to bt1's characters
    repeat with i from -1 to -shorterLength by -1
        set {carry, item i of resultList} to sumDigits(item i of resultList, character i of bt2)
        repeat with j from (i - 1) to -longerLength by -1
            if (carry is "0") then exit repeat
            set {carry, item j of resultList} to sumDigits(carry, item j of resultList)
        end repeat
        if (carry is not "0") then set beginning of bt1 to carry
    end repeat
    -- Zap any leading zeros resulting from the cancelling out of the longer number's MSD(s).
    set j to -(count resultList)
    repeat while ((item j of resultList is "0") and (j < -1))
        set item j of resultList to ""
        set j to j + 1
    end repeat

    return join(resultList, "")
end addBTs

-- Multiply one balanced ternary by another.
on multiplyBTs(bt1, bt2)
    checkInput({bt1, bt2}, "multiplyBTs")
    -- Longer and shorter aren't critical here, but it's more efficient to loop through the lesser number of digits.
    set {longerLength, shorterLength} to {(count bt1), (count bt2)}
    if (longerLength < shorterLength) then set {bt1, bt2, shorterLength} to {bt2, bt1, longerLength}

    set multiplicationResult to "0"
    repeat with i from -1 to -shorterLength by -1
        set d2 to character i of bt2
        if (d2 is not "0") then
            set subresult to ""
            -- With each non-"0" subresult, begin with the appropriate number of trailing zeros.
            repeat (-1 - i) times
                set subresult to "0" & subresult
            end repeat
            -- Prepend the longer ternary as is.
            set subresult to bt1 & subresult
            -- Negate the result if the current multiplier from the shorter ternary is "-".
            if (d2 is "-") then set subresult to negateBT(subresult)
            -- Add the subresult to the total so far.
            set multiplicationResult to addBTs(multiplicationResult, subresult)
        end if
    end repeat

    return multiplicationResult
end multiplyBTs

-- Negate a balanced ternary by substituting the characters obtained through subtracting its sign characters' Unicode numbers from 88.
on negateBT(bt)
    checkInput(bt, "negateBT")
    set characterIDs to bt's id
    repeat with thisID in characterIDs
        if (thisID < 48) then set thisID's contents to 88 - thisID
    end repeat

    return string id characterIDs
end negateBT

(* Private handlers. *)

on checkInput(params as list, handlerName)
    try
        repeat with thisParam in params
            if (thisParam's class is text) then
                if (join(split(thisParam, {"-", "+", "0"}), "") > "") then error "\"" & thisParam & "\" isn't a balanced ternary number."
            else
                error "The parameter isn't text."
            end if
        end repeat
    on error errMsg
        display alert handlerName & " handler: parameter error" message errMsg buttons {"OK"} default button 1 as critical
        error number -128
    end try
end checkInput

-- "Add" two balanced ternaries and return both the carry and the result for the column.
on sumDigits(d1, d2)
    if (d1 is "0") then
        return {"0", d2}
    else if (d2 is "0") then
        return {"0", d1}
    else if (d1 = d2) then
        if (d1 = "+") then
            return {"+", "-"}
        else
            return {"-", "+"}
        end if
    else
        return {"0", "0"}
    end if
end sumDigits

on join(lst, delimiter)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set txt to lst as text
    set AppleScript's text item delimiters to astid

    return txt
end join

on split(txt, delimiter)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set lst to txt's text items
    set AppleScript's text item delimiters to astid

    return lst
end split

-- Test code:
set a to "+-0++0+"
set b to BTFromInteger(-436) --> "-++-0--"
set c to "+-++-"

set line1 to "a = " & integerFromBT(a)
set line2 to "b = " & integerFromBT(b)
set line3 to "c = " & integerFromBT(c)
tell multiplyBTs(a, addBTs(b, negateBT(c))) to ¬
    set line4 to "a * (b - c) = " & it & " or " & my integerFromBT(it)

return line1 & linefeed & line2 & linefeed & line3 & linefeed & line4
