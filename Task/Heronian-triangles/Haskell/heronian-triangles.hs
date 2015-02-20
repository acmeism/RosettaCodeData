import qualified Data.List as L
import Data.Maybe
import Data.Ord
import Text.Printf

-- Determine if a number n is a perfect square and return its square root if so.
-- This is used instead of sqrt to avoid fixed sized floating point numbers.
perfectSqrt :: Integral a => a -> Maybe a
perfectSqrt n
  | n == 1    = Just 1
  | n < 4     = Nothing
  | otherwise =
  let search low high =
        let guess = (low + high) `div` 2
            square = guess ^ 2
            next
              | square == n  = Just guess
              | low == guess = Nothing
              | square < n   = search guess high
              | otherwise    = search low guess
        in next
  in search 0 n

-- Determine the area of a Heronian triangle if it is one.
heronTri :: Integral a => a -> a -> a -> Maybe a
heronTri a b c =
  let -- Rewrite Heron's formula to factor out the term 16 under the root.
    areaSq16    = (a + b + c) * (b + c - a) * (a + c - b) * (a + b - c)
    (areaSq, r) = areaSq16 `divMod` 16
  in if r == 0
     then perfectSqrt areaSq
     else Nothing

isPrimitive :: Integral a => a -> a -> a -> a
isPrimitive a b c = gcd a (gcd b c)

third (_, _, x, _, _) = x
fourth (_, _, _, x, _) = x
fifth (_, _, _, _, x) = x

orders :: Ord b => [(a -> b)] -> a -> a -> Ordering
orders [f] a b = comparing f a b
orders (f:fx) a b =
  case comparing f a b of
    EQ -> orders fx a b
    n  -> n

main :: IO ()
main = do
  let range = [1 .. 200]
      tris :: [(Integer, Integer, Integer, Integer, Integer)]
      tris = L.sortBy (orders [fifth, fourth, third])
             $ map (\(a, b, c, d, e) -> (a, b, c, d, fromJust e))
             $ filter (isJust . fifth)
             [(a, b, c, a + b + c, heronTri a b c)
             | a <- range, b <- range, c <- range
             , a <= b, b <= c, isPrimitive a b c == 1]
      printTri (a, b, c, d, e) = printf "%3d %3d %3d %9d %4d\n" a b c d e
  printf "Heronian triangles found: %d\n\n" $ length tris
  putStrLn "   Sides    Perimeter Area"
  mapM_ printTri $ take 10 tris
  putStrLn ""
  mapM_ printTri $ filter ((== 210) . fifth) tris
