use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script "Insertion sort" -- <https://rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#AppleScript>

on sieveOfEratosthenes(limit)
    set mv to missing value
    script o
        property numberList : makelist(limit, missing value)
    end script
    set o's numberList's item 2 to 2
    set o's numberList's item 3 to 3
    repeat with n from 5 to (limit - 2) by 6
        set o's numberList's item n to n
        tell (n + 2) to set o's numberList's item it to it
    end repeat
    if (limit - n > 5) then tell (n + 6) to set o's numberList's item it to it
    repeat with n from 5 to (limit ^ 0.5 div 1) by 6
        if (o's numberList's item n = n) then
            repeat with multiple from (n * n) to limit by n
                set o's numberList's item multiple to mv
            end repeat
        end if
        tell (n + 2)
            if (o's numberList's item it = it) then
                repeat with multiple from (it * it) to limit by it
                    set o's numberList's item multiple to mv
                end repeat
            end if
        end tell
    end repeat

    return o's numberList's numbers
end sieveOfEratosthenes

on makelist(limit, filler)
    if (limit < 1) then return {}
    script o
        property lst : {filler}
    end script

    set counter to 1
    repeat until (counter + counter > limit)
        set o's lst to o's lst & o's lst
        set counter to counter + counter
    end repeat
    if (counter < limit) then set o's lst to o's lst & o's lst's items 1 thru (limit - counter)
    return o's lst
end makelist

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on ordinalise(n)
    set units to n mod 10
    if ((units > 3) or (n div 10 mod 10 is 1) or (units < 1) or (units mod 1 > 0)) then ¬
        return (n as text) & "th"
    return (n as text) & item units of {"st", "nd", "rd"}
end ordinalise

on task()
    script o
        -- Enough primes to include the first > the square root of 100,000,000.
        property primes : sieveOfEratosthenes(10020)
        -- Collector for enough not-quite-ordered brilliants to include the first 100.
        property first250 : {}
    end script
    -- List of data collectors for nine magnitudes.
    set {magData, mag, mv} to {{}, 1, missing value}
    repeat 9 times
        set magData's end to {magnitude:mag, lowest:mv, |count|:0}
        set mag to mag * 10
    end repeat

    -- Calculate the brilliant numbers and store the relevant info.
    set {primeMag, counter} to {1, 0}
    repeat with k from 1 to (count o's primes)
        set thisPrime to o's primes's item k
        if (thisPrime ≥ primeMag) then
            set primeMag to primeMag * 10
            set i to k
        end if
        repeat with j from i to k
            set thisBrill to thisPrime * (o's primes's item j)
            if (counter < 250) then
                set counter to counter + 1
                set o's first250's end to thisBrill
            end if
            repeat with m from 9 to 1 by -1
                set theseData to magData's item m
                if (thisBrill ≥ theseData's magnitude) then
                    if ((theseData's lowest is mv) or (theseData's lowest > thisBrill)) then ¬
                        set theseData's lowest to thisBrill
                    set theseData's |count| to (theseData's |count|) + 1
                    exit repeat
                end if
            end repeat
        end repeat
    end repeat

    -- Get the first 100 brilliants from the first 250 collected.
    tell sorter to sort(o's first250, 1, counter)
    set output to {"The first 100 brilliant numbers are:"}
    set theseTen to {}
    repeat with i from 1 to 100 by 10
        repeat with j from i to i + 9
            set theseTen's end to ("     " & o's first250's item j)'s text -6 thru end
        end repeat
        set output's end to join(theseTen, "")
        set theseTen to {}
    end repeat

    -- Get the data from the magnitude records.
    set counter to 1
    repeat with theseData in magData
        set output's end to "The first ≥ " & (theseData's magnitude) & ¬
            " is the " & ordinalise(counter) & ": " & (theseData's lowest)
        set counter to counter + (theseData's |count|)
    end repeat

    return join(output, linefeed)
end task

task()
