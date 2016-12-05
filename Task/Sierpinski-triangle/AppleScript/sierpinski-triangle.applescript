-- sierpinskiTriangle :: Int -> String
on sierpinskiTriangle(intOrder)

    -- A Sierpinski triangle of order N
    -- is a Pascal triangle (of N^2 rows)
    -- mod 2

    -- pascalModTwo :: Int -> [[String]]
    script pascalModTwo
        on lambda(intRows)

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
                        on lambda(a, b)
                            cond(a = b, space, "*")
                        end lambda
                    end script

                    zipWith(rule, {" "} & row, row & {" "})
                end nextRow

                on lambda(xs)
                    xs & {nextRow(item -1 of xs)}
                end lambda
            end script

            foldr(addRow, {{"*"}}, range(1, intRows - 1))
        end lambda
    end script

    -- The centring foldr (fold right) below starts from the end of the list,
    -- (the base of the triangle) which has zero indent.

    -- Each preceding row has one more indent space than the row below it.

    script centred
        on lambda(sofar, row)
            set strIndent to indent of sofar

            {triangle:strIndent & intercalate(space, row) & linefeed & ¬
                triangle of sofar, indent:strIndent & space}
        end lambda
    end script

    triangle of foldr(centred, {triangle:"", indent:""}, ¬
        pascalModTwo's lambda(intOrder ^ 2))

end sierpinskiTriangle


-- TEST
on run

    set strTriangle to sierpinskiTriangle(4)

    set the clipboard to strTriangle

    strTriangle

end run


-- GENERIC LIBRARY FUNCTIONS

-- foldr :: (a -> b -> a) -> a -> [b] -> a
on foldr(f, startValue, xs)
    tell mReturn(f)
        set v to startValue
        set lng to length of xs
        repeat with i from lng to 1 by -1
            set v to lambda(v, item i of xs, i, xs)
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

-- zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
on zipWith(f, xs, ys)
    set nx to length of xs
    set ny to length of ys
    if nx < 1 or ny < 1 then
        {}
    else
        set lng to cond(nx < ny, nx, ny)
        set lst to {}
        tell mReturn(f)
            repeat with i from 1 to lng
                set end of lst to lambda(item i of xs, item i of ys)
            end repeat
            return lst
        end tell
    end if
end zipWith

-- cond :: Bool -> (a -> b) -> (a -> b) -> (a -> b)
on cond(bool, f, g)
    if bool then
        f
    else
        g
    end if
end cond
