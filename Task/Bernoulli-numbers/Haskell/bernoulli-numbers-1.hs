import Data.Ratio
import System.Environment

main = getArgs >>= printM . defaultArg
  where
    defaultArg as =
      if null as
        then 60
        else read (head as)

printM m =
  mapM_ (putStrLn . printP) .
  takeWhile ((<= m) . fst) . filter (\(_, b) -> b /= 0 % 1) . zip [0 ..] $
  bernoullis

printP (i, r) =
  "B(" ++ show i ++ ") = " ++ show (numerator r) ++ "/" ++ show (denominator r)

bernoullis = map head . iterate (ulli 1) . map berno $ enumFrom 0
  where
    berno i = 1 % (i + 1)
    ulli _ [_] = []
    ulli i (x:y:xs) = (i % 1) * (x - y) : ulli (i + 1) (y : xs)
