set aString to "This is some text"

set stringLength to (count aString) -- The number of characters in the text.

-- AppleScript indices are 1-based. Ranges can be specified in several different ways.
if (stringLength > 1) then
    set substring1 to text 2 thru stringLength of aString
    -- set substring1 to text 2 thru -1 of aString
    -- set substring1 to text 2 thru end of aString
    -- set substring1 to text from character 2 to character stringLength of aString
    -- set substring1 to aString's text from 2 to -1
    -- Some combination of the above.
else
    set substring1 to ""
end if

if (stringLength > 1) then
    set substring2 to text 1 thru -2 of aString
else
    set substring2 to ""
end if

if (stringLength > 2) then
    set substring3 to text 2 thru -2 of aString
else
    set substring3 to ""
end if

return substring1 & linefeed & substring2 & linefeed & substring3
