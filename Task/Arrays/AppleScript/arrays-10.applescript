use AppleScript version "2.4" -- Mac OS 10.10 (Yosemite) or later.
use framework "Foundation" -- Allows access to NSArrays and other Foundation classes.

set myList to {1, "foo", 2.57, missing value, {1, 2, 3}} -- AppleScript list.
set myNSArray to current application's NSArray's arrayWithArray:myList -- Bridge the list to an NSArray.
set arrayLength to myNSArray's |count|() -- Get the array's length using its 'count' property.
--> 5
