import Control.Applicative ((<|>))
import Data.List (findIndex, replicate, scanl)
import Data.List.Split (chunksOf)
import System.Random

-------------------- BALANCED BRACKETS -------------------

nesting :: String -> [Int]
nesting = tail . scanl (flip level) 0
  where
    level '[' = succ
    level ']' = pred
    level  _  = id


bracketProblemIndex :: String -> Maybe Int
bracketProblemIndex s =
  findIndex (< 0) depths <|> unClosed
  where
    depths = nesting s
    unClosed
      | 0 /= last depths = Just $ pred (length s)
      | otherwise = Nothing


--------------------------- TEST -------------------------
main :: IO ()
main = do
  let g = mkStdGen 137
  mapM_ (putStrLn . showProblem) $
    chunksOf
      6
      (bracket <$> take 60 (randomRs (0, 1) g))

showProblem s =
  case bracketProblemIndex s of
    Just i -> s <> ": Unmatched\n" <> replicate i ' ' <> "^"
    _ -> s <> ": OK\n"

bracket :: Int -> Char
bracket 0 = '['
bracket _ = ']'
