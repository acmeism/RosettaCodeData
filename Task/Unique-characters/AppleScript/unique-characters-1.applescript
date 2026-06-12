on uniqueCharacters(listOfStrings)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    set countedSet to current application's class "NSCountedSet"'s setWithArray:((listOfStrings as text)'s characters)
    set AppleScript's text item delimiters to astid
    set mutableSet to current application's class "NSMutableSet"'s setWithSet:(countedSet)
    tell countedSet to minusSet:(mutableSet)
    tell mutableSet to minusSet:(countedSet)
    set sortDescriptor to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("self") ¬
        ascending:(true) selector:("localizedStandardCompare:")

    return (mutableSet's sortedArrayUsingDescriptors:({sortDescriptor})) as list
end uniqueCharacters
