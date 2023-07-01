on vanEckSequence(limit)
    script o
        property sequence : {}
        property lookup : {}
    end script

    set term to 0
    repeat with i from 1 to (limit - 1) -- 1-based indices.
        set end of o's sequence to term
        set t to term + 1 -- 1-based index.
        repeat (t - (count o's lookup)) times
            set end of o's lookup to missing value
        end repeat
        set previous_i to item t of o's lookup
        set item t of o's lookup to i
        if (previous_i is missing value) then
            set term to 0
        else
            set term to i - previous_i
        end if
    end repeat
    set end of o's sequence to term

    return o's sequence
end vanEckSequence

-- Task code:
tell vanEckSequence(1000) to return {items 1 thru 10, items 991 thru 1000}
