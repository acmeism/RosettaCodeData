import Data.List (intercalate)
import Data.List.Ordered (union)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

----------------------- KLARNER-RADO ---------------------

klarnerRado :: [Integer]
klarnerRado =
  1 :
  union
    (succ . (2 *) <$> klarnerRado)
    (succ . (3 *) <$> klarnerRado)


--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "First one hundred elements of the sequence:\n"
  mapM_
    putStrLn
    (intercalate "  " <$> chunksOf 10
      (printf "%3d" <$> take 100 klarnerRado))

  putStrLn "\nKth and 10Kth elements of the sequence:\n"
  mapM_
    (putStrLn .
      (<*>) (flip (printf "%7dth %s %8d") " ->")
      ((klarnerRado !!) . pred)) $
        (10 ^) <$> [3 .. 6]
