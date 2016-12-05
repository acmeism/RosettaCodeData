on run
    {ethMult(17, 34), ethMult("Rhind", 9)}

    --> {578, "RhindRhindRhindRhindRhindRhindRhindRhind"}
end run


-- Int -> Int -> Int
-- or
-- Int -> String -> String
on ethMult(m, n)
    script fns
        property identity : missing value
        property plus : missing value

        on half(n) -- 1. half an integer (div 2)
            n div 2
        end half

        on double(n) -- 2. double (add to self)
            plus(n, n)
        end double

        on isEven(n) -- 3. is n even ? (mod 2 > 0)
            (n mod 2) > 0
        end isEven

        on chooseFns(c)
            if c is string then
                set identity of fns to ""
                set plus of fns to plusString of fns
            else
                set identity of fns to 0
                set plus of fns to plusInteger of fns
            end if
        end chooseFns

        on plusInteger(a, b)
            a + b
        end plusInteger

        on plusString(a, b)
            a & b
        end plusString
    end script

    chooseFns(class of m) of fns


    -- MAIN PROCESS OF CALCULATION

    set o to identity of fns
    if n < 1 then return o

    repeat while (n > 1)
        if isEven(n) of fns then -- 3. is n even ? (mod 2 > 0)
            set o to plus(o, m) of fns
        end if
        set n to half(n) of fns -- 1. half an integer (div 2)
        set m to double(m) of fns -- 2. double  (add to self)
    end repeat
    return plus(o, m) of fns
end ethMult
