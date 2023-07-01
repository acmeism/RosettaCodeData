use AppleScript version "2.4" -- Mac OS 10.10 (Yosemite) or later.
use framework "Foundation"

set now to current application's class "NSDate"'s |date|()
set systemTime to now's timeIntervalSinceReferenceDate()
-- Or, since timeIntervalSinceReferenceDate() is both an instance method and a class method:
-- set systemTime to current application's class "NSDate"'s timeIntervalSinceReferenceDate()

-- Format output:
set currentLocale to current application's class "NSLocale"'s currentLocale()
set nowAsText to (now's descriptionWithLocale:(currentLocale)) as text
set epoch to now's dateByAddingTimeInterval:(-systemTime)
-- Or:
-- set epoch to current application's class "NSDate"'s dateWithTimeIntervalSinceReferenceDate:(0)
set epochAsText to epoch's |description|() as text
return nowAsText & (linefeed & systemTime) & (" seconds since " & epochAsText)
