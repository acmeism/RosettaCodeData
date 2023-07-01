quibble ws = "{" ++ quibbles ws ++ "}"
  where quibbles [] = ""
        quibbles [a] = a
        quibbles [a,b] = a ++ " and " ++ b
        quibbles (a:bs) = a ++ ", " ++ quibbles bs

main = mapM_ (putStrLn . quibble) $
  [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]] ++
  (map words ["One two three four", "Me myself I", "Jack Jill", "Loner" ])
