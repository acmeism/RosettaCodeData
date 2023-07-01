import Data.List
import Data.Numbers.Primes (primeFactors)

negateVar p = zipWith (*) p $ reverse $ take (length p) $ cycle [1,-1]

lift p 1 = p
lift p n = intercalate (replicate (n-1) 0) (pure <$> p)

shortDiv :: [Integer] -> [Integer] -> [Integer]
shortDiv p1 (_:p2) = unfoldr go (length p1 - length p2, p1)
  where
    go (0, _) = Nothing
    go (i, h:t) = Just (h, (i-1, zipWith (+) (map (h *) ker) t))
    ker = negate <$> p2 ++ repeat 0

primePowerFactors = sortOn fst . map (\x-> (head x, length x)) . group . primeFactors

-- simple memoization
cyclotomics :: [[Integer]]
cyclotomics = cyclotomic <$> [0..]

cyclotomic :: Int -> [Integer]
cyclotomic 0 = [0]
cyclotomic 1 = [1, -1]
cyclotomic 2 = [1, 1]
cyclotomic n = case primePowerFactors n of
  -- for n = 2^k
  [(2,h)]       -> 1 : replicate (2 ^ (h-1) - 1) 0 ++ [1]
  -- for prime n
  [(p,1)]       -> replicate n 1
  -- for power of prime n
  [(p,m)]       -> lift (cyclotomics !! p) (p^(m-1))
  -- for n = 2*p and prime p
  [(2,1),(p,1)] -> take (n `div` 2) $ cycle [1,-1]
  -- for n = 2*m and odd m
  (2,1):_       -> negateVar $ cyclotomics !! (n `div` 2)
  -- general case
  (p, m):ps     -> let cm = cyclotomics !! (n `div` (p ^ m))
                   in lift (lift cm p `shortDiv` cm) (p^(m-1))
