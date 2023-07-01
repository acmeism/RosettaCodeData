on task()
    script o
        property cyclopses : {}
        property primeCyclopses : {}
        property blindPrimeCyclopses : {}
        property palindromicPrimeCyclopses : {}

        on add1(digitList)
            set carry to 1
            repeat with i from (count digitList) to 1 by -1
                set columnSum to (digitList's item i) + carry
                if (columnSum < 10) then
                    set digitList's item i to columnSum
                    return false -- Finish and indicate "no carry".
                end if
                -- Otherwise set this digit to 1 instead of to 0 and "carry" on.  ;)
                set digitList's item i to 1
            end repeat
            return true
        end add1

        on intFromDigits(digitList)
            if (digitList = {}) then return 0
            set n to digitList's beginning
            repeat with i from 2 to (count digitList)
                set n to n * 10 + (digitList's item i)
            end repeat
            return n
        end intFromDigits

        on store(cyclops, lst, counter)
            if (counter < 51) then
                set lst's end to cyclops
            else if (cyclops > 10000000) then
                set lst's end to {cyclops, counter}
                return false -- No more for this list, thanks.
            end if
            return true
        end store
    end script

    set {leftDigits, rightDigits, rightless, shiftFactor} to {{}, {}, 0, 10}
    set {cRef, pcRef, bpcRef, ppcRef} to {a reference to o's cyclopses, ¬
        a reference to o's primeCyclopses, a reference to o's blindPrimeCyclopses, ¬
        a reference to o's palindromicPrimeCyclopses}
    set {cCount, pcCount, bpcCount, ppcCount} to {0, 0, 0, 0}
    set {cActive, pcActive, bpcActive, ppcActive} to {true, true, true, true}
    repeat while ((bpcActive) or (ppcActive))
        set |right| to o's intFromDigits(rightDigits)
        set cyclops to rightless + |right|
        if (cActive) then
            set cCount to cCount + 1
            set cActive to o's store(cyclops, cRef, cCount)
        end if
        if (isPrime(cyclops)) then
            if (pcActive) then
                set pcCount to pcCount + 1
                set pcActive to o's store(cyclops, pcRef, pcCount)
            end if
            if (bpcActive) then
                set blinded to rightless div 10 + |right|
                if (isPrime(blinded)) then
                    set bpcCount to bpcCount + 1
                    set bpcActive to o's store(cyclops, bpcRef, bpcCount)
                end if
            end if
            if ((ppcActive) and (rightDigits = stigiDtfel)) then
                set ppcCount to ppcCount + 1
                set ppcActive to o's store(cyclops, ppcRef, ppcCount)
            end if
        end if
        if (o's add1(rightDigits)) then
            -- Adding 1 to rightDigits produced a carry. Add 1 to leftDigits too.
            if (o's add1(leftDigits)) then
                -- Also carried. Extend both lists by 1 digit.
                set {leftDigits's beginning, rightDigits's beginning} to {1, 1}
                set shiftFactor to shiftFactor * 10
            end if
            set rightless to (o's intFromDigits(leftDigits)) * shiftFactor
            set stigiDtfel to leftDigits's reverse
        end if
    end repeat

    set output to {}
    repeat with this in {{"", o's cyclopses}, {"prime ", o's primeCyclopses}, ¬
        {"blind prime ", o's blindPrimeCyclopses}, ¬
        {"palindromic prime ", o's palindromicPrimeCyclopses}}
        set {type, cyclopses} to this
        set output's end to linefeed & "First 50 " & type & "cyclops numbers:"
        repeat with i from 1 to 50 by 10
            set row to {}
            repeat with j from i to (i + 9)
                set row's end to ("      " & cyclopses's item j)'s text -7 thru -1
            end repeat
            set output's end to join(row, "  ")
        end repeat
        set {nth, n} to cyclopses's end
        set output's end to "The first such number > ten million is the " & n & "th: " & nth
    end repeat
    join(output, linefeed)
end task

on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    repeat with i from 5 to (n ^ 0.5) div 1 by 6
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
    end repeat

    return true
end isPrime

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

task()
