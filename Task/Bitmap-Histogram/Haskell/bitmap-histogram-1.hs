module Bitmap.BW(module Bitmap.BW) where

import Bitmap
import Control.Monad.ST

newtype BW = BW Bool deriving (Eq, Ord)

instance Color BW where
    luminance (BW False) = 0
    luminance _          = 255
    black = BW False
    white = BW True
    toNetpbm [] = ""
    toNetpbm l = init (concatMap f line) ++ "\n" ++ toNetpbm rest
      where (line, rest) = splitAt 35 l
            f (BW False) = "1 "
            f _          = "0 "
    fromNetpbm = map f
      where f 1 = black
            f _ = white
    netpbmMagicNumber _ = "P1"
    netpbmMaxval _ = ""

toBWImage :: Color c => Image s c -> ST s (Image s BW)
toBWImage = toBWImage' 128

toBWImage' :: Color c => Int -> Image s c -> ST s (Image s BW)
{- The first argument gives the darkest luminance assigned
to white. -}
toBWImage' darkestWhite = mapImage $ f . luminance
  where f x | x < darkestWhite = black
            | otherwise        = white
