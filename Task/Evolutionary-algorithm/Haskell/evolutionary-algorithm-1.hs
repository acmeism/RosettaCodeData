import System.Random
import Control.Monad
import Data.List
import Data.Ord
import Data.Array

showNum :: (Num a, Show a) => Int -> a -> String
showNum w = until ((>w-1).length) (' ':) . show

replace :: Int -> a -> [a] -> [a]
replace n c ls = take (n-1) ls ++ [c] ++ drop n ls

target = "METHINKS IT IS LIKE A WEASEL"
pfit = length target
mutateRate = 20
popsize = 100
charSet = listArray (0,26) $ ' ': ['A'..'Z'] :: Array Int Char

fitness = length . filter id . zipWith (==) target

printRes i g = putStrLn $
     "gen:" ++ showNum 4 i ++ "  "
     ++ "fitn:" ++ showNum 4  (round $ 100 * fromIntegral s / fromIntegral pfit ) ++ "%  "
     ++ show g
    where s = fitness g

mutate :: [Char] -> Int -> IO [Char]
mutate g mr = do
  let r = length g
  chances <- replicateM r $ randomRIO (1,mr)
  let pos = elemIndices 1 chances
  chrs <- replicateM (length pos) $ randomRIO (bounds charSet)
  let nchrs = map (charSet!) chrs
  return $ foldl (\ng (p,c) -> replace (p+1) c ng) g (zip pos nchrs)

evolve :: [Char] -> Int -> Int -> IO ()
evolve parent gen mr = do
  when ((gen-1) `mod` 20 == 0) $ printRes (gen-1) parent
  children <- replicateM popsize (mutate parent mr)
  let child = maximumBy (comparing fitness) (parent:children)
  if fitness child == pfit then printRes gen child
                           else evolve child (succ gen) mr

main = do
  let r = length target
  genes <- replicateM r $ randomRIO (bounds charSet)
  let parent = map (charSet!) genes
  evolve parent 1 mutateRate
