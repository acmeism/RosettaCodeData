import Bitmap
import Bitmap.Netpbm
import Bitmap.RGB

import Control.Monad
import Control.Monad.ST
import System.Environment (getArgs)

main = do
    [path1, path2] <- getArgs
    image1 <- readNetpbm path1
    image2 <- readNetpbm path2
    diff <- stToIO $ imageDiff image1 image2
    putStrLn $ "Difference: " ++ show (100 * diff) ++ "%"

imageDiff :: Image s RGB -> Image s RGB -> ST s Double
imageDiff image1 image2 = do
      i1 <- getPixels image1
      i2 <- getPixels image2
      unless (length i1 == length i2) $
          fail "imageDiff: Images are of different sizes"
      return $
          toEnum (sum $ zipWith minus i1 i2) /
          toEnum (3 * 255 * length i1)
  where (RGB (r1, g1, b1)) `minus` (RGB (r2, g2, b2)) =
            abs (r1 - r2) + abs (g1 - g2) + abs (b1 - b2)
