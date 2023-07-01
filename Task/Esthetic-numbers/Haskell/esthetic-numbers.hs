import Data.List (unfoldr, genericIndex)
import Control.Monad (replicateM, foldM, mzero)

-- a predicate for esthetic numbers
isEsthetic b = all ((== 1) . abs) . differences . toBase b
  where
    differences lst = zipWith (-) lst (tail lst)

-- Monadic solution, inefficient for small bases.
esthetics_m b =
  do differences <- (\n -> replicateM n [-1, 1]) <$> [0..]
     firstDigit <- [1..b-1]
     differences >>= fromBase b <$> scanl (+) firstDigit

-- Much more efficient iterative solution (translation from Python).
-- Uses simple list as an ersatz queue.
esthetics b = tail $ fst <$> iterate step (undefined, q)
  where
    q = [(d, d) | d <- [1..b-1]]
    step (_, queue) =
      let (num, lsd) = head queue
          new_lsds = [d | d <- [lsd-1, lsd+1], d < b, d >= 0]
      in (num, tail queue ++ [(num*b + d, d) | d <- new_lsds])

-- representation of numbers as digits
fromBase b = foldM f 0
  where f r d | d < 0 || d >= b = mzero
              | otherwise = pure (r*b + d)

toBase b = reverse . unfoldr f
  where
    f 0 = Nothing
    f n = let (q, r) = divMod n b in Just (r, q)

showInBase b = foldMap (pure . digit) . toBase b
  where digit = genericIndex (['0'..'9'] <> ['a'..'z'])
