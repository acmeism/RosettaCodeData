use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on numberToWords(n)
    return (current application's class "NSNumberFormatter"'s localizedStringFromNumber:(n) numberStyle:(current application's NSNumberFormatterSpellOutStyle)) as text
end numberToWords

numberToWords(-3.6028797018963E+10)
--> "minus thirty-six billion twenty-eight million seven hundred ninety-seven thousand eighteen point nine six three"
