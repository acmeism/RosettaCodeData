use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

local nums, output

set nums to current application's class "NSArray"'s arrayWithArray:({{5, 1, 3, 8, 9, 4, 8, 7}, {3, 5, 9, 8, 4}, {1, 3, 7, 9}})
set output to (nums's valueForKeyPath:("@distinctUnionOfArrays.self"))'s sortedArrayUsingSelector:("compare:")
return output as list
