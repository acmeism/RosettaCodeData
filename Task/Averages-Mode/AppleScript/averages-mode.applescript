use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later (for these 'use' commands).
use sorter : script "Shell sort" -- https://www.rosettacode.org/wiki/Sorting_algorithms/Shell_sort#AppleScript

on modeOf(listOrRecord)
    -- Extract and sort numbers and text separately, then concatenate the results to get a single list of values.
    set theNumbers to listOrRecord's numbers
    tell sorter to sort(theNumbers, 1, -1)
    set theTexts to listOrRecord's text
    tell sorter to sort(theTexts, 1, -1)
    script o
        property values : theNumbers & theTexts
        property mode : {}
    end script

    -- Identify the most frequently occurring value(s).
    if (o's values is not {}) then
        set i to 1
        set currentValue to beginning of o's values
        set maxCount to 1
        repeat with j from 2 to (count o's values)
            set thisValue to item j of o's values
            if (thisValue is not currentValue) then
                set thisCount to j - i
                if (thisCount > maxCount) then
                    set o's mode to {currentValue}
                    set maxCount to thisCount
                else if (thisCount = maxCount) then
                    set end of o's mode to currentValue
                end if
                set i to j
                set currentValue to thisValue
            end if
        end repeat
        if (j + 1 - i > maxCount) then
            set o's mode to {currentValue}
        else if (j + 1 - i = maxCount) then
            set end of o's mode to currentValue
        end if
    end if

    return o's mode
end modeOf

-- Test code:
-- With a list:
modeOf({12, 4, "rhubarb", 88, "rhubarb", 17, "custard", 4.0, 4, 88, "rhubarb"})
--> {4, "rhubarb"}

-- With a record:
modeOf({a:12, b:4, c:"rhubarb", d:88, e:"rhubarb", f:17, g:"custard", h:4.0, i:4, j:88})
--> {4}
