module Main where

import Data.List

procLychrel :: Integer -> [Integer]
procLychrel a = a : pl a
  where
    pl n =
        let s = n + reverseInteger n
             in if isPalindrome s
                  then [s]
                  else s : pl s

isPalindrome :: Integer -> Bool
isPalindrome n =
  let s = show n
  in (s == reverse s)

isLychrel :: Integer -> Bool
isLychrel = not . null . drop 500 . procLychrel

reverseInteger :: Integer -> Integer
reverseInteger = read . reverse . show

seedAndRelated :: (Int, [Integer], [Integer], Int)
seedAndRelated =
  let (seed, related, _) = foldl sar ([], [], []) [1 .. 10000]
      lseed = length seed
      lrelated = length related
      totalCount = lseed + lrelated
      pal = filter isPalindrome $ seed ++ related
  in (totalCount, pal, seed, lrelated)
  where
    sar (seed, related, lych) x =
      let s = procLychrel x
          sIsLychrel = not . null . drop 500 $ s
          (isIn, isOut) = partition (`elem` lych) . take 501 $ s
          newLych = lych ++ isOut
      in if sIsLychrel
           then if null isIn -- seed lychrel number
                  then (x : seed, related, newLych)
                  else (seed, x : related, newLych) -- related lychrel number
           else (seed, related, lych)

main = do
  let (totalCount, palindromicLychrel, lychrelSeeds, relatedCount) = seedAndRelated
  putStrLn $ "[1..10,000] contains " ++ show totalCount ++ " Lychrel numbers."
  putStrLn $ show palindromicLychrel ++ " are palindromic Lychrel numbers."
  putStrLn $ show lychrelSeeds ++ " are Lychrel seeds."
  putStrLn $ "There are " ++ show relatedCount ++ " related Lychrel numbers."
