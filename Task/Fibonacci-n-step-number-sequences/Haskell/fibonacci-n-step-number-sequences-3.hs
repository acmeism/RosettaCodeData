import Data.Bifunctor (second)
import Data.List (transpose, uncons, unfoldr)

------------ FIBONACCI N-STEP NUMBER SEQUENCES -----------

a000032 :: [Int]
a000032 = unfoldr (recurrence 2) [2, 1]

nStepFibonacci :: Int -> [Int]
nStepFibonacci =
  unfoldr <$> recurrence
    <*> (($ 1 : fmap (2 ^) [0 ..]) . take)

recurrence :: Int -> [Int] -> Maybe (Int, [Int])
recurrence n =
  ( fmap
      . second
      . flip (<>)
      . pure
      . sum
      . take n
  )
    <*> uncons

--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    "Recurrence relation sequences:\n\n"
      <> spacedTable
        justifyRight
        ( ("lucas:" : fmap show (take 15 a000032)) :
          zipWith
            ( \k n ->
                (k <> "nacci:") :
                fmap
                  show
                  (take 15 $ nStepFibonacci n)
            )
            (words "fibo tribo tetra penta hexa hepta octo nona deca")
            [2 ..]
        )

------------------------ FORMATTING ----------------------
spacedTable ::
  (Int -> Char -> String -> String) -> [[String]] -> String
spacedTable aligned rows =
  let columnWidths =
        fmap
          (maximum . fmap length)
          (transpose rows)
   in unlines $
        fmap
          (unwords . zipWith (`aligned` ' ') columnWidths)
          rows

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
