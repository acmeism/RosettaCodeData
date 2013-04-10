module CircleBitmapExample where

import Circle
import Bitmap
import Control.Monad.ST

drawCircle :: (Color c) => Image s c -> c -> Point -> Int -> ST s (Image s c)
drawCircle image colour center radius = do
  let pixels = map Pixel (generateCirclePoints center radius)
  forM_ pixels $ \pixel -> setPix image pixel colour
  return image
