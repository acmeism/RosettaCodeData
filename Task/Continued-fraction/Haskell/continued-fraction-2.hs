import Data.Ratio ((%), denominator, numerator)
import Data.Bool (bool)

-- ignoring the task-given pi sequence: sucky convergence
-- pie = zip (3:repeat 6) (map (^2) [1,3..])
pie = zip (0 : [1,3 ..]) (4 : map (^ 2) [1 ..])

sqrt2 = zip (1 : repeat 2) (repeat 1)

napier = zip (2 : [1 ..]) (1 : [1 ..])

-- truncate after n terms
cf2rat n = foldr (\(a, b) f -> (a % 1) + ((b % 1) / f)) (1 % 1) . take n

-- truncate after error is at most 1/p
cf2rat_p p s = f $ map ((\i -> (cf2rat i s, cf2rat (1 + i) s)) . (2 ^)) [0 ..]
  where
    f ((x, y):ys)
      | abs (x - y) < (1 / fromIntegral p) = x
      | otherwise = f ys

-- returns a decimal string of n digits after the dot; all digits should
-- be correct (doesn't mean it's the best approximation! the decimal
-- string is simply truncated to given digits: pi=3.141 instead of 3.142)
cf2dec n = ratstr n . cf2rat_p (10 ^ n)
  where
    ratstr l a = show t ++ '.' : fracstr l n d
      where
        d = denominator a
        (t, n) = quotRem (numerator a) d
        fracstr 0 _ _ = []
        fracstr l n d = show t ++ fracstr (l - 1) n1 d
          where
            (t, n1) = quotRem (10 * n) d

main :: IO ()
main = mapM_ putStrLn [cf2dec 200 sqrt2, cf2dec 200 napier, cf2dec 200 pie]
