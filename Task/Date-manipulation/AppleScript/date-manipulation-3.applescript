use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on dateManipulationTask()
    set dateString to "March 7 2009 7:30pm EST"

    set dateFormatter to current application's class "NSDateFormatter"'s new()
    tell dateFormatter to setDateFormat:("MMMM d yyyy h:mma z")
    tell dateFormatter to setAMSymbol:("am")
    tell dateFormatter to setPMSymbol:("pm")
    set USLocale to current application's class "NSLocale"'s localeWithLocaleIdentifier:("en_US")
    tell dateFormatter to setLocale:(USLocale)
    set timeZone to current application's class "NSTimeZone"'s timeZoneWithAbbreviation:(last word of dateString)
    tell dateFormatter to setTimeZone:(timeZone)

    set inputDate to dateFormatter's dateFromString:(dateString)
    set newDate to current application's class "NSDate"'s dateWithTimeInterval:(12 * hours) sinceDate:(inputDate)

    return (dateFormatter's stringFromDate:(newDate)) as text
end dateManipulationTask

dateManipulationTask()
