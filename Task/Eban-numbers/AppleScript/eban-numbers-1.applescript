(*
    Quickly generate all the (positive) eban numbers up to and including the
    specified end number, then lose those before the start number.
    0 is taken as "zero" rather than as "nought" or "nil".

    WARNING: The getEbans() handler returns a potentially very long list of numbers.
    Don't let such a list get assigned to a persistent variable or be the end result displayed in an editor!
*)

on getEbans(startNumber, endNumber)
    script o
        property output : {}
        property listCollector : missing value
        property temp : missing value
    end script

    if (startNumber > endNumber) then set {startNumber, endNumber} to {endNumber, startNumber}
    -- The range is limited to between 0 and 10^15 to keep within AppleScript's current number precision.
    -- Even so, some of the numbers may not /look/ right when displayed in a editor.
    set limit to 10 ^ 15 - 1
    if (endNumber > limit) then set endNumber to limit
    if (startNumber > limit) then set startNumber to limit

    -- Initialise the output list with 0 and the sub-1000 ebans, stopping if the end number's reached.
    -- The 0's needed for rest of the process, but is removed at the end.
    repeat with tens in {0, 30, 40, 50, 60}
        repeat with units in {0, 2, 4, 6}
            set thisEban to tens + units
            if (thisEban ≤ endNumber) then set end of o's output to thisEban
        end repeat
    end repeat

    -- Repeatedly sweep the output list, adding new ebans formed from the addition of those found previously
    -- to a suitable power of 1000 times each one. Stop when the end number's reached or exceeded.
    -- The output list may become very long and appending items to it individually take forever, so results are
    -- collected in short, 1000-item lists, which are concatenated to the output at the end of each sweep.
    set sweepLength to (count o's output)
    set multiplier to 1000
    repeat while (thisEban < endNumber) -- Per sweep.
        set o's temp to {}
        set o's listCollector to {o's temp}
        repeat with i from 2 to sweepLength -- Per eban found already. (Not the 0.)
            set baseAmount to (item i of o's output) * multiplier
            repeat with j from 1 to sweepLength by 1000 -- Per 1000-item list.
                set z to j + 999
                if (z > sweepLength) then set z to sweepLength
                repeat with k from j to z -- Per new eban.
                    set thisEban to baseAmount + (item k of o's output)
                    if (thisEban ≤ endNumber) then set end of o's temp to thisEban
                    if (thisEban ≥ endNumber) then exit repeat
                end repeat
                if (thisEban ≥ endNumber) then exit repeat
                set o's temp to {}
                set end of o's listCollector to o's temp
            end repeat
            if (thisEban ≥ endNumber) then exit repeat
        end repeat

        -- Concatentate this sweep's new lists together
        set listCount to (count o's listCollector)
        repeat until (listCount is 1)
            set o's temp to {}
            repeat with i from 2 to listCount by 2
                set end of o's temp to (item (i - 1) of o's listCollector) & (item i of o's listCollector)
            end repeat
            if (listCount mod 2 is 1) then set item -1 of o's temp to (end of o's temp) & (end of o's listCollector)
            set o's listCollector to o's temp
            set o's temp to {}
            set listCount to (count o's listCollector)
        end repeat
        -- Concatenate the result to the output list and prepare to go round again.
        set o's output to o's output & (beginning of o's listCollector)
        set sweepLength to sweepLength * sweepLength
        set multiplier to multiplier * multiplier
    end repeat

    -- Lose the initial 0 and any ebans before the specified start number.
    set resultCount to (count o's output)
    if (resultCount is 1) then
        set o's output to {}
    else
        repeat with i from 2 to resultCount
            if (item i of o's output ≥ startNumber) then exit repeat
        end repeat
        set o's output to items i thru resultCount of o's output
    end if
    if (endNumber = limit) then set end of o's output to "(Limit of AppleScript's number precision.)"

    return o's output
end getEbans

-- Task code:
on runTask()
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "

    set ebans to getEbans(0, 1000)
    set end of output to ((count ebans) as text) & " eban numbers between 0 and 1,000:" & (linefeed & "  " & ebans)
    set ebans to getEbans(1000, 4000)
    set end of output to ((count ebans) as text) & " between 1,000 and 4,000:" & (linefeed & "  " & ebans)
    set end of output to ((count getEbans(0, 10000)) as text) & " up to and including 10,000"
    set end of output to ((count getEbans(0, 100000)) as text) & " up to and including 100,000"
    set end of output to ((count getEbans(0, 1000000)) as text) & " up to and including 1,000,000"
    set end of output to ((count getEbans(0, 10000000)) as text) & " up to and including 10,000,000"
    set ebans to getEbans(6.606606602E+10, 1.0E+12)
    set end of output to ((count ebans) as text) & " between 66,066,066,020 and 1,000,000,000,000:" & (linefeed & "  " & ebans)

    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end runTask

runTask()
