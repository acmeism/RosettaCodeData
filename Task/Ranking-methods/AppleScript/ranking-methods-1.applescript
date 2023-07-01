use AppleScript version "2.3.1" -- Mac OS 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

(* The ranking methods are implemented as script objects sharing inherited code. *)
script standardRanking
    -- Properties and handlers inherited or overridden by the other script objects.
    -- The 'reference' is to a value that won't exist until 'results' is set to a list.
    -- 'me' and 'my' pertain to the script object using the code at the time.
    property results : missing value
    property startIndex : 1
    property endIndex : a reference to my results's length
    property step : 1
    property currentRank : missing value
    property currentScore : missing value

    -- Main handler.
    on resultsFrom(theScores)
        copy theScores to my results
        tell sorter to sort(my results, my startIndex, my endIndex, {comparer:me})
        set my currentScore to my results's item (my startIndex)'s score
        set my currentRank to my startIndex's contents
        repeat with i from (my startIndex) to (my endIndex) by (my step)
            my rankResult(i)
        end repeat
        set r to my results
        set my results to missing value
        return r
    end resultsFrom

    -- Comparison handler used by the sort.
    on isGreater(a, b)
        if (a's score < b's score) then return true
        return ((a's score = b's score) and (a's competitor comes after b's competitor))
    end isGreater

    -- Ranking handler. Inherited by the modifiedRanking script; overridden by the others.
    on rankResult(i)
        set thisResult to my results's item i
        set thisScore to thisResult's score
        if (thisScore is not currentScore) then
            set my currentRank to i
            set my currentScore to thisScore
        end if
        set my results's item i to thisResult & {rank:my currentRank}
    end rankResult
end script

script modifiedRanking
    property parent : standardRanking
    property startIndex : a reference to my results's length
    property endIndex : 1
    property step : -1
end script

script denseRanking
    property parent : standardRanking

    on rankResult(i)
        set thisResult to my results's item i
        set thisScore to thisResult's score
        if (thisScore is not my currentScore) then
            set my currentRank to (my currentRank) + 1
            set my currentScore to thisScore
        end if
        set my results's item i to thisResult & {rank:my currentRank}
    end rankResult
end script

script ordinalRanking
    property parent : standardRanking

    on rankResult(i)
        set my results's item i to (my results's item i) & {rank:i}
    end rankResult
end script

script fractionalRanking
    property parent : standardRanking

    on rankResult(i)
        set thisResult to my results's item i
        set thisScore to thisResult's score
        if (thisScore is not my currentScore) then
            -- The average of any run of consecutive integers is that of the first and last.
            set average to (i - 1 + (my currentRank)) / 2
            repeat with j from (my currentRank) to (i - 1)
                set my results's item j's rank to average
            end repeat
            set my currentRank to i
            set my currentScore to thisScore
        end if
        set my results's item i to thisResult & {rank:i as real}
    end rankResult
end script

-- Task code:
on formatRankings(type, theResults)
    set rankings to {type}
    repeat with thisResult in theResults
        set end of rankings to (thisResult's rank as text) & tab & ¬
            thisResult's competitor & " (" & thisResult's score & ")"
    end repeat

    return join(rankings, linefeed)
end formatRankings

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

local theScores, output
set theScores to {{score:44, competitor:"Solomon"}, {score:42, competitor:"Jason"}, ¬
    {score:42, competitor:"Errol"}, {score:41, competitor:"Garry"}, {score:41, competitor:"Bernard"}, ¬
    {score:41, competitor:"Barry"}, {score:39, competitor:"Stephen"}}
set output to {¬
    formatRankings("Standard ranking:", standardRanking's resultsFrom(theScores)), ¬
    formatRankings("Modified ranking:", modifiedRanking's resultsFrom(theScores)), ¬
    formatRankings("Dense ranking:", denseRanking's resultsFrom(theScores)), ¬
    formatRankings("Ordinal ranking:", ordinalRanking's resultsFrom(theScores)), ¬
    formatRankings("Fractional ranking:", fractionalRanking's resultsFrom(theScores)) ¬
        }
return join(output, linefeed & linefeed)
