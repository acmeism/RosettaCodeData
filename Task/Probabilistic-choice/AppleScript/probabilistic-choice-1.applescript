use AppleScript version "2.5" -- Mac OS X 10.11 (El Capitan) or later.
use framework "Foundation"
use framework "GameplayKit"

on probabilisticChoices(mapping, picks)
    script o
        property mapping : {}
    end script

    -- Make versions of the mapping records with additional 'actual' properties …
    set mapping to current application's class "NSMutableArray"'s arrayWithArray:(mapping)
    tell mapping to makeObjectsPerformSelector:("addEntriesFromDictionary:") withObject:({actual:0})
    -- … ensuring that they're sorted (for accuracy) in descending order (for efficiency) of probability.
    set descriptor to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("probability") ascending:(false)
    tell mapping to sortUsingDescriptors:({descriptor})
    set o's mapping to mapping as list

    set rndGenerator to current application's class "GKRandomDistribution"'s distributionForDieWithSideCount:(picks)
    set onePickth to 1 / picks
    repeat picks times
        -- Get a random number between 0.0 and 1.0.
        set r to rndGenerator's nextUniform()
        -- Interpret the probability of the number occurring in the range it does
        -- as picking the item with the same probability of being picked.
        repeat with thisRecord in o's mapping
            set r to r - (thisRecord's probability)
            if (r ≤ 0) then
                set thisRecord's actual to (thisRecord's actual) + onePickth
                exit repeat
            end if
        end repeat
    end repeat

    return o's mapping
end probabilisticChoices

on task()
    set mapping to {{|item|:"aleph", probability:1 / 5}, {|item|:"beth", probability:1 / 6}, ¬
        {|item|:"gimel", probability:1 / 7}, {|item|:"daleth", probability:1 / 8}, ¬
        {|item|:"he", probability:1 / 9}, {|item|:"waw", probability:1 / 10}, ¬
        {|item|:"zayin", probability:1 / 11}, {|item|:"heth", probability:1759 / 27720}}
    set picks to 1000000
    set theResults to probabilisticChoices(mapping, picks)
    set output to {}
    set template to {"|item|:", missing value, ", probability:", missing value, ", actual:", missing value}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ""
    repeat with thisRecord in theResults
        set {|item|:item 2 of template, probability:item 4 of template, actual:item 6 of template} to thisRecord
        set {|item|:template's second item, probability:template's fourth item, actual:template's sixth item} to thisRecord
        set end of output to template as text
    end repeat
    set AppleScript's text item delimiters to "}, ¬
    {"
    set output to "{ ¬
    {" & output & "} ¬
}"
    set AppleScript's text item delimiters to astid
    return output
end task

task()
