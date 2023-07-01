word = "knights"

main = do
    -- You can drop the first item
    -- using `tail`
    putStrLn (tail word)

    -- The `init` function will drop
    -- the last item
    putStrLn (init word)

    -- We can combine these two to drop
    -- the last and the first characters
    putStrLn (middle word)

-- You can combine functions using `.`,
-- which is pronounced "compose" or "of"
middle = init . tail
