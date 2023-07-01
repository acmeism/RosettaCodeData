use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on ISINTest(ISIN)
    -- Check that the input is both text and 12 characters long …
    if not ((ISIN's class is text) and ((count ISIN) is 12)) then return false
    -- … and that it has the required format.
    set ISIN to current application's class "NSMutableString"'s stringWithString:(ISIN)
    if ((ISIN's rangeOfString:("^[A-Z]{2}[0-9A-Z]{9}[0-9]$") options:(current application's NSRegularExpressionSearch) range:({0, ISIN's |length|()}))'s |length|() is 0) then return false
    -- Replace all letters with text representations of equivalent decimal numbers in the range 10 to 35.
    set letterCharacters to characters of "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    repeat with i from 1 to 26
        tell ISIN to replaceOccurrencesOfString:(item i of letterCharacters) withString:((i + 9) as text) options:(0) range:({0, its |length|()})
    end repeat

    -- Apply the Luhn test handler from the "Luhn test of credit card numbers" task.
    -- <https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers#Straightforward>
    return luhnTest(ISIN as text)
end ISINTest

-- Test code:
set testResults to {}
repeat with ISIN in {"US0378331005", "US0373831005", "U50378331005", "US03378331005", "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"}
    set end of testResults to {testNumber:ISIN's contents, valid:ISINTest(ISIN)}
end repeat
return testResults
