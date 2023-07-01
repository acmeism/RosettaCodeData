local array, stopVal, row
set array to {}
set stopVal to 20
repeat 10 times
    set row to {}
    repeat 10 times
        set end of row to (random number from 1 to stopVal)
    end repeat
    set end of array to row
end repeat
loopDemo(array, stopVal) -- Any of the handlers above.
