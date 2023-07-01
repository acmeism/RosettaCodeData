-- This handler just returns the standardised real value. It's up to external processes to format it for display.

on standardisePrice(input)
    set integerPart to input div 1.0
    set fractionalPart to input mod 1.0

    if (fractionalPart is 0.0) then
        return input as real
    else if (fractionalPart < 0.06) then
        return integerPart + 0.1
    else if (fractionalPart < 0.16) then
        return integerPart + 0.18 + (fractionalPart - 0.06) div 0.05 * 0.08
    else if (fractionalPart < 0.36) then
        return integerPart + 0.32 + (fractionalPart - 0.16) div 0.05 * 0.06
    else if (fractionalPart < 0.96) then
        return integerPart + 0.54 + (fractionalPart - 0.36) div 0.05 * 0.04
    else
        return integerPart + 1.0
    end if
end standardisePrice

-- Test code:
set originals to {}
set standardised to {}
repeat 20 times
    set price to (random number 100) / 100
    set end of originals to text 2 thru -2 of ((price + 10.001) as text)
    set end of standardised to text 2 thru -2 of ((standardisePrice(price) + 10.001) as text)
end repeat

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
set output to linefeed & "Originals:    " & originals & linefeed & "Standardised: " & standardised
set AppleScript's text item delimiters to astid
return output
