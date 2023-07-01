use AppleScript version "2.4" -- OS X 10.10 (Yosemite) or later
use framework "Foundation"
use scripting additions

on letterFrequencyinFile(theFile)
    -- Read the file as an NSString, letting the system guess the encoding.
    set fileText to current application's class "NSString"'s stringWithContentsOfFile:(POSIX path of theFile) ¬
        usedEncoding:(missing value) |error|:(missing value)
    -- Get the NSString's non-letter delimited runs, lower-cased, as an AppleScript list of texts.
    -- The switch to vanilla objects is for speed and the ability to extract 'characters'.
    set nonLetterSet to current application's class "NSCharacterSet"'s letterCharacterSet()'s invertedSet()
    script o
        property letterRuns : (fileText's lowercaseString()'s componentsSeparatedByCharactersInSet:(nonLetterSet)) as list
    end script

    -- Extract the characters from the runs and add them to an NSCountedSet to have the occurrences of each value counted.
    -- No more than 50,000 characters are extracted in one go to avoid slowing or freezing the script.
    set countedSet to current application's class "NSCountedSet"'s new()
    repeat with i from 1 to (count o's letterRuns)
        set thisRun to item i of o's letterRuns
        set runLength to (count thisRun)
        repeat with i from 1 to runLength by 50000
            set j to i + 49999
            if (j > runLength) then set j to runLength
            tell countedSet to addObjectsFromArray:(characters i thru j of thisRun)
        end repeat
    end repeat

    -- Work through the counted set's contents and build a list of records showing how many of what it received.
    set output to {}
    repeat with thisLetter in countedSet's allObjects()
        set thisCount to (countedSet's countForObject:(thisLetter))
        set end of output to {letter:thisLetter, |count|:thisCount}
    end repeat

    -- Derive an array of dictionaries from the list and sort it on the letters.
    set output to current application's class "NSMutableArray"'s arrayWithArray:(output)
    set byLetter to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("letter") ¬
        ascending:(true) selector:("localizedStandardCompare:")
    tell output to sortUsingDescriptors:({byLetter})

    -- Convert back to a list of records and return the result.
    return output as list
end letterFrequencyinFile

-- Test with the text file for the "Word frequency" task.
set theFile to ((path to desktop as text) & "135-0.txt") as alias
return letterFrequencyinFile(theFile)
