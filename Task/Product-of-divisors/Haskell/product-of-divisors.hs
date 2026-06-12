import Data.List.Split (chunksOf)

------------------------- DIVISORS -----------------------

divisors :: Integral a => a -> [a]
divisors n =
  ((<>) <*> (rest . reverse . fmap (quot n))) $
    filter ((0 ==) . rem n) [1 .. root]
  where
    root = (floor . sqrt . fromIntegral) n
    rest
      | n == root * root = tail
      | otherwise = id

-------------- SUMS AND PRODUCTS OF DIVISORS -------------

main :: IO ()
main =
  mapM_
    putStrLn
    [ "Sums of divisors of [1..100]:",
      test sum,
      "Products of divisors of [1..100]:",
      test product
    ]

test :: (Show a, Integral a) => ([a] -> a) -> String
test f =
  let xs = show . f . divisors <$> [1 .. 100]
      w = maximum $ length <$> xs
   in unlines $
        unwords
          <$> fmap
            (fmap (justifyRight w ' '))
            (chunksOf 5 xs)

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
