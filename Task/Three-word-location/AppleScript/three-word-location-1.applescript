on locationToWords({latitude, longitude})
    -- "Convert" the coordinates to positive integers by adding enough degrees to ensure positive results,
    -- multiplying by enough to left shift by four decimal places, and rounding.
    set intLat to ((latitude + 90) * 10000) as integer
    set intLong to ((longitude + 180) * 10000) as integer
    -- Derive a 15-bit and two 14-bit values from the two results' 43 bits.
    set output to {intLat div 64, intLat mod 64 * 256 + intLong div 16384, intLong mod 16384}
    -- Coerce the three values to text "words" beginning with "W" and any necessary leading zeros.
    repeat with thisIndex in output
        set thisIndex's contents to "W" & text 2 thru 6 of ((100000 + thisIndex) as text)
    end repeat

    return output
end locationToWords

on wordsToLocation(threeWords)
    set indices to {}
    repeat with thisWord in threeWords
        set end of indices to (text 2 thru -1 of thisWord) as integer
    end repeat
    set intLat to (beginning of indices) * 64 + (item 2 of indices) div 256 mod 64
    set intLong to (item 2 of indices) mod 256 * 16384 + (end of indices)

    return {intLat / 10000 - 90, intLong / 10000 - 180}
end wordsToLocation

-- Task code:
local location, threeWords, checkLocation
set location to {28.3852, -81.5638}
set threeWords to locationToWords(location)
set checkLocation to wordsToLocation(threeWords)
return {location, threeWords, checkLocation}
