import Debug.Trace (trace)
import Data.Function (fix)

recurse :: Int -> Int
recurse = fix ((<*> succ) . flip (trace . show))

main :: IO ()
main = print $ recurse 1
