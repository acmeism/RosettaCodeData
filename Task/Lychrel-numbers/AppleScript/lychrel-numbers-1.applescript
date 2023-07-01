on Lychrels(numberLimit, iterationLimit)
    script o
        property digits : missing value -- Digits of the current startNumber or a derived sum.
        property stigid : missing value -- Reverse thereof.
        property digitLists : missing value -- Copies of the digit lists in the current sequence.
        -- The digit lists from earlier Lychrel sequences, grouped into 1000 sublists
        -- indexed by their last three digits (+ 1) to speed up searches for them.
        property earlierDigitLists : listOfLists(1000)
        property subgroup : missing value -- Sublist picked from earlierDigitLists.
        -- Lychrel output.
        property seeds : {}
        property relateds : {}
        property palindromics : {}

        -- Subhandler: Has the current list of digits come up in the sequence for an earlier Lychrel?
        on isRelated()
            -- Unless it only has one digit, look for it in the appropriate subgroup of earlierDigitLists.
            set digitCount to (count my digits)
            if (digitCount > 1) then
                set i to (item -2 of my digits) * 10 + (end of my digits) + 1
                if (digitCount > 2) then set i to i + (item -3 of my digits) * 100
                set subgroup to item i of my earlierDigitLists
                -- It's faster to test this using a repeat than with 'is in'!
                repeat with i from 1 to (count my subgroup)
                    if (item i of my subgroup = digits) then return true
                end repeat
            end if
            return false
        end isRelated
    end script

    repeat with startNumber from 1 to numberLimit
        -- Get the number's digits and their reverse.
        set o's digits to {}
        set temp to startNumber
        repeat until (temp = 0)
            set beginning of o's digits to temp mod 10
            set temp to temp div 10
        end repeat
        set o's stigid to reverse of o's digits
        -- Note if the number itself is palindromic.
        set startNumberIsPalindrome to (o's digits = o's stigid)

        if (o's isRelated()) then
            -- It(s digits) occurred in the sequence for an earlier Lychrel, so it's a related Lychrel.
            set end of o's relateds to startNumber
        else
            -- Otherwise run its sequence.
            set o's digitLists to {}
            set digitCount to (count o's digits)

            -- Sequence loop.
            repeat iterationLimit times
                -- Add the reversed digits to those of the current number.
                set carry to 0
                repeat with i from digitCount to 1 by -1
                    set d to (item i of o's digits) + (item i of o's stigid) + carry
                    set item i of o's digits to d mod 10
                    set carry to d div 10
                end repeat
                if (carry > 0) then
                    set beginning of o's digits to carry
                    set digitCount to digitCount + 1
                end if

                -- If the sum's digits are palindromic, the start number's not a Lychrel.
                set o's stigid to reverse of o's digits
                set sumIsPalindrome to (o's digits = o's stigid)
                if (sumIsPalindrome) then exit repeat
                -- Otherwise, if the digits occurred in an earlier Lychrel sequence, the start number's a related Lychrel.
                set startNumberIsRelated to (o's isRelated())
                if (startNumberIsRelated) then
                    set sumIsPalindrome to false
                    exit repeat
                end if
                -- Otherwise keep a copy of the digits and go for the next number in the sequence.
                copy o's digits to end of o's digitLists
            end repeat

            if (not sumIsPalindrome) then
                -- No palindrome other than the start number occurred in the sequence,
                -- so the number's a Lychrel. Store it as the relevant type.
                if (startNumberIsRelated) then
                    set end of o's relateds to startNumber
                else
                    set end of o's seeds to startNumber
                end if
                if (startNumberIsPalindrome) then set end of o's palindromics to startNumber
                -- Store this sequence's digit lists based on their last three digits. There won't be any
                -- single-digit lists (they're palindromes), but there may be some with only two digits.
                repeat with thisList in o's digitLists
                    set i to (item -2 of thisList) * 10 + (end of thisList) + 1
                    set digitCount to (count thisList)
                    if (digitCount > 2) then set i to i + (item -3 of thisList) * 100
                    set end of item i of o's earlierDigitLists to thisList's contents
                end repeat
            end if
        end if
    end repeat

    return {seeds:o's seeds, relateds:o's relateds, palindromics:o's palindromics}
end Lychrels

on listOfLists(len)
    script o
        property lst : {}
    end script
    repeat len times
        set end of o's lst to {}
    end repeat
    return o's lst
end listOfLists

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set numberLimit to 10000
    set iterationLimit to 500
    set {seeds:seeds, relateds:relateds, palindromics:palindromics} to Lychrels(numberLimit, iterationLimit)
    set output to {"Lychrel numbers between 1 and " & numberLimit & ":", ""}
    set end of output to ((count seeds) as text) & " seed Lychrels: " & join(seeds, ", ")
    set end of output to ((count relateds) as text) & " related Lychrels"
    set end of output to ((count palindromics) as text) & " palindromic Lychrels: " & join(palindromics, ", ")
    return join(output, linefeed)
end task

task()
