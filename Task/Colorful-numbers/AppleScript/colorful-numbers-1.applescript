(*
    This observes the task requirement that colorful numbers be identified using a test handler,
    but uses the information regarding 1s and 0s and some logic to skip obvious non-starters
    and save a few minutes' running time. Since multiplication is commutative, every number's
    "colorful" status is the same as its reverse's. Working up from 0, the lower number of each
    mirrored colorful pair is met first and its reverse derived. If the largest reversed number
    obtained so far is actually reached, it's the last colorful number at that magnitude. The
    search either end there or jumps to the lowest number worth trying at the next level.
*)
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
    set counter to 0
    set counts to {}
    set magnitude to 1 -- 10 ^ (number of digits - 1).
    set largestReverse to 9 -- Largest reverse of a single-digit number!
    set n to 0
    repeat
        if (isColorful(n)) then
            if (n < 100) then set end of colorfuls to text -3 thru -1 of ("   " & n)
            set counter to counter + 1
            if (n = largestReverse) then
                set end of counts to counter
                set counter to 0
                set magnitude to magnitude * 10
                if (magnitude > 98765432) then exit repeat
                set n to 2.3456789 * magnitude div 1 - 1
            else
                set temp to n
                set |reverse| to temp mod 10
                repeat while (temp > 9)
                    set temp to temp div 10
                    set |reverse| to |reverse| * 10 + temp mod 10
                end repeat
                if (|reverse| > largestReverse) then set largestReverse to |reverse|
            end if
        end if
        if (n mod 10 = 9) then
            set n to n + 3
        else
            set n to n + 1
        end if
    end repeat

    set output to {"The colorful numbers below 100:"}
    repeat with i from 1 to 66 by 11
        set end of output to join(colorfuls's items i thru (i + 10), "")
    end repeat
    set end of output to linefeed & "The largest colorful number is " & largestReverse
    set counter to counts's beginning
    set end of output to linefeed & "The number of them with 1 digit is " & counter
    repeat with i from 2 to (count counts)
        set end of output to "The number with " & i & " digits is " & (counts's item i)
        set counter to counter + (counts's item i)
    end repeat
    set end of output to "The total number overall is " & counter
    return join(output, linefeed)
end task

task()
