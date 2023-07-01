on kernighansEarthquakes(magnitudeToBeat)
    -- A local "owner" for the long AppleScript lists. Speeds up references to their items and properties.
    script o
        property individualEntries : {}
        property qualifyingEntries : {}
    end script

    -- Read the text file assuming it's UTF-8 encoded and get a list of the individual entries.
    set textFilePath to (path to desktop as text) & "data.txt"
    set earthquakeData to (read file textFilePath as «class utf8»)
    set o's individualEntries to earthquakeData's paragraphs
    -- Get the input magnitude in text form now rather than coercing it during the repeat.
    set magnitudeToBeat to magnitudeToBeat as text

    -- Check the entries with AppleScript's text item delimiters set to likely white space characters and considering numeric strings.
    -- With these delimiters, the entries' magnitudes will be the last 'text item' in each line
    -- (assuming for this exercise that there'll never be white space at the end of any of the lines).
    -- Store entries with qualifying magnitudes in a new list.
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to {space, tab, character id 160} -- White space characters.
    considering numeric strings -- Compare numbers in strings numerically instead of lexically.
        repeat with i from 1 to (count o's individualEntries)
            set thisEntry to item i of o's individualEntries
            if (thisEntry's last text item > magnitudeToBeat) then set end of o's qualifyingEntries to thisEntry
        end repeat
    end considering

    -- Coerce the list of qualifying earthquakes to a single, linefeed-delimited text and return the result.
    set AppleScript's text item delimiters to linefeed
    set largeEarthquakes to o's qualifyingEntries as text
    set AppleScript's text item delimiters to astid

    return largeEarthquakes
end kernighansEarthquakes

kernighansEarthquakes(6)
