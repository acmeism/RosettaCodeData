on pancake_sort(aList)
    script o
        property lst : aList
        property len : (count my lst)

        on flip(n)
            if (n < len) then
                set my lst to (reverse of items 1 thru n of my lst) & (items (n + 1) thru len of my lst)
            else
                set my lst to reverse of my lst
            end if
        end flip
    end script

    repeat with i from (count o's lst) to 2 by -1
        set maxIdx to 1
        set maxVal to beginning of o's lst
        repeat with j from 2 to i
            tell item j of o's lst
                if (it > maxVal) then
                    set maxIdx to j
                    set maxVal to it
                end if
            end tell
        end repeat
        (* Performancewise, there's little to choose between doing the two 'if' tests below every time and
        occasionally flipping unnecessarily. The flips themselves are of of course a daft way to achieve:
            set item maxIdx of o's lst to item i of o's lst
            set item i of o's lst to maxVal
        *)
        -- if (maxIdx < i) then
        --     if (maxIdx > 1) then ¬
        o's flip(maxIdx)
        o's flip(i)
        -- end if
    end repeat

    return o's lst
end pancake_sort

-- Task code:
local pre, post, astid, output
set pre to {}
repeat 20 times
    set end of pre to (random number 100)
end repeat
set post to pancake_sort(pre)

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
set output to "Before: {" & pre & ("}" & linefeed & "After:  {" & post & "}")
set AppleScript's text item delimiters to astid
return output
