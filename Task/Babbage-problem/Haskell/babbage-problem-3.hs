import Data.List (intercalate)


--------------------- BABBAGE PROBLEM --------------------

babbagePairs :: [[Integer]]
babbagePairs =
  [0, 1000000 ..]
    >>= \x ->                     -- Drawing from a succession of N * 10^6
      let y = (x + 269696)        -- The next number ending in 269696,
          r = root y              -- its square root,
          i = floor r             -- and the integer part of that root.
       in [ [i, y]                -- Root and square harvested together,
            | r == fromIntegral i -- only if that root is an integer.
          ]

root :: Integer -> Double
root = sqrt. fromIntegral

--------------------------- TEST -------------------------
main :: IO ()
main = mapM_ (putStrLn . arrowed) $ take 10 babbagePairs

arrowed :: [Integer] -> String
arrowed = intercalate " ^ 2 -> " . fmap show
