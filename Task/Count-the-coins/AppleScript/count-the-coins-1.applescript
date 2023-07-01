-- All input values must be integers and multiples of the same monetary unit.
on countCoins(amount, denominations)
    -- Potentially long list of counters, initialised with 1 (result for amount 0) and 'amount' zeros.
    script o
        property counters : {1}
    end script
    repeat amount times
        set end of o's counters to 0
    end repeat

    -- Less labour-intensive alternative to the following repeat's c = 1 iteration.
    set coinValue to beginning of denominations
    repeat with n from (coinValue + 1) to (amount + 1) by coinValue
        set item n of o's counters to 1
    end repeat

    repeat with c from 2 to (count denominations)
        set coinValue to item c of denominations
        repeat with n from (coinValue + 1) to (amount + 1)
            set item n of o's counters to (item n of o's counters) + (item (n - coinValue) of o's counters)
        end repeat
    end repeat

    return end of o's counters
end countCoins

-- Task calls:
set c1 to countCoins(100, {25, 10, 5, 1})
set c2 to countCoins(1000 * 100, {100, 50, 25, 10, 5, 1})
return {c1, c2}
