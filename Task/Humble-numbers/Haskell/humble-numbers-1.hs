import Data.Set (deleteFindMin, fromList, union)
import Data.List.Split (chunksOf)
import Data.List (group)
import Data.Bool (bool)

--------------------- HUMBLE NUMBERS ----------------------
humbles :: [Integer]
humbles = go $ fromList [1]
  where
    go sofar = x : go (union pruned $ fromList ((x *) <$> [2, 3, 5, 7]))
      where
        (x, pruned) = deleteFindMin sofar

-- humbles = filter (all (< 8) . primeFactors) [1 ..]
-------------------------- TEST ---------------------------
main :: IO ()
main = do
  putStrLn "First 50 Humble numbers:"
  mapM_ (putStrLn . concat) $
    chunksOf 10 $ justifyRight 4 ' ' . show <$> take 50 humbles
  putStrLn "\nCount of humble numbers for each digit length 1-25:"
  mapM_ print $
    take 25 $ ((,) . head <*> length) <$> group (length . show <$> humbles)

------------------------- DISPLAY -------------------------
justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c ++)
