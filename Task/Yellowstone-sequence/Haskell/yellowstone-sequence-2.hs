import Codec.Picture
import Data.Bifunctor (second)
import Diagrams.Backend.Rasterific
import Diagrams.Prelude
import Graphics.Rendering.Chart.Backend.Diagrams
import Graphics.Rendering.Chart.Easy
import qualified Graphics.SVGFonts.ReadFont as F

----------------- YELLOWSTONE PERMUTATION ----------------
yellowstone :: [Integer]
yellowstone =
  1 :
  2 :
  (active <$> iterate nextWindow (2, 3, [4 ..]))
  where
    nextWindow (p2, p1, rest) = (p1, n, residue)
      where
        [rp2, rp1] = relativelyPrime <$> [p2, p1]
        go (x : xs)
          | rp1 x && not (rp2 x) = (x, xs)
          | otherwise = second ((:) x) (go xs)
        (n, residue) = go rest
    active (_, x, _) = x

relativelyPrime :: Integer -> Integer -> Bool
relativelyPrime a b = 1 == gcd a b

---------- 30 FIRST TERMS, AND CHART OF FIRST 100 --------
main :: IO (Image PixelRGBA8)
main = do
  print $ take 30 yellowstone
  env <- chartEnv
  return $
    chartRender env $
      plot
        ( line
            "Yellowstone terms"
            [zip [1 ..] (take 100 yellowstone)]
        )

--------------------- CHART GENERATION -------------------
chartRender ::
  (Default r, ToRenderable r) =>
  DEnv Double ->
  EC r () ->
  Image PixelRGBA8
chartRender env ec =
  renderDia
    Rasterific
    ( RasterificOptions
        (mkWidth (fst (envOutputSize env)))
    )
    $ fst $ runBackendR env (toRenderable (execEC ec))

------------------------ LOCAL FONT ----------------------
chartEnv :: IO (DEnv Double)
chartEnv = do
  sansR <- F.loadFont "SourceSansPro_R.svg"
  sansRB <- F.loadFont "SourceSansPro_RB.svg"
  let fontChosen fs =
        case ( _font_name fs,
               _font_slant fs,
               _font_weight fs
             ) of
          ( "sans-serif",
            FontSlantNormal,
            FontWeightNormal
            ) -> sansR
          ( "sans-serif",
            FontSlantNormal,
            FontWeightBold
            ) -> sansRB
  return $ createEnv vectorAlignmentFns 640 400 fontChosen
