import System.IO (readFile)
import Control.Monad (foldM)
import Data.List (intercalate)
import qualified Data.Set as S

distance :: String -> String -> Int
distance s1 s2 = length $ filter not $ zipWith (==) s1 s2

wordLadders :: [String] -> String -> String -> [[String]]
wordLadders dict start end
  | length start /= length end = []
  | otherwise = [wordSpace] >>= expandFrom start >>= shrinkFrom end
  where

    wordSpace = S.fromList $ filter ((length start ==) . length) dict

    expandFrom s = go [[s]]
      where
        go (h:t) d
          | S.null d || S.null f = []
          | end `S.member` f = [h:t]
          | otherwise = go (S.elems f:h:t) (d S.\\ f)
          where
            f = foldr (\w -> S.union (S.filter (oneStepAway w) d)) mempty h

    shrinkFrom = scanM (filter . oneStepAway)

    oneStepAway x = (1 ==) . distance x

    scanM f x = fmap snd . foldM g (x,[x])
      where g (b, r) a = (\x -> (x, x:r)) <$> f b a

wordLadder :: [String] -> String -> String -> [String]
wordLadder d s e = case wordLadders d s e of
                     [] -> []
                     h:_ -> h

showChain [] = putStrLn "No chain"
showChain ch = putStrLn $ intercalate " -> " ch

main = do
  dict <- lines <$> readFile "unixdict.txt"
  showChain $ wordLadder dict "boy" "man"
  showChain $ wordLadder dict "girl" "lady"
  showChain $ wordLadder dict "john" "jane"
  showChain $ wordLadder dict "alien" "drool"
  showChain $ wordLadder dict "child" "adult"
