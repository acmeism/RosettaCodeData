on isColorful(n)
    if ((n > 98765432) or (n < 0) or (n mod 1 > 0)) then return false
    set products to {n mod 10}
    repeat while (n > 9)
        set n to n div 10
        set digit to n mod 10
        if ((digit < 2) or (digit is in products)) then return false
        set end of products to digit
    end repeat
    set nDigits to (count products)
    repeat with i from 1 to (nDigits - 1)
        set prod to products's item i
        repeat with j from (i + 1) to nDigits
            set prod to prod * (products's item j)
            if (prod is in products) then return false
            set end of products to prod
        end repeat
    end repeat

    return true
end isColorful

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set colorfuls to {}
    repeat with n from 0 to 100
        if (isColorful(n)) then set end of colorfuls to ("   " & n)'s text -3 thru -1
    end repeat

    script cc
        property used : {false, false, false, false, false, false, false, false, false, false}
        property counts : {0, 0, 0, 0, 0, 0, 0, 0}
        property largest : 0

        on count_colourful(taken, x, n)
            set used's item x to true
            if (isColorful(n)) then
                set ln to 1
                repeat until ((10 ^ ln) > n)
                    set ln to ln + 1
                end repeat
                set counts's item ln to (counts's item ln) + 1
                if (n > largest) then set largest to n
            end if
            if (taken < 9) then
                repeat with digit from 2 to 9
                    set dx to digit + 1
                    if (not used's item dx) then
                        count_colourful(taken + 1, dx, n * 10 + digit)
                    end if
                end repeat
            end if
            set used's item x to false
        end count_colourful
    end script
    repeat with digit from 0 to 9
        cc's count_colourful(((digit < 2) as integer) * 8 + 1, digit + 1, digit)
    end repeat

    set output to {"The colorful numbers below 100:"}
    repeat with i from 1 to 66 by 11
        set end of output to join(colorfuls's items i thru (i + 10), "")
    end repeat
    set end of output to linefeed & "The largest colorful number is " & cc's largest
    set counter to cc's counts's beginning
    set end of output to linefeed & "The number of them with 1 digit is " & counter
    repeat with i from 2 to (count cc's counts)
        set end of output to "The number with " & i & " digits is " & (cc's counts's item i)
        set counter to counter + (cc's counts's item i)
    end repeat
    set end of output to "The total number overall is " & counter
    return join(output, linefeed)
end task

task()
