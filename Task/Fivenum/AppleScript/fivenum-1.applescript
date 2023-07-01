use AppleScript version "2.4" -- Mac OS X 10.10. (Yosemite) or later.
use framework "Foundation"

on fivenum(listOfNumbers, l, r)
    script o
        property lst : missing value

        on medianFromRange(l, r)
            set m1 to (l + r) div 2
            set m2 to m1 + (l + r) mod 2
            set median to my lst's item m1
            if (m2 > m1) then set median to (median + (my lst's item m2)) / 2

            return {median, m1, m2}
        end medianFromRange
    end script

    if ((listOfNumbers is {}) or (r - l < 0)) then return missing value
    set o's lst to current application's class "NSMutableArray"'s arrayWithArray:(listOfNumbers)
    tell o's lst to sortUsingSelector:("compare:")
    set o's lst to o's lst as list

    set {median, m1, m2} to o's medianFromRange(l, r)
    set {lowerQuartile} to o's medianFromRange(l, m1)
    set {upperQuartile} to o's medianFromRange(m2, r)

    return {o's lst's beginning, lowerQuartile, median, upperQuartile, o's lst's end}
end fivenum

-- Test code:
set x to {15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43}
set y to {36, 40, 7, 39, 41, 15}
set z to {0.14082834, 0.0974879, 1.73131507, 0.87636009, -1.95059594, 0.73438555, -0.03035726, 1.4667597, -0.74621349, -0.72588772, ¬
    0.6390516, 0.61501527, -0.9898378, -1.00447874, -0.62759469, 0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578}
return {fivenum(x, 1, count x), fivenum(y, 1, count y), fivenum(z, 1, count z)}
