use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on symmetricDifference(a, b)
    set a to current application's class "NSSet"'s setWithArray:(a)
    set b to current application's class "NSMutableSet"'s setWithArray:(b)

    set output to a's mutableCopy()
    tell output to minusSet:(b)
    tell b to minusSet:(a)
    tell output to unionSet:(b)

    return output's allObjects() as list
end symmetricDifference
