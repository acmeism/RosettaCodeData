use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

set theList to {"1.3.6.1.4.1.11.2.17.19.3.4.0.10", "1.3.6.1.4.1.11.2.17.5.2.0.79", "1.3.6.1.4.1.11.2.17.19.3.4.0.4", ¬
    "1.3.6.1.4.1.11150.3.4.0.1", "1.3.6.1.4.1.11.2.17.19.3.4.0.1", "1.3.6.1.4.1.11150.3.4.0"}

set theArray to current application's class "NSMutableArray"'s arrayWithArray:(theList)
set theDescriptor to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("self") ¬
    ascending:(true) selector:("localizedStandardCompare:")
tell theArray to sortUsingDescriptors:({theDescriptor})
return theArray as list
