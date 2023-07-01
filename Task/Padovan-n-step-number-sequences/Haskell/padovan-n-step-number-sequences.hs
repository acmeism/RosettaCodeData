import Data.Bifunctor (second)
import Data.List (transpose, uncons, unfoldr)

------------------ PADOVAN N-STEP SERIES -----------------

padovans :: Int -> [Int]
padovans n
  | 0 > n = []
  | otherwise = unfoldr (recurrence n) $ take (succ n) xs
  where
    xs
      | 3 > n = repeat 1
      | otherwise = padovans $ pred n

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
    "Padovan N-step series:\n\n"
      <> spacedTable
        justifyRight
        ( fmap
            ( \n ->
                [show n <> " -> "]
                  <> fmap show (take 15 $ padovans n)
            )
            [2 .. 8]
        )

------------------------ FORMATTING ----------------------

spacedTable ::
  (Int -> Char -> String -> String) -> [[String]] -> String
spacedTable aligned rows =
  unlines $
    fmap
      (unwords . zipWith (`aligned` ' ') columnWidths)
      rows
  where
    columnWidths =
      fmap
        (maximum . fmap length)
        (transpose rows)

justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = drop . length <*> (replicate n c <>)
