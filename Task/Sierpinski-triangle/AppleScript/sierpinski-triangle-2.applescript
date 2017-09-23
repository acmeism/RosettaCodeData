-- SIERPINSKI TRIANGLE BY XOR / RULE 90 --------------------------------------

-- sierpinskiTriangle :: Int -> String
on sierpinskiTriangle(intOrder)

    -- A Sierpinski triangle of order N
    -- is a Pascal triangle (of N^2 rows)
    -- mod 2

    -- pascalModTwo :: Int -> [[String]]
    script pascalModTwo
        on |λ|(intRows)

            -- addRow [[Int]] -> [[Int]]
            script addRow

                -- nextRow :: [Int] -> [Int]
                on nextRow(row)
                    -- The composition of AsciiBinary . mod two . add
                    -- is reduced here to a rule from
                    -- two parent characters above,
                    -- to the child character below.

                    -- Rule 90 also reduces to this XOR relationship
                    -- between left and right neighbours.

                    -- rule :: Character -> Character -> Character
                    script rule
                        on |λ|(a, b)
                            if a = b then
                                space
                            else
                                "*"
                            end if
                        end |λ|
                    end script

                    zipWith(rule, {" "} & row, row & {" "})
                end nextRow

                on |λ|(xs)
                    xs & {nextRow(item -1 of xs)}
                end |λ|
            end script

            foldr(addRow, {{"*"}}, enumFromTo(1, intRows - 1))
        end |λ|
    end script

    -- The centring foldr (fold right) below starts from the end of the list,
    -- (the base of the triangle) which has zero indent.

    -- Each preceding row has one more indent space than the row below it.

    script centred
        on |λ|(sofar, row)
            set strIndent to indent of sofar

            {triangle:strIndent & intercalate(space, row) & linefeed & ¬
                triangle of sofar, indent:strIndent & space}
        end |λ|
    end script

    triangle of foldr(centred, {triangle:"", indent:""}, ¬
        pascalModTwo's |λ|(intOrder ^ 2))

end sierpinskiTriangle


-- TEST ----------------------------------------------------------------------
on run

    set strTriangle to sierpinskiTriangle(4)

    set the clipboard to strTriangle
    strTriangle
end run


-- GENERIC FUNCTIONS ---------------------------------------------------------

-- enumFromTo :: Int -> Int -> [Int]
on enumFromTo(m, n)
    if m > n then
        set d to -1
    else
        set d to 1
    end if
    set lst to {}
    repeat with i from m to n by d
        set end of lst to i
    end repeat
    return lst
end enumFromTo

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to |λ|(v, item i of xs, i, xs)
        end repeat
        return v
    end tell
end foldr

-- intercalate :: Text -> [Text] -> Text
on intercalate(strText, lstText)
    set {dlm, my text item delimiters} to {my text item delimiters, strText}
    set strJoined to lstText as text
    set my text item delimiters to dlm
    return strJoined
end intercalate

-- min :: Ord a => a -> a -> a
on min(x, y)
    if y < x then
        y
    else
        x
    end if
end min

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property |λ| : f
        end script
    end if
end mReturn

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set lng to min(length of xs, length of ys)
    set lst to {}
    tell mReturn(f)
        repeat with i from 1 to lng
            set end of lst to |λ|(item i of xs, item i of ys)
        end repeat
        return lst
    end tell
end zipWith
