import Debug.Trace (trace)

testToDepth :: Int -> Int -> Int
testToDepth max n
  | n >= max = max
  | otherwise = trace (show n) testToDepth max (succ n)

main :: IO ()
main = print $ testToDepth 1000000 1
