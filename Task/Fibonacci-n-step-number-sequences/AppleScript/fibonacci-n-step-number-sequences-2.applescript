-- Parameters:
-- n: …nacci step size as integer. Alternatively "Lucas".
-- F: Maximum …nacci index required. (0-based.)
on fibonacciNStep(n, F)
    script o
        property sequence : {0}
    end script
    if (n is "Lucas") then set {n, item 1 of o's sequence} to {2, 2}

    -- F1 (if included) is always 1.
    if (F > 0) then set end of o's sequence to 1
    -- F2 (ditto) is F0 + F1.
    if (F > 1) then set end of o's sequence to (beginning of o's sequence) + (end of o's sequence)
    -- Each further number up to and including Fn is twice the number preceding it.
    if (n > F) then set n to F
    repeat (n - 2) times
        set end of o's sequence to (end of o's sequence) * 2
    end repeat
    -- Beyond Fn, each number is twice the one preceding it, minus the number n places before that.
    set nBeforeEnd to -(n + 1)
    repeat (F - n) times
        set end of o's sequence to (end of o's sequence) * 2 - (item nBeforeEnd of o's sequence)
    end repeat

    return o's sequence
end fibonacciNStep

-- Test code:
set maxF to 15 -- Length of sequence required after the initial 0 or 2.
set seriesNames to {missing value, "fibonacci:  ", "tribonacci:  ", "tetranacci:  ", "pentanacci:  ", ¬
    "hexanacci:  ", "heptanacci:  ", "octonacci:  ", "nonanacci:  ", "decanacci:  "}
set output to {}

set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
repeat with nacciSize from 2 to 10
    set end of output to (item nacciSize of seriesNames) & fibonacciNStep(nacciSize, maxF) & " …"
end repeat
set end of output to "Lucas:  " & fibonacciNStep("lucas", maxF) & " …"
set AppleScript's text item delimiters to linefeed
set output to output as text
set AppleScript's text item delimiters to astid

return output
