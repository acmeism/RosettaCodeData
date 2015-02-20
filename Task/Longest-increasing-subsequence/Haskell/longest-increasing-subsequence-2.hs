{-# LANGUAGE FlexibleContexts, UnicodeSyntax #-}

module Main (main, lis) where

import Control.Monad.ST  ( ST, runST )
import Control.Monad     ( (>>=), (=<<), foldM )
import Data.Array.ST     ( Ix,  STArray, readArray, writeArray, newArray )
import Data.Array.MArray ( MArray )

infix 4 ≡

(≡) :: Eq α ⇒ α → α → Bool
(≡) = (==)

(∘) = (.)


lis ∷ Ord α ⇒ [α] → [α]
lis xs = runST $ do
  let lxs = length xs
  pileTops ← newSTArray (min 1 lxs , lxs) []
  i        ← foldM (stack pileTops) 0 xs
  readArray pileTops i >>= return ∘ reverse

stack ∷ (Integral ι, Ord ε, Ix ι, MArray α [ε] μ)
      ⇒ α ι [ε] → ι → ε → μ ι
stack piles i x = do
  j ← bsearch piles x i
  writeArray piles j ∘ (x:) =<< if j ≡ 1 then return []
                                         else readArray piles (j-1)
  return $ if j ≡ i+1 then i+1 else i

bsearch ∷ (Integral ι, Ord ε, Ix ι, MArray α [ε] μ)
        ⇒ α ι [ε] → ε → ι → μ ι
bsearch piles x = go 1
  where go lo hi | lo > hi   = return lo
                 | otherwise =
                    do (y:_) ← readArray piles mid
                       if y < x then go (succ mid) hi
                                else go lo (pred mid)

                         where mid = (lo + hi) `div` 2

newSTArray ∷ Ix ι ⇒ (ι,ι) → ε → ST σ (STArray σ ι ε)
newSTArray = newArray


main ∷ IO ()
main = do
  print $ lis [3, 2, 6, 4, 5, 1]
  print $ lis [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
  print $ lis [1, 1, 1, 1]
