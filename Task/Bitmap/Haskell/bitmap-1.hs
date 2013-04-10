module Bitmap(module Bitmap) where

import Control.Monad
import Control.Monad.ST
import Data.Array.ST

newtype Pixel = Pixel (Int, Int) deriving Eq

instance Ord Pixel where
    compare (Pixel (x1, y1)) (Pixel (x2, y2)) =
        case compare y1 y2 of
            EQ -> compare x1 x2
            v  -> v

instance Ix Pixel where
{- This instance differs from the one for (Int, Int) in that
the ordering of indices is
  (0,0), (1,0), (2,0), (0,1), (1,1), (2,1)
instead of
  (0,0), (0,1), (1,0), (1,1), (2,0), (2,1). -}
    range (Pixel (xa, ya), Pixel (xz, yz)) =
        [Pixel (x, y) | y <- [ya .. yz], x <- [xa .. xz]]
    index (Pixel (xa, ya), Pixel (xz, _)) (Pixel (xi, yi)) =
        (yi - ya)*(xz - xa + 1) + (xi - xa)
    inRange (Pixel (xa, ya), Pixel (xz, yz)) (Pixel (xi, yi)) =
        not $ xi < xa || xi > xz || yi < ya || yi > yz
    rangeSize (Pixel (xa, ya), Pixel (xz, yz)) =
        (xz - xa + 1) * (yz - ya + 1)

instance Show Pixel where
    show (Pixel p) = show p

class Ord c => Color c where
    luminance :: c -> Int
     -- The Int should be in the range [0 .. 255].
    black, white :: c
    toNetpbm :: [c] -> String
    fromNetpbm :: [Int] -> [c]
    netpbmMagicNumber, netpbmMaxval :: c -> String
      {- The argument to these two functions is ignored; the
      parameter is only for typechecking. -}

newtype Color c => Image s c = Image (STArray s Pixel c)

image :: Color c => Int -> Int -> c -> ST s (Image s c)
{- Creates a new image with the given width and height, filled
with the given color. -}
image w h = liftM Image .
    newArray (Pixel (0, 0), Pixel (w - 1, h - 1))

listImage :: Color c => Int -> Int -> [c] -> ST s (Image s c)
{- Creates a new image with the given width and height, with
each pixel set to the corresponding element of the given list. -}
listImage w h = liftM Image .
    newListArray (Pixel (0, 0), Pixel (w - 1, h - 1))

dimensions :: Color c => Image s c -> ST s (Int, Int)
dimensions (Image i) = do
    (_, Pixel (x, y)) <- getBounds i
    return (x + 1, y + 1)

getPix :: Color c => Image s c -> Pixel -> ST s c
getPix (Image i) = readArray i

getPixels :: Color c => Image s c -> ST s [c]
getPixels (Image i) = getElems i

setPix :: Color c => Image s c -> Pixel -> c -> ST s ()
setPix (Image i) = writeArray i

fill :: Color c => Image s c -> c -> ST s ()
fill (Image i) c = getBounds i >>= mapM_ f . range
  where f p = writeArray i p c

mapImage :: (Color c, Color c') =>
    (c -> c') -> Image s c -> ST s (Image s c')
mapImage f (Image i) = liftM Image $ mapArray f i
