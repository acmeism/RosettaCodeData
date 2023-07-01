{-# LANGUAGE TemplateHaskell #-}
import Control.Lens        (makeLenses, over, (^.), to, view)
import Data.Numbers.Primes (isPrime, primes)
import Text.Printf         (printf)

data Group a = Group { _count :: Int, _results :: [a] } deriving (Show)
makeLenses ''Group

type Groups = ( Group (Int, Int)
              , Group (Int, Int, Int)
              , Group (Int, Int, Int, Int)
              , Group (Int, Int, Int, Int, Int)
              , Group Int )

initialGroups :: Groups
initialGroups = let newGroup = Group 0 []
                in (newGroup, newGroup, newGroup, newGroup, newGroup)

collect :: Groups -> Int -> Groups
collect r@(pr, tt, qd, qn, un) n
  | isPrime n4 && isPrime n3 && isPrime n2 && isPrime n1 = (addPair pr, addTriplet tt, addQuad qd, addQuin qn, un)
  | isPrime n3 && isPrime n2 && isPrime n1               = (addPair pr, addTriplet tt, addQuad qd, qn, un)
  | isPrime n2 && isPrime n1                             = (addPair pr, addTriplet tt, qd, qn, un)
  | isPrime n1                                           = (addPair pr, tt, qd, qn, un)
  | not (isPrime (n+6)) && not (isPrime n1)              = (pr, tt, qd, qn, addUnSexy un)
  | otherwise                                            = r
  where
    n1 = n-6
    n2 = n-12
    n3 = n-18
    n4 = n-24

    addPair    = over count succ . over results (take 5  . (:) (n1, n))
    addTriplet = over count succ . over results (take 5  . (:) (n2, n1, n))
    addQuad    = over count succ . over results (take 5  . (:) (n3, n2, n1, n))
    addQuin    = over count succ . over results (take 1  . (:) (n4, n3, n2, n1, n))
    addUnSexy  = over count succ . over results (take 10 . (:) n)

main :: IO ()
main = do
  let (pr, tt, qd, qn, un) = collectGroups primes
  printf "Number of sexy prime pairs: %d\n  Last 5 : %s\n\n" (pr ^. count) (pr ^. results . to display)
  printf "Number of sexy prime triplets: %d\n  Last 5 : %s\n\n" (tt ^. count) (tt ^. results . to display)
  printf "Number of sexy prime quadruplets: %d\n  Last 5 : %s\n\n" (qd ^. count) (qd ^. results . to display)
  printf "Number of sexy prime quintuplets: %d\n  Last 1 : %s\n\n" (qn ^. count) (qn ^. results . to display)
  printf "Number of unsexy primes: %d\n  Last 10: %s\n\n" (un ^. count) (un ^. results . to display)
  where
    collectGroups = foldl collect initialGroups . takeWhile (< 1000035)
    display :: Show a => [a] -> String
    display = show . reverse
