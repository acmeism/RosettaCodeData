import Control.Monad (join)
import Data.Bits
  ( countLeadingZeros,
    finiteBitSize,
    shift,
    (.|.)
  )
import Text.Printf (printf)

-- Find the amount of bits required to represent a number
nBits :: Int -> Int
nBits = (-) . finiteBitSize <*> countLeadingZeros

-- Concatenate the bits of a number to itself
concatSelf :: Int -> Int
concatSelf = (.|.) =<< shift <*> nBits

-- Integers whose base-2 representation is the concatenation
-- of two identical binary strings
identStrInts :: [Int]
identStrInts = map concatSelf [1 ..]

main :: IO ()
main =
  putStr $
    unlines $
      map (join $ printf "%d: %b") to1000
  where
    to1000 = takeWhile (<= 1000) identStrInts
