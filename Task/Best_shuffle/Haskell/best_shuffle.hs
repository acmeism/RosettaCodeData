import Data.Function (on)
import Data.List
import Data.Maybe
import Data.Array
import Text.Printf

main = mapM_ f examples
  where examples = ["abracadabra", "seesaw", "elk", "grrrrrr", "up", "a"]
        f s = printf "%s, %s, (%d)\n" s s' $ score s s'
          where s' = bestShuffle s

score :: Eq a => [a] -> [a] -> Int
score old new = length $ filter id $ zipWith (==) old new

bestShuffle :: (Ord a, Eq a) => [a] -> [a]
bestShuffle s = elems $ array bs $ f positions letters
  where positions =
            concat $ sortBy (compare `on` length) $
            map (map fst) $ groupBy ((==) `on` snd) $
            sortBy (compare `on` snd) $ zip [0..] s
        letters = map (orig !) positions

        f [] [] = []
        f (p : ps) ls = (p, ls !! i) : f ps (removeAt i ls)
          where i = fromMaybe 0 $ findIndex (/= o) ls
                o = orig ! p

        orig = listArray bs s
        bs = (0, length s - 1)

removeAt :: Int -> [a] -> [a]
removeAt 0 (x : xs) = xs
removeAt i (x : xs) = x : removeAt (i - 1) xs
