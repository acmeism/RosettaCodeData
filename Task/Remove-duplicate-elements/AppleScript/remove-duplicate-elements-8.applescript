use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

set aList to {1, 2, 3, "a", "b", "c", 2, 3, 4, "c", {b:"c"}, {"c"}, "c", "d"}
set orderedSet to current application's class "NSOrderedSet"'s orderedSetWithArray:(aList)
return orderedSet's array() as list
