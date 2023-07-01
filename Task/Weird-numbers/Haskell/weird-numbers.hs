weirds :: [Int]
weirds = filter abundantNotSemiperfect [1 ..]

abundantNotSemiperfect :: Int -> Bool
abundantNotSemiperfect n =
  let ds = descProperDivisors n
      d = sum ds - n
  in 0 < d && not (hasSum d ds)

hasSum :: Int -> [Int] -> Bool
hasSum _ [] = False
hasSum n (x:xs)
  | n < x = hasSum n xs
  | otherwise = (n == x) || hasSum (n - x) xs || hasSum n xs

descProperDivisors
  :: Integral a
  => a -> [a]
descProperDivisors n =
  let root = (floor . sqrt) (fromIntegral n :: Double)
      lows = filter ((0 ==) . rem n) [root,root - 1 .. 1]
      factors
        | n == root ^ 2 = tail lows
        | otherwise = lows
  in tail $ reverse (quot n <$> lows) ++ factors

main :: IO ()
main =
  (putStrLn . unlines) $
  zipWith (\i x -> show i ++ (" -> " ++ show x)) [1 ..] (take 25 weirds)
