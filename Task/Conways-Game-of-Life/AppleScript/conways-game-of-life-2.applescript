on RCTask(seed, dimensions, maxGenerations)
    -- Create a universe and start a list with its initial state.
    set universe to newUniverse(seed, dimensions)
    set {stateText} to universe's currentState()
    set output to {stateText}
    -- Add successive states to the list.
    repeat maxGenerations times
        set {stateText, noChanges} to universe's nextState()
        set end of output to stateText
        if (noChanges) then exit repeat
    end repeat
    -- Coerce the states to a single text, each followed by a short line of dashes.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to linefeed & "-----" & linefeed & linefeed
    set output to (output as text) & linefeed & "-----"
    set AppleScript's text item delimiters to astid

    return output
end RCTask

-- Return text containing the original and three generations of a "blinker" in a 3 x 3 grid.
return RCTask("***", {3, 3}, 3)
