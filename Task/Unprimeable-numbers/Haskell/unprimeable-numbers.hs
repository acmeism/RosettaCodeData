import Control.Lens ((.~), ix, (&))
import Data.Numbers.Primes (isPrime)
import Data.List (find, intercalate)
import Data.Char (intToDigit)
import Data.Maybe (mapMaybe)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

isUnprimable :: Int -> Bool
isUnprimable = all (not . isPrime) . swapdigits

swapdigits :: Int -> [Int]
swapdigits n = map read $ go $ pred $ length digits
 where
  digits = show n
  go (-1) = []
  go n''  = map (\x -> digits & (ix n'') .~ intToDigit x) [0..9] <> go (pred n'')

unPrimeable :: [Int]
unPrimeable = filter isUnprimable [1..]

main :: IO ()
main = do
  printf "First 35 unprimeable numbers:\n%s\n\n" $ show $ take 35 unPrimeable
  printf "600th unprimeable number: %d\n\n" $ unPrimeable !! 599
  mapM_ (uncurry (printf "Lowest unprimeable number ending with %d: %10s\n")) $ mapMaybe lowest [0..9]
 where
  thousands = reverse . intercalate "," . chunksOf 3 . reverse
  lowest n = do
    x <- find (\x -> x `mod` 10 == n) unPrimeable
    pure (n, thousands $ show x)
