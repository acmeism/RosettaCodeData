import qualified Data.ByteString.Lazy as BS
import qualified Data.Foldable as Fold
import qualified Data.List as List
import Data.Ord
import qualified Data.Sequence as Seq
import Data.Word
import System.Environment

import Codec.Picture
import Codec.Picture.Types

type Accessor = PixelRGB8 -> Pixel8

-- Getters for pixel components, as the constructor does not
-- provide any public ones.
red, blue, green :: Accessor
red   (PixelRGB8 r _ _) = r
green (PixelRGB8 _ g _) = g
blue  (PixelRGB8 _ _ b) = b

-- Get all of the pixels in the image in list form.
getPixels :: Pixel a => Image a -> [a]
getPixels image =
  [pixelAt image x y
  | x <- [0..(imageWidth image - 1)]
  , y <- [0..(imageHeight image - 1)]]

-- Compute the color-space extents of a list of pixels.
extents :: [PixelRGB8] -> (PixelRGB8, PixelRGB8)
extents pixels = (extent minimum, extent maximum)
  where
    bound f g = f $ map g pixels
    extent f  = PixelRGB8 (bound f red) (bound f green) (bound f blue)

-- Compute the average value of a list of pixels.
average :: [PixelRGB8] -> PixelRGB8
average pixels = PixelRGB8 (avg red) (avg green) (avg blue)
  where
    len   = toInteger $ length pixels
    avg c = fromIntegral $ (sum $ map (toInteger . c) pixels) `div` len

-- Perform a componentwise pixel operation.
compwise :: (Word8 -> Word8 -> Word8) -> PixelRGB8 -> PixelRGB8 -> PixelRGB8
compwise f (PixelRGB8 ra ga ba) (PixelRGB8 rb gb bb) =
  PixelRGB8 (f ra rb) (f ga gb) (f ba bb)

-- Compute the absolute difference of two pixels.
diffPixel :: PixelRGB8 -> PixelRGB8 -> PixelRGB8
diffPixel = compwise (\x y -> max x y - min x y)

-- Compute the Euclidean distance squared between two pixels.
distPixel :: PixelRGB8 -> PixelRGB8 -> Integer
distPixel x y = (rr ^ 2) + (gg ^ 2) + (bb ^ 2)
  where
    PixelRGB8 r g b = diffPixel x y
    rr              = toInteger r
    gg              = toInteger g
    bb              = toInteger b

-- Determine the dimension of the longest axis of the extents.
longestAccessor :: (PixelRGB8, PixelRGB8) -> Accessor
longestAccessor (l, h) =
  snd $ Fold.maximumBy (comparing fst) $ zip [r, g, b] [red, green, blue]
  where
    PixelRGB8 r g b = diffPixel h l

-- Find the index of a pixel to its respective palette.
nearestIdx :: PixelRGB8 -> [PixelRGB8] -> Int
nearestIdx pixel px = ans
  where
    Just ans = List.findIndex (== near) px
    near     = List.foldl1 comp px
    comp a b = if distPixel a pixel <= distPixel b pixel then a else b

-- Sort a list of pixels on its longest axis and then split by the mean.
-- It is intentional that the mean is chosen by all dimensions
-- instead of the given one.
meanSplit :: [PixelRGB8] -> Accessor -> ([PixelRGB8], [PixelRGB8])
meanSplit l f = List.splitAt index sorted
  where
    sorted = List.sortBy (comparing f) l
    index  = nearestIdx (average l) sorted

-- Perform the Median Cut algorithm on an image producing
-- an index map image and its respective palette.
meanCutQuant :: Image PixelRGB8 -> Int -> (Image Pixel8, Palette)
meanCutQuant image numRegions = (indexmap, palette)
  where
    extentsP p   = (p, extents p)
    regions      = map (\(p, e) -> (average p, e))
                   $ search $ Seq.singleton $ extentsP $ getPixels image
    palette      = snd $ generateFoldImage (\(x:xs) _ _ -> (xs, x))
                   (map fst regions) numRegions 1
    indexmap     = pixelMap
                   (\pixel -> fromIntegral $ nearestIdx pixel $ map fst regions)
                   image
    search queue =
      case Seq.viewl queue of
        (pixels, extent) Seq.:< queueB ->
          let (left, right) = meanSplit pixels $ longestAccessor extent
              queueC        = Fold.foldl (Seq.|>) queueB $ map extentsP [left, right]
          in if Seq.length queueC >= numRegions
             then List.take numRegions $ Fold.toList queueC
             else search queueC
        Seq.EmptyL                     -> error "Queue should never be empty."

quantizeIO :: FilePath -> FilePath -> Int -> IO ()
quantizeIO path outpath numRegions = do
  dynimage <- readImage path
  case dynimage of
    Left err                 -> putStrLn err
    Right (ImageRGB8 image)  -> doImage image
    Right (ImageRGBA8 image) -> doImage (pixelMap dropTransparency image)
    _                        -> putStrLn "Expecting RGB8 or RGBA8 image"
  where
    doImage image = do
      let (indexmap, palette) = meanCutQuant image numRegions
      case encodePalettedPng palette indexmap of
        Left err      -> putStrLn err
        Right bstring -> BS.writeFile outpath bstring

main :: IO ()
main = do
  args <- getArgs
  prog <- getProgName
  case args of
    [path, outpath] -> quantizeIO path outpath 16
    _               -> putStrLn $ "Usage: " ++ prog ++ " <image-file> <out-file.png>"
