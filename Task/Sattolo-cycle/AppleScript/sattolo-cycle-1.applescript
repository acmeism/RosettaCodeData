on sattoloShuffle(theList) -- In-place shuffle.
    repeat with i from (count theList) to 2 by -1
        set j to (random number from 1 to (i - 1))
        tell theList to set {item i, item j} to {item j, item i}
    end repeat
    return -- Return nothing (ie. not the result of the last action above).
end sattoloShuffle
