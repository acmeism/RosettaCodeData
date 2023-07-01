import Control.Monad (forM_)
import Data.Bool (bool)
import Data.List.NonEmpty (NonEmpty, fromList, toList, unfoldr)
import Text.Printf (printf)

-- The infinite Calkin-Wilf sequence, a(n), starting with a(1) = 1.
calkinWilfs :: [Rational]
calkinWilfs = iterate (recip . succ . ((-) =<< (2 *) . fromIntegral . floor)) 1

-- The index into the Calkin-Wilf sequence of a given rational number, starting
-- with 1 at index 1.
calkinWilfIdx :: Rational -> Integer
calkinWilfIdx = rld . cfo

-- A continued fraction representation of a given rational number, guaranteed
-- to have an odd length.
cfo :: Rational -> NonEmpty Int
cfo = oddLen . cf

-- The canonical (i.e. shortest) continued fraction representation of a given
-- rational number.
cf :: Rational -> NonEmpty Int
cf = unfoldr step
  where
    step r =
      case properFraction r of
        (n, 1) -> (succ n, Nothing)
        (n, 0) -> (n, Nothing)
        (n, f) -> (n, Just (recip f))

-- Ensure a continued fraction has an odd length.
oddLen :: NonEmpty Int -> NonEmpty Int
oddLen = fromList . go . toList
  where
    go [x, y] = [x, pred y, 1]
    go (x:y:zs) = x : y : go zs
    go xs = xs

-- Run-length decode a continued fraction.
rld :: NonEmpty Int -> Integer
rld = snd . foldr step (True, 0)
  where
    step i (b, n) =
      let p = 2 ^ i
      in (not b, n * p + bool 0 (pred p) b)

main :: IO ()
main = do
  forM_ (take 20 $ zip [1 :: Int ..] calkinWilfs) $
    \(i, r) -> printf "%2d  %s\n" i (show r)
  let r = 83116 / 51639
  printf
    "\n%s is at index %d of the Calkin-Wilf sequence.\n"
    (show r)
    (calkinWilfIdx r)
