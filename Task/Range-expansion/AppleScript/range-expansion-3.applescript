on rangeExpansion(rangeExpression)
    -- Split the expression at the commas, if any.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ","
    set theRanges to rangeExpression's text items

    set integerList to {}
    set AppleScript's text item delimiters to "-"
    repeat with thisRange in theRanges
        -- Split each range or integer text at its dash(es), if any.
        set rangeParts to thisRange's text items
        -- A minus before the first integer will make leading text item "".
        -- If this happens, insert the negative first value at the beginning of the parts list.
        -- (AppleScript automatically coerces numeric text to number when the context demands.)
        if (rangeParts begins with "") then set beginning of rangeParts to -(item 2 of rangeParts)
        -- A minus before the second (or only) integer will make the penultimate text item "".
        -- In this case, insert the negative last value at the end of the parts list.
        if (((count rangeParts) > 1) and (item -2 of rangeParts is "")) then set end of rangeParts to -(end of rangeParts)
        -- Append all the integers implied by the range to the integer list.
        repeat with i from (beginning of rangeParts) to (end of rangeParts)
            set end of integerList to i
        end repeat
    end repeat
    set AppleScript's text item delimiters to astid

    return integerList
end rangeExpansion

-- Demo code:
set rangeExpression to "-6,-3--1,3-5,7-11,14,15,17-20"
return rangeExpansion(rangeExpression)
