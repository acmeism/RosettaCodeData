-------------------- DEPARTMENT NUMBERS ------------------

options :: Int -> Int -> Int -> [(Int, Int, Int)]
options lo hi total =
  ( \ds ->
      filter even ds
        >>= \x ->
          filter (/= x) ds
            >>= \y ->
              [total - (x + y)]
                >>= \z ->
                  [ (x, y, z)
                    | y /= z && lo <= z && z <= hi
                  ]
  )
    [lo .. hi]

--------------------------- TEST -------------------------
main :: IO ()
main =
  let xs = options 1 7 12
   in putStrLn "(Police, Sanitation, Fire)\n"
        >> mapM_ print xs
        >> mapM_
          putStrLn
          [ "\nNumber of options: ",
            show (length xs)
          ]
