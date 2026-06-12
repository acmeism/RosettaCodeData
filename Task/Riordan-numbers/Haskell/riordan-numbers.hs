--------------------- RIORDAN NUMBERS --------------------

riordans :: [Integer]
riordans =
  1 :
  0 :
  zipWith
    div
    ( zipWith
        (*)
        [1 ..]
        ( zipWith
            (+)
            ((2 *) <$> tail riordans)
            ((3 *) <$> riordans)
        )
    )
    [3 ..]

-------------------------- TESTS -------------------------
main :: IO ()
main =
  putStrLn "First 32 Riordan terms:"
    >> mapM_ print (take 32 riordans)
    >> mapM_
      ( \x ->
          putStrLn $
            concat
              [ "\nDigit count of ",
                show x,
                "th Riordan term:\n",
                (show . length . show)
                  (riordans !! pred x)
              ]
      )
      [1000, 10000]
