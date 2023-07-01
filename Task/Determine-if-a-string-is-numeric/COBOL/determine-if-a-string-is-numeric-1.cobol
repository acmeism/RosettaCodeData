        program-id. is-numeric.
        procedure division.
        display function test-numval-f("abc") end-display
        display function test-numval-f("-123.01E+3") end-display
        if function test-numval-f("+123.123") equal zero then
            display "is numeric" end-display
        else
            display "failed numval-f test" end-display
        end-if
        goback.
