use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

set listOfText to words of "now is the time for all good men to come to the aid of the party"

set arrayOfStrings to current application's class "NSMutableArray"'s arrayWithArray:(listOfText)
set descendingByLength to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("length") ascending:(false)
set ascendingLexicographically to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("self") ascending:(true) selector:("localizedStandardCompare:")
tell arrayOfStrings to sortUsingDescriptors:({descendingByLength, ascendingLexicographically})

return arrayOfStrings as list
