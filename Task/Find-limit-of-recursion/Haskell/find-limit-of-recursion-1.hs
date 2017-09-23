import Debug.Trace (trace)

recurse :: Int -> Int
recurse n = trace (show n) recurse (succ n)

main :: IO ()
main = print $ recurse 1
