use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on symmetricDifference(a, b)
    set unionArray to (current application's class "NSArray"'s arrayWithArray:({a, b}))'s ¬
        valueForKeyPath:("@distinctUnionOfArrays.self")
    set filter to current application's class "NSPredicate"'s ¬
        predicateWithFormat_("!((self IN %@) && (self IN %@))", a, b)

    return (unionArray's filteredArrayUsingPredicate:(filter)) as list
end symmetricDifference
