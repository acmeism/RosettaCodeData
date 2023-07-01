module Bitmap.RGB(module Bitmap.RGB) where

import Bitmap
import Control.Monad.ST

newtype RGB = RGB (Int, Int, Int) deriving (Eq, Ord)

instance Color RGB where
    luminance (RGB (r, g, b)) = round x
      where x = 0.2126*r' + 0.7152*g' + 0.0722*b'
            (r', g', b') = (toEnum r, toEnum g, toEnum b)
    black = RGB (0,   0,   0)
    white = RGB (255, 255, 255)
    toNetpbm = concatMap f
      where f (RGB (r, g, b)) = [toEnum r, toEnum g, toEnum b]
    fromNetpbm [] = []
    fromNetpbm (r : g : b : rest) = RGB (r, g, b) : fromNetpbm rest
    netpbmMagicNumber _ = "P6"
    netpbmMaxval _ = "255"

toRGBImage :: Color c => Image s c -> ST s (Image s RGB)
toRGBImage = mapImage $ f . luminance
  where f x = RGB (x, x, x)
