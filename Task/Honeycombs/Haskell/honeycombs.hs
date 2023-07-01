import Data.Char (toUpper)
import Data.Function (on)
import Data.List (zipWith4)
import System.Exit
import System.Random

-- External libraries.
import Graphics.Gloss
import Graphics.Gloss.Data.Vector
import Graphics.Gloss.Geometry
import Graphics.Gloss.Interface.IO.Game
import System.Random.Shuffle

-- A record of a hexagon-letter.
data Hex =
  Hex
  { hLetter   :: Char  -- The letter it holds.
  , hSelected :: Bool  -- The flag for if the hexagon has been selected.
  , hPath     :: Path  -- The hexagon's vertices.
  , hCenter   :: Point -- The center of the hexagon.
  }

-- A record of the world state.
data World =
  World
  { wHexes  :: [Hex]  -- The hexagons to interact with.
  , wString :: String -- An ordering of picked letters.
  }

-- Assorted helper functions.
addV, subV :: Vector -> Vector -> Vector
addV (a, b) (x, y) = (a + x, b + y)
subV (a, b) (x, y) = (a - x, b - y)

translateP :: Vector -> Path -> Path
translateP v = map (addV v)

translateV :: Vector -> Picture -> Picture
translateV (x, y) p = translate x y p

lightblue, darkblue :: Color
lightblue = makeColor 0.5 0.5 1.0 1.0
darkblue  = makeColor 0.0 0.0 0.5 1.0

-- Create vertices for an n-gon with the given radius to a vertex
ngon :: Int -> Float -> Path
ngon n radius =
  let angle = 2 * pi / fromIntegral n
  in map (mulSV radius . unitVectorAtAngle . (* angle) . fromIntegral)
     [0..(n - 1)]

-- Determine if a point lies on or within a polygon.
inPolygon :: Point -> Path -> Bool
inPolygon point path =
  all (>= 0) $ zipWith detV vas vbs
  where
    vas = zipWith subV (drop 1 $ cycle path) path
    vbs = map (subV point) path

-- Construct all of the hexagons transformed to their screen coordinates
-- to make mouse picking easier to solve.
mkHexes :: RandomGen g => g -> Float -> World
mkHexes gen radius = World hexes ""
  where
    letters = take 20 $ shuffle' ['A'..'Z'] 26 gen
    xs      = concatMap (replicate 4) [-2..2]
    ys      = cycle [-2..1]
    inRad   = radius * (cos $ degToRad 30)
    yOff x  = if ((floor x) :: Int) `mod` 2 == 0 then inRad else 0
    yStep   = inRad * 2
    xStep   = radius * 1.5
    centers = zipWith (\x y -> (x * xStep, yOff x + y * yStep)) xs ys
    paths   = map (flip translateP $ ngon 6 radius) centers
    hexes   = zipWith4 Hex letters (repeat False) paths centers

-- Draw a single hexagon-letter.
drawHex :: Hex -> Picture
drawHex (Hex letter selected path center) =
  pictures [hex, outline, letterPic]
  where
    hex              = color hcolor $ polygon path
    outline          = color blue $ lineLoop path
    letterPic        = color lcolor
                       $ translateV (addV (-10, -10) center)
                       $ scale 0.25 0.25
                       $ text [letter]
    (hcolor, lcolor) = if selected
                       then (darkblue, white)
                       else (lightblue, black)

-- Draw the whole scene.
drawWorld :: World -> Picture
drawWorld (World hexes string) =
  pictures [pictures $ map drawHex hexes
           ,pictures $ map drawHighHex hexes
           ,color (light lightblue) $ textPic
           ,scale 1.05 1.05 $ textPic]
  where
    drawHighHex hex = color black $ scale 1.05 1.05 $ lineLoop $ hPath hex
    textPic = translateV (-130, -175) $ scale 0.15 0.15 $ text string

-- Handle keyboard and mouse events and update the hexagons
-- accordingly. This function checks the hexagon states and
-- invokes a system exit when all are marked selected.
handleInput :: Event -> World -> IO World
handleInput event world@(World hexes string) =
  case event of
    EventKey key Down _ point ->
      case key of
        SpecialKey KeyEsc -> exitSuccess
        Char char         -> hCond (\hex -> hLetter hex == toUpper char)
        MouseButton _     -> hCond (\hex -> inPolygon point $ hPath hex)
        _                 -> return world
    _                         ->
      return world
  where
    checkWorld w = if all hSelected $ wHexes w then exitSuccess else return w
    hCond cond   = checkWorld $ World newHexes newString
      where
        newHexes  = flip map hexes
                   (\hex -> if cond hex
                            then hex {hSelected = True}
                            else hex)
        diff      = map fst
                    $ filter (uncurry ((/=) `on` hSelected))
                    $ zip hexes newHexes
        newString = case diff of
          []      -> string
          (hex:_) -> string ++ [hLetter hex]

main :: IO ()
main = do
  stdGen <- getStdGen
  playIO
    (InWindow "Honeycombs" (500, 500) (100, 100))
    white
    60
    (mkHexes stdGen 30)
    (return . drawWorld)
    handleInput
    (\_ x -> return x)
