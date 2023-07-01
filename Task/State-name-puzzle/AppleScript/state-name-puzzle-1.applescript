use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

on stateNamePuzzle()
    script o
        property stateNames : {"Alabama", "Alaska", "Arizona", "Arkansas", ¬
            "California", "Colorado", "Connecticut", "Delaware", ¬
            "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", ¬
            "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", ¬
            "Maine", "Maryland", "Massachusetts", "Michigan", ¬
            "Minnesota", "Mississippi", "Missouri", "Montana", ¬
            "Nebraska", "Nevada", "New Hampshire", "New Jersey", ¬
            "New Mexico", "New York", "North Carolina", "North Dakota", ¬
            "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", ¬
            "South Carolina", "South Dakota", "Tennessee", "Texas", ¬
            "Utah", "Vermont", "Virginia", ¬
            "Washington", "West Virginia", "Wisconsin", "Wyoming", ¬
            "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"}
        property workList : {}

        -- Custom comparison handler for the sort.
        on isGreater(a, b)
            return (beginning of a > beginning of b)
        end isGreater
    end script

    ignoring case
        -- Remove duplicates.
        repeat with i from 1 to (count o's stateNames)
            set thisName to o's stateNames's item i
            if ({thisName} is not in o's workList) then set end of o's workList to thisName
        end repeat
        set o's stateNames to o's workList

        -- Build a list of lists containing unique pairs of names preceded by
        -- text composed of their combined and sorted visible characters.
        set o's workList to {}
        set stateCount to (count o's stateNames)
        repeat with i from 1 to (stateCount - 1)
            set name1 to o's stateNames's item i
            repeat with j from (i + 1) to stateCount
                set name2 to o's stateNames's item j
                set chrs to (name1 & name2)'s characters
                tell sorter to sort(chrs, 1, -1, {})
                set end of o's workList to {join(chrs, "")'s word 1, {name1, name2}}
            end repeat
        end repeat

        -- Sort the lists on the character strings
        set pairCount to (count o's workList)
        tell sorter to sort(o's workList, 1, pairCount, {comparer:o})

        -- Look for groups of equal character strings and match
        -- associated name pairs not containing the same name(s).
        set output to {}
        set l to 1
        repeat while (l < pairCount)
            set chrs to beginning of o's workList's item l
            set r to l
            repeat while ((r < pairCount) and (beginning of o's workList's item (r + 1) = chrs))
                set r to r + 1
            end repeat
            if (r > l) then
                repeat with i from l to (r - 1)
                    set {name1, name2} to end of o's workList's item i
                    set text1 to join(result, " and ") & " --> "
                    repeat with j from (i + 1) to r
                        set pair2 to end of o's workList's item j
                        if (not (({name1} is in pair2) or ({name2} is in pair2))) then
                            set end of output to text1 & join(pair2, " and ")
                        end if
                    end repeat
                end repeat
            end if
            set l to r + 1
        end repeat
    end ignoring

    return join(output, linefeed)
end stateNamePuzzle

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

stateNamePuzzle()
