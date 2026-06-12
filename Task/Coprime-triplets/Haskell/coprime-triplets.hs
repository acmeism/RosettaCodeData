import Data.List (find, transpose, unfoldr)
import Data.List.Split (chunksOf)
import qualified Data.Set as S

--------------------- COPRIME TRIPLES --------------------

coprimeTriples :: Integral a => [a]
coprimeTriples =
  [1, 2] <> unfoldr go (S.fromList [1, 2], (1, 2))
  where
    go (seen, (a, b)) =
      Just
        (c, (S.insert c seen, (b, c)))
      where
        Just c =
          find
            ( ((&&) . flip S.notMember seen)
                <*> ((&&) . coprime a <*> coprime b)
            )
            [3 ..]

coprime :: Integral a => a -> a -> Bool
coprime a b = 1 == gcd a b


--------------------------- TEST -------------------------
main :: IO ()
main =
  let xs = takeWhile (< 50) coprimeTriples
   in putStrLn (show (length xs) <> " terms below 50:\n")
        >> putStrLn
          ( spacedTable
              justifyRight
              (chunksOf 10 (show <$> xs))
          )


-------------------------- FORMAT ------------------------
spacedTable ::
  (Int -> Char -> String -> String) -> [[String]] -> String
spacedTable aligned rows =
  unlines $
    unwords
      . zipWith
        (`aligned` ' ')
        (maximum . fmap length <$> transpose rows)
      <$> rows

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
