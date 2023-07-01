use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

set aVariable to current application's class "NSString"'s stringWithString:("world!")
set aVariable to aVariable's stringByReplacingCharactersInRange:({0, 0}) withString:("Hello ")
-- return aVariable as text

-- Or:
set aVariable to current application's class "NSString"'s stringWithString:("world!")
set aVariable to current application's class "NSString"'s stringWithFormat_("%@%@", "Hello ", aVariable)
-- return aVariable as text

-- Or:
set aVariable to current application's class "NSString"'s stringWithString:("world!")
set aVariable to aVariable's stringByReplacingOccurrencesOfString:("^") withString:("Hello ") ¬
    options:(current application's NSRegularExpressionSearch) range:({0, 0})
-- return aVariable as text
