divisors :: (Integral a) => a -> [a]
divisors n = filter ((0 ==) . (n `mod`)) [1 .. (n `div` 2)]

main :: IO ()
main = do
  let range = [1 .. 20000 :: Int]
      divs = zip range $ map (sum . divisors) range
      pairs = [(n, m) | (n, nd) <- divs, (m, md) <- divs,
               n < m, nd == m, md == n]
  print pairs
