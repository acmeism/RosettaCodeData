-- Return a script object containing: 1) a list of all the integers in the required range and
-- 2) a handler that returns one of them at random without repeating any previous choices.
-- Calls to the handler after all the numbers have been used just return 'missing value'.
on makeRNG(low, high)
    script RNG
        property indexShift : missing value
        property ints : {}

        on nextInt()
            try
                set n to some number of my ints
                set item (n + indexShift) of my ints to missing value
            on error number -1728
                set n to missing value
            end try
            return n
        end nextInt
    end script

    if (low > high) then set {low, high} to {high, low}
    set RNG's indexShift to 1 - low
    repeat with n from low to high
        set end of RNG's ints to n
    end repeat

    return RNG
end makeRNG

on task()
    set low to 1
    set high to 20
    set generator to makeRNG(low, high)
    set output to {}
    repeat (high - low + 1) times
        set end of output to generator's nextInt()
    end repeat
    return output
end task

task()
