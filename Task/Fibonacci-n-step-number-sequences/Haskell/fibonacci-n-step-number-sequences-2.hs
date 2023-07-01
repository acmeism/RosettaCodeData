------------ FIBONACCI N-STEP NUMBER SEQUENCES -----------

nStepFibonacci :: Int -> [Int]
nStepFibonacci =
  nFibs
    . (1 :)
    . fmap (2 ^)
    . enumFromTo 0
    . subtract 2

nFibs :: [Int] -> [Int]
nFibs ys@(z : zs) = z : nFibs (zs <> [sum ys])

--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn $
    justifyLeft 12 ' ' "Lucas" <> "-> "
      <> show (take 15 (nFibs [2, 1]))
  (putStrLn . unlines)
    ( zipWith
        ( \s n ->
            justifyLeft 12 ' ' (s <> "naccci")
              <> ("-> " <> show (take 15 (nStepFibonacci n)))
        )
        ( words
            "fibo tribo tetra penta hexa hepta octo nona deca"
        )
        [2 ..]
    )

justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s <> replicate n c)
