use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

-- Get the run of non-white-space at the end, if any.
set aString to current application's class "NSString"'s stringWithString:("I am a string")
set matchRange to aString's rangeOfString:("\\S++$") ¬
    options:(current application's NSRegularExpressionSearch) range:({0, aString's |length|()})
if (matchRange's |length|() > 0) then
    set output to aString's substringWithRange:(matchRange)
else
    set output to "No match"
end if

-- Replace the first instance of "orig…" with "modified".
set anotherString to current application's class "NSString"'s stringWithString:("I am the original string")
set matchRange2 to anotherString's rangeOfString:("orig[a-z]*+") ¬
    options:(current application's NSRegularExpressionSearch) range:({0, anotherString's |length|()})
if (matchRange2's |length|() > 0) then
    set moreOutput to anotherString's stringByReplacingCharactersInRange:(matchRange2) withString:("modified")
else
    set moreOutput to anotherString
end if

return (output as text) & linefeed & moreOutput
