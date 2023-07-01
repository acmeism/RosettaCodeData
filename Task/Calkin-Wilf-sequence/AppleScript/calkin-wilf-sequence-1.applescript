-- Return the first n terms of the sequence. Tree generation. Faster for this purpose.
on CalkinWilfSequence(n)
    script o
        property sequence : {{1, 1}} -- Initialised with the first term ({numerator, denominator}).
    end script

    -- Work through the growing sequence list, adding the two children of each term to the end and
    -- converting each term to text representing the vulgar fraction. Stop adding children halfway through.
    set halfway to n div 2
    repeat with position from 1 to n
        set {numerator, denominator} to item position of o's sequence
        if (position ≤ halfway) then
            tell numerator + denominator
                set end of o's sequence to {numerator, it}
                if ((position < halfway) or (position * 2 < n)) then set end of o's sequence to {it, denominator}
            end tell
        end if
        set item position of o's sequence to (numerator as text) & "/" & denominator
    end repeat

    return o's sequence
end CalkinWilfSequence

-- Alternatively, return terms pos1 to pos2. Binary run-length encoding. Doesn't need to work from the beginning of the sequence.
on CalkinWilfSequence2(pos1, pos2)
    script o
        property sequence : {}
    end script

    repeat with position from pos1 to pos2
        -- Build a continued fraction list from the binary run-length encoding of this position index.
        -- There's no need to put the last value into the list as it's used immediately.
        set continuedFraction to {}
        set bitValue to 1
        set runLength to 0
        repeat until (position = 0)
            if (position mod 2 = bitValue) then
                set runLength to runLength + 1
            else
                set end of continuedFraction to runLength
                set bitValue to (bitValue + 1) mod 2
                set runLength to 1
            end if
            set position to position div 2
        end repeat
        -- Work out the numerator and denominator from the continued fraction and derive text representing the vulgar fraction.
        set numerator to runLength
        set denominator to 1
        repeat with i from (count continuedFraction) to 1 by -1
            tell numerator
                set numerator to numerator * (item i of continuedFraction) + denominator
                set denominator to it
            end tell
        end repeat
        set end of o's sequence to (numerator as text) & "/" & denominator
    end repeat

    return o's sequence
end CalkinWilfSequence2

-- Return the sequence position of the term with the given numerator and denominator.
on CalkinWilfSequencePosition(numerator, denominator)
    -- Build a continued fraction list from the input.
    set continuedFraction to {}
    repeat until (denominator is 0)
        set end of continuedFraction to numerator div denominator
        set {numerator, denominator} to {denominator, numerator mod denominator}
    end repeat
    -- If it has an even number of entries, convert to the equivalent odd number.
    if ((count continuedFraction) mod 2 is 0) then
        set last item of continuedFraction to (last item of continuedFraction) - 1
        set end of continuedFraction to 1
    end if
    -- "Binary run-length decode" the entries to get the position index.
    set position to 0
    set bitValue to 1
    repeat with i from (count continuedFraction) to 1 by -1
        repeat (item i of continuedFraction) times
            set position to position * 2 + bitValue
        end repeat
        set bitValue to (bitValue + 1) mod 2
    end repeat

    return position
end CalkinWilfSequencePosition

-- Task code:
local sequenceResult1, sequenceResult2, positionResult, output, astid
set sequenceResult1 to CalkinWilfSequence(20)
set sequenceResult2 to CalkinWilfSequence2(1, 20)
set positionResult to CalkinWilfSequencePosition(83116, 51639)
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to ", "
set output to "First twenty terms of sequence using tree generation:" & (linefeed & sequenceResult1)
set output to output & (linefeed & "Ditto using binary run-length encoding:") & (linefeed & sequenceResult1)
set AppleScript's text item delimiters to astid
set output to output & (linefeed & "83116/51639 is term number " & positionResult)
return output
