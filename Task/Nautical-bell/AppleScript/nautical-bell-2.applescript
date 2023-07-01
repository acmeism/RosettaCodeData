use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

property soundName : "Glass" -- The nearest system sound to a bell!
property leeway : 8 -- Number of seconds either side of the sounding time in which the bells are allowed to start.
property postNoreBritish : true -- 1, 2, 3, and 8 bells during last dog watch?
property halfHour : 30 * minutes

on idle
    local m, d, t, elapsed, bells, bellSound

    -- Get the month, day, and time (in seconds) of the current GMT date, shifted forward by 'leeway' seconds.
    set {month:m, day:d, time:t} to (current date) + (leeway - (time to GMT))
    -- How far is this into a half-hour?
    set elapsed to t mod halfHour
    -- If too far, just reset the idle and don't sound this time.
    if (elapsed mod halfHour > 2 * leeway) then return halfHour - (elapsed - leeway)

    -- Otherwise work out how many bells are required and sound them.
    if ((t < halfHour) and (d is 1) and (month is January)) then
        set bells to 16 -- New Year.
    else
        set bells to (t mod (4 * hours) div halfHour + 7) mod 8 + 1
        if ((postNoreBritish) and (t > 18 * hours) and (t < 20 * hours)) then set bells to bells - 4
    end if
    set bellSound to current application's class "NSSound"'s soundNamed:(soundName)
    repeat (bells div 2) times
        repeat 2 times
            tell bellSound to play()
            delay 0.7
            tell bellSound to |stop|()
        end repeat
        delay 1
    end repeat
    repeat bells mod 2 times
        tell bellSound to play()
        delay 0.7
        tell bellSound to |stop|()
    end repeat

    -- Request another call in half an hour's time, less however long the above took.
    return halfHour - (time of (current date)) mod halfHour
end idle
