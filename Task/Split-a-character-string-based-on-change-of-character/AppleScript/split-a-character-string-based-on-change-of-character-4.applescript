use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on splitAtCharacterChanges(input)
    tell (current application's class "NSMutableString"'s stringWithString:(input)) to ¬
        return (its stringByReplacingOccurrencesOfString:("(.)\\1*+(?!$)") withString:("$0, ") ¬
            options:(current application's NSRegularExpressionSearch) range:({0, its |length|()})) as text
end splitAtCharacterChanges

-- Test code:
splitAtCharacterChanges("gHHH5YY++///\\")
