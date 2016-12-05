-- BRIEF

on run

    intercalate("\n\n", ¬
        map(recitation, range(99, 0)))

end run


-- DECLARATIVE

script recitation
    property coordinates : " on the wall"
    property redistribution : "Take one down, pass it around"
    property resort : "Better go to the store to buy some more"
    property unit : "bottle"

    -- Int -> String
    on lambda(n)
        if n > 0 then
            set reserve to resourceDescriptor(n)
            set residue to resourceDescriptor(n - 1)

            intercalate(linefeed, ¬
                {reserve & coordinates, reserve, ¬
                    redistribution, residue & coordinates})
        else
            resort
        end if
    end lambda

    -- resourceDescriptor :: Int -> String
    on resourceDescriptor(n)
        if n ≠ 1 then
            (n as string) & space & unit & "s"
        else
            "1 " & unit
        end if
    end resourceDescriptor
end script



-- DYSFUNCTIONAL

-- map :: (a -> b) -> [a] -> [b]
on map(f, xs)
    tell mReturn(f)
        set lng to length of xs
        set lst to {}
        repeat with i from 1 to lng
            set end of lst to lambda(item i of xs, i, xs)
        end repeat
        return lst
    end tell
end map

-- range :: Int -> Int -> [Int]
on range(m, n)
    if n < m then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end range

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

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
