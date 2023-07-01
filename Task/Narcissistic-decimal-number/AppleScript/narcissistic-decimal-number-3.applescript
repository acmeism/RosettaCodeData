(*
    Return the first q narcissistic decimal numbers
    (or as many of the q as can be represented by AppleScript number values).
*)
on narcissisticDecimalNumbers(q)
    script o
        property output : {}
        property listOfDigits : missing value
        property m : 0 -- Digits per collection/number.
        property done : false

        -- Recursive subhandler. Builds lists containing m digit values while summing the digits' mth powers.
        on recurse(digitList, sumOfPowers, digitShortfall)
            -- If m digits have been obtained, compare the sum of powers's digits with the values in the list.
            -- Otherwise continue branching the recursion to derive longer lists.
            if (digitShortfall is 0) then
                -- Assign the list to a script property to allow faster references to its items (ie. incl. reference to script).
                set listOfDigits to digitList
                set temp to sumOfPowers
                set unmatched to m
                repeat until (temp = 0)
                    set sumDigit to temp mod 10
                    if (sumDigit is in digitList) then
                        repeat with d from 1 to unmatched
                            if (sumDigit = number d of my listOfDigits) then
                                set number d of my listOfDigits to missing value
                                set unmatched to unmatched - 1
                                exit repeat
                            end if
                        end repeat
                    else
                        exit repeat
                    end if
                    set temp to temp div 10
                end repeat
                -- If all the digits have been matched, the sum of powers is narcissistic.
                if (unmatched is 0) then
                    set end of my output to sumOfPowers div 1
                    -- If it's the qth find, signal the end of the process.
                    if ((count my output) = q) then set done to true
                end if
            else
                -- If fewer than m digits at this level, derive longer lists from the current one.
                -- Adding only values that are less than or equal to the last one makes each
                -- collection unique and turns up the narcissistic numbers in numerical order.
                repeat with additionalDigit from 0 to end of digitList
                    recurse(digitList & additionalDigit, sumOfPowers + additionalDigit ^ m, digitShortfall - 1)
                    if (done) then exit repeat
                end repeat
            end if
        end recurse
    end script

    (* Rest of main handler code. *)
    if (q > 89) then set q to 89 -- Number of narcissistic decimal integers known to exist.
    set maxM to 16 -- Maximum number of decimal digits (other than trailing zeros) in AppleScript numbers.
    tell o
        -- Begin with zero, which is narcissistic by definition and is never the only digit used in other numbers.
        if (q > 0) then set end of its output to 0
        if (q < 2) then set its done to true
        -- Initiate the recursive building and testing of collections of increasing numbers of digit values.
        repeat until (its done)
            set its m to (its m) + 1
            if (its m > maxM) then
                set end of its output to "Remaining numbers beyond AppleScript's number precision"
                set its done to true
            else
                repeat with digit from 1 to 9
                    recurse({digit}, digit ^ (its m), (its m) - 1)
                    if (its done) then exit repeat
                end repeat
            end if
        end repeat

        return its output
    end tell
end narcissisticDecimalNumbers

return narcissisticDecimalNumbers(25)
