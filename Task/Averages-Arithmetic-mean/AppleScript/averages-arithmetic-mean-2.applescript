use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"

on average(listOfNumbers)
    if ((count listOfNumbers) is 0) then return missing value

    set arrayOfNumbers to current application's class "NSArray"'s arrayWithArray:(listOfNumbers)
    return (arrayOfNumbers's valueForKeyPath:("@avg.self")) as real
end average

average({2500, 2700, 2400, 2300, 2550, 2650, 2750, 2450, 2600, 2400})
