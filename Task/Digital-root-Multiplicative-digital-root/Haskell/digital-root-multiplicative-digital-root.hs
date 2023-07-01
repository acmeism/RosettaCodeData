import Control.Arrow
import Data.Array
import Data.LazyArray
import Data.List (unfoldr)
import Data.Tuple
import Text.Printf

-- The multiplicative persistence (MP) and multiplicative digital root (MDR) of
-- the argument.
mpmdr :: Integer -> (Int, Integer)
mpmdr = (length *** head) . span (> 9) . iterate (product . digits)

-- Pairs (mdr, ns) where mdr is a multiplicative digital root and ns are the
-- first k numbers having that root.
mdrNums :: Int -> [(Integer, [Integer])]
mdrNums k = assocs $ lArrayMap (take k) (0,9) [(snd $ mpmdr n, n) | n <- [0..]]

digits :: Integral t => t -> [t]
digits 0 = [0]
digits n = unfoldr step n
  where step 0 = Nothing
        step k = Just (swap $ quotRem k 10)

printMpMdrs :: [Integer] -> IO ()
printMpMdrs ns = do
  putStrLn "Number MP MDR"
  putStrLn "====== == ==="
  sequence_ [printf "%6d %2d %2d\n" n p r | n <- ns, let (p,r) = mpmdr n]

printMdrNums:: Int -> IO ()
printMdrNums k = do
  putStrLn "MDR Numbers"
  putStrLn "=== ======="
  let showNums = unwords . map show
  sequence_ [printf "%2d  %s\n" mdr $ showNums ns | (mdr,ns) <- mdrNums k]

main :: IO ()
main = do
  printMpMdrs [123321, 7739, 893, 899998]
  putStrLn ""
  printMdrNums 5
