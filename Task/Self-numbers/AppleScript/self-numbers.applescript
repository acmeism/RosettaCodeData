(*
    Base-10 self numbers by index (single or range).
    Follows an observed sequence pattern whereby, after the initial single-digit odd numbers, self numbers are
    grouped in runs whose members occur at numeric intervals of 11. Runs after the first one come in blocks of
    ten: eight runs of ten numbers followed by two shorter runs. The numeric interval between runs is usually 2,
    but that between shorter runs, and their length, depend on the highest-order digit change occurring in them.
    This connection with significant digit change means every ten blocks form a higher-order block, every ten
    of these a higher-order-still block, and so on.

    The code below appears to be good up to the last self number before 10^12 — ie. 999,999,999,997, which is
    returned as the 97,777,777,792nd such number. After this, instead of zero-length shorter runs, the actual
    pattern apparently starts again with a single run of 10, like the one at the beginning.
*)
on selfNumbers(indexRange)
    set indexRange to indexRange as list
    -- Script object with subhandlers and associated properties.
    script |subscript|
        property startIndex : beginning of indexRange
        property endIndex : end of indexRange
        property counter : 0
        property currentSelf : -1
        property output : {}

        -- Advance to the next self number in the sequence, append it to the output if required, indicate if finished.
        on doneAfterAdding(interval)
            set currentSelf to currentSelf + interval
            set counter to counter + 1
            if (counter < startIndex) then return false
            set end of my output to currentSelf
            return (counter = endIndex)
        end doneAfterAdding

        -- If necessary, fast forward to the last self number before the lowest-order block containing the first number required.
        on fastForward()
            if (counter ≥ startIndex) then return
            -- The highest-order blocks whose ends this script handles correctly contain 9,777,777,778 self numbers.
            -- The difference between equivalently positioned numbers in these blocks is 100,000,000,001.
            -- The figures for successively lower-order blocks have successively fewer 7s and 0s!
            set indexDiff to 9.777777778E+9
            set numericDiff to 1.00000000001E+11
            repeat until ((indexDiff < 98) or (counter = startIndex))
                set test to counter + indexDiff
                if (test < startIndex) then
                    set counter to test
                    set currentSelf to (currentSelf + numericDiff)
                else
                    set indexDiff to (indexDiff + 2) div 10
                    set numericDiff to numericDiff div 10 + 1
                end if
            end repeat
        end fastForward

        -- Work out a shorter run length based on the most significant digit change about to happen.
        on getShorterRunLength()
            set shorterRunLength to 9
            set temp to (|subscript|'s currentSelf) div 1000
            repeat while (temp mod 10 is 9)
                set shorterRunLength to shorterRunLength - 1
                set temp to temp div 10
            end repeat
            return shorterRunLength
        end getShorterRunLength
    end script

    -- Main process. Start with the single-digit odd numbers and first run.
    repeat 5 times
        if (|subscript|'s doneAfterAdding(2)) then return |subscript|'s output
    end repeat
    repeat 9 times
        if (|subscript|'s doneAfterAdding(11)) then return |subscript|'s output
    end repeat
    -- Fast forward if the start index hasn't yet been reached.
    tell |subscript| to fastForward()

    -- Sequencing loop, per lowest-order block.
    repeat
        -- Eight ten-number runs, each at a numeric interval of 2 from the end of the previous one.
        repeat 8 times
            if (|subscript|'s doneAfterAdding(2)) then return |subscript|'s output
            repeat 9 times
                if (|subscript|'s doneAfterAdding(11)) then return |subscript|'s output
            end repeat
        end repeat
        -- Two shorter runs, the second at an interval inversely related to their length.
        set shorterRunLength to |subscript|'s getShorterRunLength()
        repeat with interval in {2, 2 + (10 - shorterRunLength) * 13}
            if (|subscript|'s doneAfterAdding(interval)) then return |subscript|'s output
            repeat (shorterRunLength - 1) times
                if (|subscript|'s doneAfterAdding(11)) then return |subscript|'s output
            end repeat
        end repeat
    end repeat
end selfNumbers

-- Demo calls:
-- First to fiftieth self numbers.
selfNumbers({1, 50})
--> {1, 3, 5, 7, 9, 20, 31, 42, 53, 64, 75, 86, 97, 108, 110, 121, 132, 143, 154, 165, 176, 187, 198, 209, 211, 222, 233, 244, 255, 266, 277, 288, 299, 310, 312, 323, 334, 345, 356, 367, 378, 389, 400, 411, 413, 424, 435, 446, 457, 468}

-- One hundred millionth:
selfNumbers(100000000)
--> {1.022727208E+9}

-- 97,777,777,792nd:
selfNumbers(9.7777777792E+10)
--> {9.99999999997E+11}
