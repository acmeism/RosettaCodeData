import Data.List (unfoldr)
import Debug.Trace (trace)

egyptianQuotRem :: Int -> Int -> (Int, Int)
egyptianQuotRem m n =
  let rows =
        unfoldr
          (\(i, x) ->
              if x > m
                then Nothing
                else Just ((i, x), (i + i, x + x)))
          (1, n)
  in trace
       (unlines
          [ "Number pair unfolded to series of doubling rows:"
          , show rows
          , "\nRows refolded down to (quot, rem):"
          , show (0, m)
          ])
       foldr
       (\(i, x) (q, r) ->
           if x < r
             then trace
                    (concat
                       ["(+", show i, ", -", show x, ") -> rem ", show (r - x)])
                    (q + i, r - x)
             else (q, r))
       (0, m)
       rows

main :: IO ()
main = print $ egyptianQuotRem 580 34
