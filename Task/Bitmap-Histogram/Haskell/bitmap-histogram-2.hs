import Bitmap
import Bitmap.RGB
import Bitmap.BW
import Bitmap.Netpbm
import Control.Monad.ST
import Data.Array

main = do
    i <- readNetpbm "original.ppm" :: IO (Image RealWorld RGB)
    writeNetpbm "bw.pbm" =<< stToIO (do
        h <- histogram i
        toBWImage' (medianIndex h) i)

histogram :: Color c => Image s c -> ST s [Int]
histogram = liftM f . getPixels where
    f = elems . accumArray (+) 0 (0, 255) . map (\i -> (luminance i, 1))

medianIndex :: [Int] -> Int
{- Given a list l, finds the index i that minimizes
  abs $ sum (take i l) - sum (drop i l) -}
medianIndex l = result
  where (result, _, _, _, _) =
            iterate f (0, 0, 0, l, reverse l) !! (length l - 1)
        f (n, left, right, lL@(l : ls), rL@(r : rs)) =
            if   left < right
            then (n + 1, left + l, right,     ls, rL)
            else (n,     left,     right + r, lL, rs)
