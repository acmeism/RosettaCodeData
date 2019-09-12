import qualified Data.Set as S

semordnilaps
  :: (Ord a, Foldable t)
  => t [a] -> [[a]]
semordnilaps =
  let f x (s, w)
        | S.member (reverse x) s = (s, x : w)
        | otherwise = (S.insert x s, w)
  in snd . foldr f (S.empty, [])

main :: IO ()
main = do
  s <- readFile "unixdict.txt"
  let l = semordnilaps (lines s)
  print $ length l
  mapM_ (print . ((,) <*> reverse)) $ take 5 (filter ((4 <) . length) l)
