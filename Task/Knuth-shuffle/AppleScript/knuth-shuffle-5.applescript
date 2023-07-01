use AppleScript version "2.5" -- OS X 10.11 (El Capitan) or later
use framework "Foundation"
use framework "GameplayKit"

on shuffle(theList, l, r)
    set listLength to (count theList)
    if (listLength < 2) then return theList
    if (l < 0) then set l to listLength + l + 1
    if (r < 0) then set r to listLength + r + 1
    if (l > r) then set {l, r} to {r, l}
    script o
        property lst : theList
    end script

    set rndGenerator to current application's class "GKRandomDistribution"'s distributionWithLowestValue:(l) highestValue:(r)
    repeat with i from r to (l + 1) by -1
        set j to (rndGenerator's nextIntWithUpperBound:(i))
        set v to o's lst's item i
        set o's lst's item i to o's lst's item j
        set o's lst's item j to v
    end repeat

    return theList
end shuffle
