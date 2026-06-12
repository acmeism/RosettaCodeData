use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on uniqueCharactersInEachString(listOfstrings)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set countedSet to current application's class "NSCountedSet"'s setWithArray:(characters of (listOfstrings as text))
    set AppleScript's text item delimiters to astid
    set mutableSet to current application's class "NSMutableSet"'s setWithSet:(countedSet)
    repeat with thisString in listOfstrings
        tell mutableSet to intersectSet:(current application's class "NSSet"'s setWithArray:(thisString's characters))
        tell countedSet to minusSet:(mutableSet)
    end repeat
    tell mutableSet to minusSet:(countedSet)
    set sortDescriptor to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("self") ¬
        ascending:(true) selector:("localizedStandardCompare:")

    return (mutableSet's sortedArrayUsingDescriptors:({sortDescriptor})) as list
end uniqueCharactersInEachString

uniqueCharactersInEachString({"1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"})
