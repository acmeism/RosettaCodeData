divisors :: (Integral a) => a -> [a]
divisors n = filter ((0 ==) . (n `mod`)) [1 .. (n `div` 2)]

data Class
  = Terminating
  | Perfect
  | Amicable
  | Sociable
  | Aspiring
  | Cyclic
  | Nonterminating
  deriving (Show)

aliquot :: (Integral a) => a -> [a]
aliquot 0 = [0]
aliquot n = n : (aliquot $ sum $ divisors n)

classify :: (Num a, Eq a) => [a] -> Class
classify []             = Nonterminating
classify [0]            = Terminating
classify [_]            = Nonterminating
classify [a,b]
  | a == b              = Perfect
  | b == 0              = Terminating
  | otherwise           = Nonterminating
classify x@(a:b:c:_)
  | a == b              = Perfect
  | a == c              = Amicable
  | a `elem` (drop 1 x) = Sociable
  | otherwise           =
    case classify (drop 1 x) of
      Perfect  -> Aspiring
      Amicable -> Cyclic
      Sociable -> Cyclic
      d        -> d

main :: IO ()
main = do
  let cls n = let ali = take 16 $ aliquot n in (classify ali, ali)
  mapM_ (print . cls) $ [1..10] ++
    [11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488]
