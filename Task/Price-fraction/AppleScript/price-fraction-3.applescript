-- This handler just returns the standardised real value. It's up to external processes to format it for display.

on standardisePrice(input, table)
    set integerPart to input div 1.0
    set fractionalPart to input mod 1.0

    if (fractionalPart is 0.0) then return input as real
    repeat with thisEntry in table
        if (fractionalPart ≤ beginning of thisEntry) then return integerPart + (end of thisEntry)
    end repeat
end standardisePrice

-- Test code:
-- The conceit here is that the conversion table has been obtained from a file or from a spreadsheet application.
set table to {{0.05, 0.1}, {0.1, 0.18}, {0.15, 0.26}, {0.2, 0.32}, {0.25, 0.38}, {0.3, 0.44}, {0.35, 0.5}, {0.4, 0.54}, {0.45, 58}, {0.5, 0.62}, {0.55, 0.66}, {0.6, 0.7}, {0.65, 0.74}, {0.7, 0.78}, {0.75, 0.82}, {0.8, 0.86}, {0.85, 0.9}, {0.9, 0.94}, {0.95, 0.98}, {0.99, 1.0}}

set originals to {}
set standardised to {}
repeat 20 times
    set price to (random number 100) / 100
    set end of originals to text 2 thru -2 of ((price + 10.001) as text)
    set end of standardised to text 2 thru -2 of ((standardisePrice(price, table) + 10.001) as text)
end repeat

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
set output to linefeed & "Originals:    " & originals & linefeed & "Standardised: " & standardised
set AppleScript's text item delimiters to astid
return output
