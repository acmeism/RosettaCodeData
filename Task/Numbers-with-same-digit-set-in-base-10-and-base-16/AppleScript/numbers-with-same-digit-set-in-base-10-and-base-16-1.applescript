use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script "Insertion sort" -- <https://www.rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on sameDigitSetDecHex(n)
    (* Integer number input assumed.
       Numbers whose hex LSD > 9 are eliminated immediately. Ditto negatives.
       Thereafter the hex form's tested first so that the dec form doesn't have to be if the hex is unsuitable. *)
    tell n mod 16 to if ((it > 9) or (it < 0)) then return false

    script o
        on digitsOf(n, base)
            set digits to {n mod base}
            set n to n div base
            repeat until (n = 0)
                set d to n mod base
                if (d > 9) then return false
                if (d is not in digits) then set end of digits to d
                set n to n div base
            end repeat
            tell sorter to sort(digits, 1, -1)

            return digits
        end digitsOf
    end script

    tell o's digitsOf(n, 16) to return ((it is not false) and (it = o's digitsOf(n, 10)))
end sameDigitSetDecHex

local output, n
set output to {}
repeat with n from 0 to 99999
    if (sameDigitSetDecHex(n)) then set end of output to n
end repeat
return output
