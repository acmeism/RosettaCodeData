{-# OPTIONS_GHC -O2 -fllvm -Wno-incomplete-patterns #-}
{-# LANGUAGE DeriveFunctor #-}

import Data.Time.Clock.POSIX ( getPOSIXTime ) -- for timing

import Data.Int ( Int64 )
import Data.Bits ( Bits( shiftL, shiftR ) )

data Memo a = EmptyNode | Node a (Memo a) (Memo a)
  deriving Functor

memo :: Integral a => Memo p -> a -> p
memo (Node a l r) n
  | n == 0 = a
  | odd n = memo l (n `div` 2)
  | otherwise = memo r (n `div` 2 - 1)

nats :: Integral a => Memo a
nats = Node 0 ((+1).(*2) <$> nats) ((*2).(+1) <$> nats)

memoize :: Integral a => (a -> b) -> a -> b
memoize f = memo (f <$> nats)

memoize2 :: (Integral a, Integral b) => (a -> b -> c) -> a -> b -> c
memoize2 f = memoize (memoize . f)

memoList :: [b] -> Integer -> b
memoList = memo . mkList
  where
    mkList []     = EmptyNode -- never used; makes complete
    mkList (x:xs) = Node x (mkList l) (mkList r)
      where (l,r) = split xs
            split [] = ([],[])
            split [x] = ([x],[])
            split (x:y:xs) = let (l,r) = split xs in (x:l, y:r)

isqrt :: Integer -> Integer
isqrt n = go n 0 (q `shiftR` 2)
 where
   q = head $ dropWhile (< n) $ iterate (`shiftL` 2) 1
   go z r 0 = r
   go z r q = let t = z - r - q
              in if t >= 0
                 then go t (r `shiftR` 1 + q) (q `shiftR` 2)
                 else go z (r `shiftR` 1) (q `shiftR` 2)

primes :: [Integer]
primes = 2 : _Y ((3:) . gaps 5 . _U . map(\p-> [p*p, p*p+2*p..])) where
  _Y g = g (_Y g)  -- = g (g (g ( ... )))   non-sharing multistage fixpoint combinator
  gaps k s@(c:cs) | k < c     = k : gaps (k+2) s  -- ~= ([k,k+2..] \\ s)
                  | otherwise =     gaps (k+2) cs --   when null(s\\[k,k+2..])
  _U ((x:xs):t) = x : (merge xs . _U . pairs) t   -- tree-shaped folding big union
  pairs (xs:ys:t) = merge xs ys : pairs t
  merge xs@(x:xt) ys@(y:yt) | x < y     = x : merge xt ys
                            | y < x     = y : merge xs yt
                            | otherwise = x : merge xt yt

phi :: Integer -> Integer -> Integer
phi = memoize2 phiM
  where
    phiM x 0 = x
    phiM x a = phi x (a-1) - phi (x `div` p a) (a - 1)

    p = memoList (undefined : primes)

legendrePi :: Integer -> Integer
legendrePi n
  | n < 2 = 0
  | otherwise = phi n a + a - 1
    where a = legendrePi (floor (sqrt (fromInteger n)))

main :: IO ()
main = do
  strt <- getPOSIXTime
  mapM_ (\n -> putStrLn $ show n ++ "\t" ++ show (legendrePi (10^n))) [0..9]
  stop <- getPOSIXTime
  let elpsd = round $ 1e3 * (stop - strt) :: Int64
  putStrLn $ "This last took " ++ show elpsd ++ " milliseconds."
