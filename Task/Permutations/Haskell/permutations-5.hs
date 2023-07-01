import Data.Bifunctor (second)

permutations :: [a] -> [[a]]
permutations =
  let ins x xs n = uncurry (<>) $ second (x :) (splitAt n xs)
  in foldr
    ( \x a ->
        a >>= (fmap . ins x)
          <*> (enumFromTo 0 . length)
    )
    [[]]

main :: IO ()
main = print $ permutations [1, 2, 3]
