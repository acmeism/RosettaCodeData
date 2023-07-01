import           Data.List.Split          (chunksOf)
import qualified Data.MemoCombinators  as Memo
import           Math.NumberTheory.Primes (unPrime, factorise)
import           Text.Printf              (printf)

moebius :: Integer -> Int
moebius = product . fmap m . factorise
  where
    m (p, e)
      | unPrime p == 0 = 0
      | e == 1 = -1
      | otherwise = 0

mertens :: Integer -> Int
mertens = Memo.integral (\n -> sum $ fmap moebius [1..n])

countZeros :: [Integer] -> Int
countZeros = length . filter ((==0) . mertens)

crossesZero :: [Integer] -> Int
crossesZero = length . go . fmap mertens
  where
    go (x:y:xs)
      | y == 0 && x /= 0 = y : go (y:xs)
      | otherwise        = go (y:xs)
    go _ = []

main :: IO ()
main = do
  printf "The first 99 terms for M(1..99):\n\n   "
  mapM_ (printf "%3d" . mertens) [1..9] >> printf "\n"
  mapM_ (\row -> mapM_ (printf "%3d" . mertens) row >> printf "\n") $ chunksOf 10 [10..99]
  printf "\nM(n) is zero %d times for 1 <= n <= 1000.\n" $ countZeros [1..1000]
  printf "M(n) crosses zero %d times for 1 <= n <= 1000.\n" $ crossesZero [1..1000]
