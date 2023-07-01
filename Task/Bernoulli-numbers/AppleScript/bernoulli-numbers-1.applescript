on bernoullis(n) -- Return a list of "numerator / denominator" texts representing Bernoulli numbers B(0) to B(n).
    set listMathScript to getListMathScript(10) -- Script object providing custom list math routines.

    set output to {}
    -- Akiyama–Tanigawa algorithm for the "second Bernoulli numbers".
    -- List 'a' will contain {numerator, denominator} lists representing fractions.
    -- The numerators and denominators will in turn be lists containing integers representing their (decimal) digits.
    set a to {}
    repeat with m from 0 to n
        -- Append the structure for 1 / (m + 1) to the end of a.
        set {numerator2, denominator2} to {{1}, listMathScript's intToList(m + 1)}
        set a's end to result
        repeat with j from m to 1 by -1
            -- Retrieve the preceding numerator and denominator.
            set {numerator1, denominator1} to a's item j
            tell listMathScript
                -- Get the two fractions' lowest common denominator and adjust the numerators accordingly.
                set lcd to its lcm(denominator1, denominator2)
                set numerator1 to its multiply(numerator1, its |div|(lcd, denominator1))
                set numerator2 to its multiply(numerator2, its |div|(lcd, denominator2))
                -- Subtract numerator2 from numerator1 and multiply the result by j.
                -- Assign the results to numerator2 and denominator2 for the next iteration.
                set numerator2 to its multiply(its subtract(numerator1, numerator2), its intToList(j))
                set denominator2 to lcd
            end tell
            -- Also store them in a's slot j. No need to reduce them here.
            set a's item j to {numerator2, denominator2}
        end repeat
        -- The fraction just stored in a's first slot is Bernoulli(m). Reduce it and append a text representation to the output.
        tell listMathScript
            set gcd to its hcf(numerator2, denominator2)
            set numerator2 to its |div|(numerator2, gcd)
            set denominator2 to its |div|(denominator2, gcd)
            set end of output to its listToText(numerator2) & (" / " & its listToText(denominator2))
        end tell
    end repeat

    return output
end bernoullis

on getListMathScript(base)
    script
        on multiply(lst1, lst2) -- Multiply lst1 by lst2.
            set lst1Length to (count lst1)
            set lst2Length to (count lst2)
            set productLength to lst1Length + lst2Length - 1
            set product to {}
            repeat productLength times
                set product's end to 0
            end repeat

            -- Long multiplication algorithm, updating product digits on the fly instead of summing rows at the end.
            repeat with lst2Index from -1 to -lst2Length by -1
                set lst2Digit to lst2's item lst2Index
                if (lst2Digit is not 0) then
                    set carry to 0
                    set productIndex to lst2Index
                    repeat with lst1Index from lst1's length to 1 by -1
                        tell lst2Digit * (lst1's item lst1Index) + carry + (product's item productIndex)
                            set product's item productIndex to (it mod base)
                            set carry to (it div base)
                        end tell
                        set productIndex to productIndex - 1
                    end repeat
                    if (carry = 0) then
                    else if (productIndex < -productLength) then
                        set product's beginning to carry
                    else
                        set product's item productIndex to (product's item productIndex) + carry
                    end if
                end if
            end repeat

            return product
        end multiply

        on subtract(lst1, lst2) -- Subtract lst2 from lst1.
            set lst1Length to (count lst1)
            set lst2Length to (count lst2)
            -- Pad copies to equal lengths.
            copy lst1 to lst1
            repeat (lst2Length - lst1Length) times
                set lst1's beginning to 0
            end repeat
            copy lst2 to lst2
            repeat (lst1Length - lst2Length) times
                set lst2's beginning to 0
            end repeat
            -- Is lst2's numeric value greater than lst1's?
            set paddedLength to (count lst1)
            repeat with i from 1 to paddedLength
                set lst1Digit to lst1's item i
                set lst2Digit to lst2's item i
                set lst2Greater to (lst2Digit > lst1Digit)
                if ((lst2Greater) or (lst1Digit > lst2Digit)) then exit repeat
            end repeat
            -- If so, set up to subtract lst1 from lst2 instead. We'll invert the result's sign at the end.
            if (lst2Greater) then tell lst2
                set lst2 to lst1
                set lst1 to it
            end tell

            -- The subtraction at last!
            set difference to {}
            set borrow to 0
            repeat with i from paddedLength to 1 by -1
                tell (lst1's item i) + base - borrow - (lst2's item i)
                    set difference's beginning to (it mod base)
                    set borrow to 1 - (it div base)
                end tell
            end repeat
            if (lst2Greater) then invert(difference)

            return difference
        end subtract

        on |div|(lst1, lst2) -- List lst1 div lst2.
            return divide(lst1, lst2)'s quotient
        end |div|

        on |mod|(lst1, lst2) -- List lst1 mod lst2.
            return divide(lst1, lst2)'s remainder
        end |mod|

        on divide(lst1, lst2) -- Divide lst1 by lst2. Return a record containing separate lists for the quotient and remainder.
            set dividend to trim(lst1)
            set divisor to trim(lst2)
            set dividendLength to (count dividend)
            set divisorLength to (count divisor)
            if (divisorLength > dividendLength) then return {quotient:{0}, remainder:dividend}
            -- Note the dividend's and divisor's signs, but use absolute values in the division.
            set dividendNegative to (dividend's beginning < 0)
            if (dividendNegative) then invert(dividend)
            set divisorNegative to (divisor's beginning < 0)
            if (divisorNegative) then invert(divisor)

            -- Long-division algorithm, but quotient digits are subtraction counts.
            set quotient to {}
            if (divisorLength > 1) then
                set remainder to dividend's items 1 thru (divisorLength - 1)
            else
                set remainder to {}
            end if
            repeat with nextSlot from divisorLength to dividendLength
                set remainder's end to dividend's item nextSlot
                repeat with subtractionCount from 0 to base -- Only ever reaches base - 1.
                    set subtractionResult to trim(subtract(remainder, divisor))
                    if (subtractionResult's beginning < 0) then exit repeat
                    set remainder to subtractionResult
                end repeat
                set end of quotient to subtractionCount
            end repeat
            -- The quotient's negative if the input signs are different. Positive otherwise.
            if (dividendNegative ≠ divisorNegative) then invert(quotient)
            -- The remainder has the same sign as the dividend.
            if (dividendNegative) then invert(remainder)

            return {quotient:quotient, remainder:remainder}
        end divide

        on lcm(lst1, lst2) -- Lowest common multiple of lst1 and lst2.
            return multiply(lst2, |div|(lst1, hcf(lst1, lst2)))
        end lcm

        on hcf(lst1, lst2) -- Highest common factor of lst1 and lst2.
            set lst1 to trim(lst1)
            set lst2 to trim(lst2)
            repeat until (lst2 = {0})
                set x to lst1
                set lst1 to lst2
                set lst2 to trim(|mod|(x, lst2))
            end repeat
            if (lst1's beginning < 0) then invert(lst1)

            return lst1
        end hcf

        on invert(lst) -- Invert the sign of all lst's "digits".
            repeat with thisDigit in lst
                set thisDigit's contents to -thisDigit
            end repeat
        end invert

        on trim(lst) -- Return a copy of lst with no leading zeros.
            repeat with i from 1 to (count lst)
                if (lst's item i is not 0) then exit repeat
            end repeat

            return lst's items i thru end
        end trim

        on intToList(n) -- Return a list of numbers representing n's digits.
            set lst to {n mod base}
            set n to n div base
            repeat until (n = 0)
                set beginning of lst to n mod base as integer
                set n to n div base
            end repeat

            return lst
        end intToList

        on listToText(lst) -- Return the number represented by the input list as text.
            -- This lazily assumes 2 <= base <= 10.  :)
            set lst to trim(lst)
            if (lst's beginning < 0) then
                invert(lst)
                set lst's beginning to "-"
            end if

            return join(lst, "")
        end listToText
    end script

    return result
end getListMathScript

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set maxN to 60
    set output to {""}
    set padding to "  =                                                   "
    set bernoulliNumbers to bernoullis(maxN)
    repeat with n from 0 to maxN
        set bernie to bernoulliNumbers's item (n + 1)
        if (bernie does not start with "0") then
            set Bn to "B(" & n & ")"
            set output's end to Bn & ¬
                text ((count Bn) - 3) thru (50 - (offset of "/" in bernie)) of padding & ¬
                bernie
        end if
    end repeat

    return join(output, linefeed)
end task

task()
