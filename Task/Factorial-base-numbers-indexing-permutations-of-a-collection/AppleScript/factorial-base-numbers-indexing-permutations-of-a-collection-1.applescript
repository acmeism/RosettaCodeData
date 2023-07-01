-- Permutate a list according to a given factorial base number.
on FBNShuffle(|Ω|, fbn)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "."
    set fbnDigits to fbn's text items
    set AppleScript's text item delimiters to astid

    repeat with m from 1 to (count fbnDigits)
        set m_plus_g to m + (item m of fbnDigits)
        set v to item m_plus_g of |Ω|
        repeat with i from (m_plus_g - 1) to m by -1
            set item (i + 1) of |Ω| to item i of |Ω|
        end repeat
        set item m of |Ω| to v
    end repeat
end FBNShuffle

-- Generate all the factorial base numbers having a given number of digits.
on generateFBNs(numberOfDigits)
    script o
        property partials : {}
        property permutations : {}
    end script

    if (numberOfDigits > 0) then
        repeat with i from 0 to numberOfDigits
            set end of o's permutations to (i as text)
        end repeat
        repeat with maxDigit from (numberOfDigits - 1) to 1 by -1
            set o's partials to o's permutations
            set o's permutations to {}
            repeat with i from 1 to (count o's partials)
                set thisPartial to item i of o's partials
                repeat with j from 0 to maxDigit
                    set end of o's permutations to (thisPartial & ("." & j))
                end repeat
            end repeat
        end repeat
    end if

    return o's permutations
end generateFBNs

-- Generate a random factorial base number having a given number of digits.
on generateRandomFBN(numberOfDigits)
    set fbnDigits to {}
    repeat with maxDigit from numberOfDigits to 1 by -1
        set end of fbnDigits to (random number maxDigit)
    end repeat

    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "."
    set fbn to fbnDigits as text
    set AppleScript's text item delimiters to astid

    return fbn
end generateRandomFBN

(* Test code *)

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ""

-- 1. Reproduce table of {0, 1, 2, 3} permutations
set output to {"1. Reproduce table of {0, 1, 2, 3} permutations:"}
set elements to {0, 1, 2, 3}
set listOfFBNs to generateFBNs((count elements) - 1)
repeat with fbn in listOfFBNs
    copy elements to |Ω|
    FBNShuffle(|Ω|, fbn)
    set end of output to fbn's contents & " -> " & |Ω|
end repeat

-- 2. Generate and count all 11-digit permutations. No way!
set end of output to ""
set numberOfDigits to 11
set numberOfPermutations to 1
repeat with base from 2 to (numberOfDigits + 1)
    set numberOfPermutations to numberOfPermutations * base
end repeat
set end of output to "2. " & numberOfDigits & "-digit factorial base numbers have " & (numberOfPermutations div 1) & " possible permutations!"

-- 3. Card shoe permutations with the given FBNs.
set end of output to ""
set shoe to {"A♠", "K♠", "Q♠", "J♠", "10♠", "9♠", "8♠", "7♠", "6♠", "5♠", "4♠", "3♠", "2♠", ¬
    "A♥", "K♥", "Q♥", "J♥", "10♥", "9♥", "8♥", "7♥", "6♥", "5♥", "4♥", "3♥", "2♥", ¬
    "A♦", "K♦", "Q♦", "J♦", "10♦", "9♦", "8♦", "7♦", "6♦", "5♦", "4♦", "3♦", "2♦", ¬
    "A♣", "K♣", "Q♣", "J♣", "10♣", "9♣", "8♣", "7♣", "6♣", "5♣", "4♣", "3♣", "2♣"}
copy shoe to shoe1
copy shoe to shoe2
set fbn1 to "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0"
set fbn2 to "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"
FBNShuffle(shoe1, fbn1)
FBNShuffle(shoe2, fbn2)
set end of output to "3. Shuffle " & shoe
set end of output to "With " & fbn1 & (linefeed & " -> " & shoe1)
set end of output to "With " & fbn2 & (linefeed & " -> " & shoe2)

-- 4. Card shoe permutation with randomly generated FBN.
set end of output to ""
set fbn3 to generateRandomFBN(51)
FBNShuffle(shoe, fbn3)
set end of output to "4. With randomly generated " & fbn3 & (linefeed & " -> " & shoe)

set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid
return output
