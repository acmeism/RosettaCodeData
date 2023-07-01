-- This handler must be declared somewhere above the relevant property declaration
-- so that the compiler knows about it when compiling the property.
on factorial(n)
    set f to 1
    repeat with i from 2 to n
        set f to f * i
    end repeat

    return f
end factorial

property compiledValue : factorial(10)
-- Or of course simply:
-- property compiledValue : 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10

on run
    return compiledValue
end run
