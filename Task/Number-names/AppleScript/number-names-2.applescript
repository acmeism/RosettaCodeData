-- Parameters:
-- n: AppleScript integer or real.
-- longScale (optional): boolean. Whether to use long-scale -illions instead of short-scale. Default: false
-- milliards (optional): boolean. Whether to use long-scale -illiards instead of long-scale thousands.
-- ands (optional): boolean. Whether to include "and"s in the result. Default: true.
on numberToEnglish from n given longScale:usingLongScale : false, milliards:usingMilliards : false, ands:usingAnd : true
    -- If 'with milliards' is specified, make sure the differently coded 'with longScale' is disabled.
    if (usingMilliards) then set (usingLongScale) to false

    -- Script object containing data and two subhandlers.
    script o
        property scale : 1000
        property unitsAndTeens : {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", ¬
            "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
        property tens : {missing value, "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
        property landmarks : {"thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion"}
        property illiardLandmarks : {"thousand", "million", "milliard", "billion", "billiard", "trillion", "trilliard", ¬
            "quadrillion", "quadrilliard", "quintillion", "quintilliard", "sextillion", "sextilliard", "septillion", "septilliard"}
        property collector : {} -- Words collected here.

        -- Deal with the integer part of the number.
        on nameInteger(n, landmarkIndex)
            -- Recursively work to the "front" of the number, three or six "digits" at a time depending on the scale.
            if (n ≥ scale) then nameInteger(n div scale, landmarkIndex + 1)

            -- Name each digit-group value on the way back.
            set groupValue to n mod scale
            -- If a group value's over 999, its top three digits represent thousands in a long-scale naming. Deal with them first.
            if (groupValue > 999) then
                nameGroup(groupValue div 1000, false, landmarkIndex)
                set end of my collector to "thousand"
                -- In this context, if the group's bottom three digits amount to zero, the appropriate "-illion", if any, must be added here.
                set groupValue to groupValue mod 1000
                if ((groupValue is 0) and (landmarkIndex > 0)) then set end of my collector to item landmarkIndex of my landmarks
            end if
            -- Deal with either a short-scale digit group or the bottom three digits of a long-scale one.
            if (groupValue > 0) then
                nameGroup(groupValue, true, landmarkIndex)
                if (landmarkIndex > 0) then set end of my collector to item landmarkIndex of my landmarks
            end if
        end nameInteger

        -- Deal with a value representing a group of up to three digits.
        on nameGroup(groupValue, notThousands, landmarkIndex)
            -- Firstly the hundreds, if any.
            if (groupValue > 99) then
                set end of my collector to item (groupValue div 100) of unitsAndTeens
                set end of my collector to "hundred"
            end if
            -- Then the tens and units together, according to whether they require single words, hyphenated words or none.
            set tensAndUnits to groupValue mod 100
            if (tensAndUnits > 0) then
                -- Insert the word "and" if enabled and appropriate.
                if ((usingAnd) and ¬
                    ((collector ends with "hundred") ¬
                        or (collector ends with "thousand") ¬
                        or ((notThousands) and (landmarkIndex is 0) and (collector is not {})))) then ¬
                    set end of my collector to "and"
                if (tensAndUnits < 20) then
                    set end of my collector to item tensAndUnits of my unitsAndTeens
                else
                    set units to tensAndUnits mod 10
                    if (units > 0) then
                        set end of my collector to item (tensAndUnits div 10) of my tens & ("-" & item units of my unitsAndTeens)
                    else
                        set end of my collector to item (tensAndUnits div 10) of my tens
                    end if
                end if
            end if
        end nameGroup
    end script

    (* Main handler code. *)
    -- Adjust for a negative if necessary.
    if (n < 0) then set {end of o's collector, n} to {"minus", -n}

    -- Deal with the integer part of the number.
    if (n div 1 is 0) then
        set end of o's collector to "zero"
    else
        if (usingLongScale) then
            set o's scale to 1000000
            set o's landmarks to rest of o's landmarks
        else if (usingMilliards) then
            set o's landmarks to o's illiardLandmarks
        end if
        tell o to nameInteger(n div 1, 0)
    end if

    -- Deal with any fractional part. (Vulnerable to floating-point inaccuracy with extreme values.)
    if (n mod 1 > 0.0) then
        set end of o's collector to "point"
        -- Shift each fractional digit into the units position and read it off as an integer.
        set n to n * 10
        repeat
            set units to n mod 10 div 1
            if (units is 0) then
                set end of o's collector to "zero"
            else
                set end of o's collector to item (units div 1) of o's unitsAndTeens
            end if
            set n to n * 10.0
            if (n mod 10 is 0.0) then exit repeat
        end repeat
    end if

    -- Coerce the assembled words to a single text.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to space
    set English to o's collector as text
    set AppleScript's text item delimiters to astid

    return English
end numberToEnglish

numberToEnglish from -3.60287970189634E+12
--> "minus three trillion six hundred and two billion eight hundred and seventy-nine million seven hundred and one thousand eight hundred and ninety-six point three four"
numberToEnglish from -3.60287970189634E+12 without ands
--> "minus three trillion six hundred two billion eight hundred seventy-nine million seven hundred one thousand eight hundred ninety-six point three four"
numberToEnglish from -3.60287970189634E+12 with longScale
--> "minus three billion six hundred and two thousand eight hundred and seventy-nine million seven hundred and one thousand eight hundred and ninety-six point three four"
numberToEnglish from -3.60287970189634E+12 with milliards
--> "minus three billion six hundred and two milliard eight hundred and seventy-nine million seven hundred and one thousand eight hundred and ninety-six point three four"
