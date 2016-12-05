on run
    -- isMatch :: Int -> Bool
    script isMatch
        on lambda(x)
            tell x to its guess = its secret
        end lambda
    end script

    -- challenge :: () -> {secret: Int, guess: Int}
    script challenge
        on response()
            set v to (text returned of (display dialog ¬
                "Guess the number in range 1-10" default answer ¬
                "" buttons {"Esc", "Check"} default button ¬
                "Check" cancel button "Esc"))

            if isInteger(v) then
                v as integer
            else
                -1
            end if
        end response

        on lambda(rec)
            {secret:(random number from 1 to 10), guess:response() ¬
                of challenge, attempts:(attempts of rec) + 1}
        end lambda
    end script


    -- MAIN LOOP
    set rec to |until|(isMatch, challenge, {secret:-1, guess:0, attempts:0})

    display dialog (((guess of rec) as string) & ":    Well guessed ! " & ¬
        linefeed & linefeed & "Attempts: " & (attempts of rec))
end run



-- GENERIC LBRARY FUNCTIONS

-- until :: (a -> Bool) -> (a -> a) -> a -> a
on |until|(p, f, x)
    set mp to mReturn(p)
    set mf to mReturn(f)

    script
        property p : mp's lambda
        property f : mf's lambda

        on lambda(v)
            repeat until p(v)
                set v to f(v)
            end repeat
            return v
        end lambda
    end script

    result's lambda(x)
end |until|


-- isInteger :: a -> Bool
on isInteger(e)
    try
        set n to e as integer
    on error
        return false
    end try
    true
end isInteger

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
