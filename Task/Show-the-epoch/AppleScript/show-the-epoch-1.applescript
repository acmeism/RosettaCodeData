use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

local CocoaEpoch, UnixEpoch

-- Get the date 0 seconds from the Cocoa epoch.
set CocoaEpoch to current application's class "NSDate"'s dateWithTimeIntervalSinceReferenceDate:(0)
-- The way it's rendered in its 'description' is good enough for the current purpose.
set CocoaEpoch to CocoaEpoch's |description|() as text

-- Get the date 0 seconds from the Unix epoch and format it in the same way.
set UnixEpoch to (do shell script "date -ur 0 '+%F %T %z'")

return "Cocoa epoch:  " & CocoaEpoch & linefeed & "Unix epoch:  " & UnixEpoch
