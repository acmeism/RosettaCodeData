sierpinski :: Int -> [String]
sierpinski n =
  foldr
    ( \i xs ->
        let s = replicate (2 ^ i) ' '
         in fmap ((s <>) . (<> s)) xs
              <> fmap
                ( (<>)
                    <*> (' ' :)
                )
                xs
    )
    ["*"]
    [n - 1, n - 2 .. 0]

main :: IO ()
main = (putStrLn . unlines . sierpinski) 4
