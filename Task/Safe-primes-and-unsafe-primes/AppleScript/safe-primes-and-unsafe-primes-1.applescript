-- Heavy-duty Sieve of Eratosthenes handler.
-- Returns a list containing either just the primes up to a given limit ('crossingsOut' = false) or, as in this task,
-- both the primes and 'missing values' representing the "crossed out" non-primes ('crossingsOut' = true).
on sieveForPrimes given limit:limit, crossingsOut:keepingZaps
    if (limit < 1) then return {}
    -- Build a list initially containing only 'missing values'. For speed, and to reduce the likelihood of hanging,
    -- do this by building sublists of at most 5000 items and concatenating them afterwards.
    script o
        property sublists : {}
        property numberList : {}
    end script
    set sublistSize to 5000
    set mv to missing value -- Use a single 'missing value' instance for economy.
    repeat sublistSize times
        set end of o's numberList to mv
    end repeat
    -- Start with a possible < 5000-item sublist.
    if (limit mod sublistSize > 0) then set end of o's sublists to items 1 thru (limit mod sublistSize) of o's numberList
    -- Then any 5000-item sublists needed.
    if (limit ≥ sublistSize) then
        set end of o's sublists to o's numberList
        repeat (limit div sublistSize - 1) times
            set end of o's sublists to o's numberList's items
        end repeat
    end if
    -- Concatenate them more-or-less evenly.
    set subListCount to (count o's sublists)
    repeat until (subListCount is 1)
        set o's numberList to {}
        repeat with i from 2 to subListCount by 2
            set end of o's numberList to (item (i - 1) of o's sublists) & (item i of o's sublists)
        end repeat
        if (i < subListCount) then set last item of o's numberList to (end of o's numberList) & (end of o's sublists)
        set o's sublists to o's numberList
        set subListCount to subListCount div 2
    end repeat
    set o's numberList to beginning of o's sublists

    -- Set the relevant list positions to 2, 3, 5, and numbers which aren't multiples of them.
    if (limit > 1) then set item 2 of o's numberList to 2
    if (limit > 2) then set item 3 of o's numberList to 3
    if (limit > 4) then set item 5 of o's numberList to 5
    if (limit < 36) then
        set n to -23
    else
        repeat with n from 7 to (limit - 29) by 30
            set item n of o's numberList to n
            tell (n + 4) to set item it of o's numberList to it
            tell (n + 6) to set item it of o's numberList to it
            tell (n + 10) to set item it of o's numberList to it
            tell (n + 12) to set item it of o's numberList to it
            tell (n + 16) to set item it of o's numberList to it
            tell (n + 22) to set item it of o's numberList to it
            tell (n + 24) to set item it of o's numberList to it
        end repeat
    end if
    repeat with n from (n + 30) to limit
        if ((n mod 2 > 0) and (n mod 3 > 0) and (n mod 5 > 0)) then set item n of o's numberList to n
    end repeat

    -- "Cross out" inserted numbers which are multiples of others.
    set inx to {0, 4, 6, 10, 12, 16, 22, 24}
    repeat with n from 7 to ((limit ^ 0.5) div 1) by 30
        repeat with inc in inx
            tell (n + inc)
                if (item it of o's numberList is it) then
                    repeat with multiple from (it * it) to limit by it
                        set item multiple of o's numberList to mv
                    end repeat
                end if
            end tell
        end repeat
    end repeat

    if (keepingZaps) then return o's numberList
    return o's numberList's numbers
end sieveForPrimes

-- Task code:
on doTask()
    set {safeQuantity, unsafeQuantity, max1, max2} to {35, 40, 1000000 - 1, 10000000 - 1}
    set {safePrimes, unsafePrimes, safeCount1, safeCount2, unsafeCount1, unsafeCount2} to {{}, {}, 0, 0, 0, 0}
    -- Get a list of 9,999,999 primes and "crossed out" non-primes! Also one with just the primes.
    script o
        property primesAndZaps : sieveForPrimes with crossingsOut given limit:max2
        property primesOnly : my primesAndZaps's numbers
    end script
    -- Work through the primes-only list, using the other as an indexable look-up to check the related numbers.
    set SophieGermainLimit to (max2 - 1) div 2
    repeat with n in o's primesOnly
        set n to n's contents
        if (n ≤ SophieGermainLimit) then
            tell (n * 2 + 1)
                if (item it of o's primesAndZaps is it) then
                    if (safeCount2 < safeQuantity) then set end of safePrimes to it
                    if (it < max1) then set safeCount1 to safeCount1 + 1
                    set safeCount2 to safeCount2 + 1
                end if
            end tell
        end if
        if ((n is 2) or (item ((n - 1) div 2) of o's primesAndZaps is missing value)) then
            if (unsafeCount2 < unsafeQuantity) then set end of unsafePrimes to n
            if (n < max1) then set unsafeCount1 to unsafeCount1 + 1
            set unsafeCount2 to unsafeCount2 + 1
        end if
    end repeat
    -- Format and output the results.
    set output to {}
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to ", "
    set end of output to "First 35 safe primes:"
    set end of output to safePrimes as text
    set end of output to "There are " & safeCount1 & " safe primes < 1,000,000 and " & safeCount2 & " < 10,000,000."
    set end of output to ""
    set end of output to "First 40 unsafe primes:"
    set end of output to unsafePrimes as text
    set end of output to "There are " & unsafeCount1 & " unsafe primes < 1,000,000 and " & unsafeCount2 & " < 10,000,000."
    set AppleScript's text item delimiters to linefeed
    set output to output as text
    set AppleScript's text item delimiters to astid

    return output
end doTask

return doTask()
