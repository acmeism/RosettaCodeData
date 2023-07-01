main = do
    s <- getLine
    print (s, s)

-- The above is equivalent to:

main = getLine >>= \s -> print (s, s)
