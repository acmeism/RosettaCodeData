{-# LANGUAGE BangPatterns        #-}
{-# LANGUAGE DeriveFunctor       #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Rosetta.BlumInteger
    ( Stream (..)
    , Stats (..)
    , toList
    , blumIntegers
    , countLastDigits
    ) where

import           GHC.Natural              (Natural)
import           Math.NumberTheory.Primes (Prime (..), nextPrime)

-- | A stream is an infinite list.
data Stream a = a :> Stream a
    deriving Functor

-- | Converts a stream to the corresponding infinite list.
toList :: Stream a -> [a]
toList (x :> xs) = x : toList xs

unsafeFromList :: [a] -> Stream a
unsafeFromList = foldr (:>) $ error "fromList: finite list"

primes3mod4 :: Stream (Prime Natural)
primes3mod4 = unsafeFromList [nextPrime 3, nextPrime 7 ..]

-- Assume:
--   * All numbers in all the streams are distinct.
--   * Each stream is sorted.
--   * In the stream of streams, the first element of each stream is less than the first element of the next stream.
sortStreams :: forall a. Ord a => Stream (Stream a) -> Stream a
sortStreams ((x :> xs) :> xss) = x :> sortStreams (insert xs xss)
  where
    insert :: Stream a -> Stream (Stream a) -> Stream (Stream a)
    insert ys@(y :> _) zss@(zs@(z :> _) :> zss')
        | y < z     = ys :> zss
        | otherwise = zs :> insert ys zss'

-- | The
blumIntegers :: Stream Natural
blumIntegers = sortStreams $ go $ unPrime <$> primes3mod4
  where
    go :: Stream Natural -> Stream (Stream Natural)
    go (p :> ps) = ((p *) <$> ps) :> go ps

data Stats a = Stats
    { s1 :: !a
    , s3 :: !a
    , s7 :: !a
    , s9 :: !a
    } deriving (Show, Eq, Ord, Functor)

lastDigit :: Natural -> Int
lastDigit n = fromIntegral $ n `mod` 10

updateCount :: Stats Int -> Natural -> Stats Int
updateCount !dc n = case lastDigit n of
    1 -> dc { s1 = s1 dc + 1 }
    3 -> dc { s3 = s3 dc + 1 }
    7 -> dc { s7 = s7 dc + 1 }
    9 -> dc { s9 = s9 dc + 1 }
    _ -> error "updateCount: impossible"

countLastDigits :: forall a. Fractional a => Int -> Stream Natural -> Stats a
countLastDigits n = fmap f . go Stats { s1 = 0, s3 = 0, s7 = 0, s9 = 0 } n
  where
    go :: Stats Int -> Int -> Stream Natural -> Stats Int
    go !dc 0 _         = dc
    go !dc m (x :> xs) = go (updateCount dc x) (m - 1) xs

    f :: Int -> a
    f m = fromIntegral m / fromIntegral n


{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE TypeApplications   #-}

module Main
    ( main
    ) where

import           Control.Monad       (forM_)
import           Text.Printf         (printf)

import           Numeric.Natural     (Natural)

import           Rosetta.BlumInteger

main :: IO ()
main = do
    let xs = toList blumIntegers

    printf "The first 50 Blum integers are:\n\n"
    forM_ (take 50 xs) $ \x -> do
        printf "%3d\n" x
    printf "\n"

    nth xs 26_828
    forM_ [100_000, 200_000 .. 400_000] $ nth xs
    printf "\n"

    printf "Distribution by final digit for the first 400000 Blum integers:\n\n"
    let Stats r1 r3 r7 r9 = countLastDigits @Double 400_000 blumIntegers
    forM_ [(1 :: Int, r1), (3, r3), (7, r7), (9, r9)] $ \(d, r) ->
        printf "%d: %6.3f%%\n" d $ r * 100
    printf "\n"

  where

    nth :: [Natural] -> Int -> IO ()
    nth xs n = printf "The %6dth Blum integer is %8d.\n" n $ xs !! (n - 1)
