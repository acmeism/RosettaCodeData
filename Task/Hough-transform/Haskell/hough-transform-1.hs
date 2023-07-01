import Control.Monad (forM_, when)
import Data.Array ((!))
import Data.Array.ST (newArray, writeArray, readArray, runSTArray)
import qualified Data.Foldable as F (maximum)
import System.Environment (getArgs, getProgName)

-- Library JuicyPixels:
import Codec.Picture
       (DynamicImage(ImageRGB8, ImageRGBA8), Image, PixelRGB8(PixelRGB8),
        PixelRGBA8(PixelRGBA8), imageWidth, imageHeight, pixelAt,
        generateImage, readImage, pixelMap, savePngImage)
import Codec.Picture.Types (extractLumaPlane, dropTransparency)

dot
  :: Num a
  => (a, a) -> (a, a) -> a
dot (x1, y1) (x2, y2) = x1 * x2 + y1 * y2

mag
  :: Floating a
  => (a, a) -> a
mag a = sqrt $ dot a a

sub
  :: Num a
  => (a, a) -> (a, a) -> (a, a)
sub (x1, y1) (x2, y2) = (x1 - x2, y1 - y2)

fromIntegralP
  :: (Integral a, Num b)
  => (a, a) -> (b, b)
fromIntegralP (x, y) = (fromIntegral x, fromIntegral y)

{-
  Create a Hough space image with y+ measuring the distance from
  the center of the input image on the range of 0 to half the hypotenuse
  and x+ measuring from [0, 2 * pi].
  The origin is in the upper left, so y is increasing down.
  The image is scaled according to thetaSize and distSize.
-}
hough :: Image PixelRGB8 -> Int -> Int -> Image PixelRGB8
hough image thetaSize distSize = hImage
  where
    width = imageWidth image
    height = imageHeight image
    wMax = width - 1
    hMax = height - 1
    xCenter = wMax `div` 2
    yCenter = hMax `div` 2
    lumaMap = extractLumaPlane image
    gradient x y =
      let orig = pixelAt lumaMap x y
          x_ = pixelAt lumaMap (min (x + 1) wMax) y
          y_ = pixelAt lumaMap x (min (y + 1) hMax)
      in fromIntegralP (orig - x_, orig - y_)
    gradMap =
      [ ((x, y), gradient x y)
      | x <- [0 .. wMax]
      , y <- [0 .. hMax] ]
    -- The longest distance from the center, half the hypotenuse of the image.
    distMax :: Double
    distMax = (sqrt . fromIntegral $ height ^ 2 + width ^ 2) / 2
    {-
      The accumulation bins of the polar values.
      For each value in the gradient image, if the gradient length exceeds
      some threshold, consider it evidence of a line and plot all of the
      lines that go through that point in Hough space.
    -}
    accBin =
      runSTArray $
      do arr <- newArray ((0, 0), (thetaSize, distSize)) 0
         forM_ gradMap $
           \((x, y), grad) -> do
             let (x_, y_) = fromIntegralP $ (xCenter, yCenter) `sub` (x, y)
             when (mag grad > 127) $
               forM_ [0 .. thetaSize] $
               \theta -> do
                 let theta_ =
                       fromIntegral theta * 360 / fromIntegral thetaSize / 180 *
                       pi :: Double
                     dist = cos theta_ * x_ + sin theta_ * y_
                     dist_ = truncate $ dist * fromIntegral distSize / distMax
                     idx = (theta, dist_)
                 when (dist_ >= 0 && dist_ < distSize) $
                   do old <- readArray arr idx
                      writeArray arr idx $ old + 1
         return arr
    maxAcc = F.maximum accBin
    -- The image representation of the accumulation bins.
    hTransform x y =
      let l = 255 - truncate ((accBin ! (x, y)) / maxAcc * 255)
      in PixelRGB8 l l l
    hImage = generateImage hTransform thetaSize distSize

houghIO :: FilePath -> FilePath -> Int -> Int -> IO ()
houghIO path outpath thetaSize distSize = do
  image <- readImage path
  case image of
    Left err -> putStrLn err
    Right (ImageRGB8 image_) -> doImage image_
    Right (ImageRGBA8 image_) -> doImage $ pixelMap dropTransparency image_
    _ -> putStrLn "Expecting RGB8 or RGBA8 image"
  where
    doImage image = do
      let houghImage = hough image thetaSize distSize
      savePngImage outpath $ ImageRGB8 houghImage

main :: IO ()
main = do
  args <- getArgs
  prog <- getProgName
  case args of
    [path, outpath, thetaSize, distSize] ->
      houghIO path outpath (read thetaSize) (read distSize)
    _ ->
      putStrLn $
      "Usage: " ++ prog ++ " <image-file> <out-file.png> <width> <height>"
