on popCount(n)
    set counter to 0
    repeat until (n is 0)
        set counter to counter + n mod 2
        set n to n div 2
    end repeat

    return counter div 1
end popCount

-- Task code:
-- Get the popcounts of the first 30 powers of 3.
set list1 to {}
repeat with i from 0 to 29
    set end of list1 to popCount(3 ^ i)
end repeat

-- Collate the integers from 0 to 59 according to the evenness or oddness of their popcounts.
-- In any even number of consecutive integers, exactly half are "evil" and half "odious". Thus thirty of each here.
set lists2and3 to {{}, {}}
repeat with i from 0 to 59
    set end of item (popCount(i) mod 2 + 1) of lists2and3 to i
end repeat

-- Arrange the results for display.
set astid to AppleScript's text item delimiters
set AppleScript's text item delimiters to space
set {list1, list2, list3} to {list1 as text, beginning of lists2and3 as text, end of lists2and3 as text}
set AppleScript's text item delimiters to linefeed
set output to {"Popcounts of 1st thirty powers of 3:", list1, "1st thirty evil numbers:", list2, "1st thirty odious numbers:", list3} ¬
    as text
set AppleScript's text item delimiters to astid
return output
