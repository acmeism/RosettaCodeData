use AppleScript version "2.5" -- OS X 10.11 (El Capitan) or later.
use framework "Foundation"
use framework "GameplayKit" -- For the random number generator (faster than AppleScript's).

on longStairs()
    set output to {"Sample from first run:", "Seconds   Steps behind    Steps ahead"}
    set RNG to current application's class "GKMersenneTwisterRandomSource"'s new()
    set {runCount, totalTime, totalLength, firstRun, padding} to {10000, 0, 0, true, "               "}
    repeat runCount times
        set t to 0
        set stepsBehind to 0
        set stepsAhead to 100
        repeat until (stepsAhead = 0)
            repeat 5 times
                if ((RNG's nextIntWithUpperBound:(stepsBehind + stepsAhead)) > stepsBehind) then
                    set stepsAhead to stepsAhead + 1
                else
                    set stepsBehind to stepsBehind + 1
                end if
            end repeat
            set t to t + 1
            set stepsBehind to stepsBehind + 1
            set stepsAhead to stepsAhead - 1
            if ((firstRun) and (t < 610) and (t > 599)) then ¬
                set end of output to text -5 thru -1 of (padding & t) & ¬
                    text -13 thru -1 of (padding & stepsBehind) & ¬
                    text -15 thru -1 of (padding & stepsAhead)
        end repeat
        set totalTime to totalTime + t
        set totalLength to totalLength + stepsBehind
        set firstRun to false
    end repeat
    set {avTime, avLength} to {totalTime / runCount, totalLength / runCount}
    set end of output to "Average time taken over " & intToText(runCount, ",") & " runs: " & ¬
        (avTime div minutes) & " minutes " & (avTime mod minutes) & " seconds"
    set end of output to "Average final staircase length: " & intToText(avLength div 1, ",") & ¬
        "." & text 3 thru -1 of ((avLength mod 1) as text) & " steps"

    return join(output, linefeed)
end longStairs

on intToText(int, separator)
    set groups to {}
    repeat while (int > 999)
        set groups's beginning to ((1000 + (int mod 1000 as integer)) as text)'s text 2 thru 4
        set int to int div 1000
    end repeat
    set groups's beginning to int
    return join(groups, separator)
end intToText

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

longStairs()
