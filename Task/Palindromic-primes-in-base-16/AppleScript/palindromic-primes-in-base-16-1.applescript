on isPrime(n)
    if ((n < 4) or (n is 5)) then return (n > 1)
    if ((n mod 2 = 0) or (n mod 3 = 0) or (n mod 5 = 0)) then return false
    repeat with i from 7 to (n ^ 0.5) div 1 by 30
        if ((n mod i = 0) or (n mod (i + 4) = 0) or (n mod (i + 6) = 0) or ¬
            (n mod (i + 10) = 0) or (n mod (i + 12) = 0) or (n mod (i + 16) = 0) or ¬
            (n mod (i + 22) = 0) or (n mod (i + 24) = 0)) then return false
    end repeat

    return true
end isPrime

on task()
    set digits to "0123456789ABCDEF"'s characters
    set output to {"2"} -- Take "2" as read.
    repeat with n from 3 to 499 by 2 -- All other primes are odd.
        if (isPrime(n)) then
            -- Only the number's hex digit /values/ are needed for testing.
            set vals to {}
            repeat until (n = 0)
                set vals's beginning to n mod 16
                set n to n div 16
            end repeat
            -- If they're palindromic, build a text representation and append this to the output.
            if (vals = vals's reverse) then
                set hex to digits's item ((vals's beginning) + 1)
                repeat with i from 2 to (count vals)
                    set hex to hex & digits's item ((vals's item i) + 1)
                end repeat
                set output's end to hex
            end if
        end if
    end repeat

    return output
end task

task()
