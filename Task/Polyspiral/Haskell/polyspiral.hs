{-# LANGUAGE OverloadedStrings #-}
import Reflex
import Reflex.Dom
import Reflex.Dom.Time
import Data.Text (Text, pack)
import Data.Map (Map, fromList)
import Data.Time.Clock (getCurrentTime)
import Control.Monad.Trans (liftIO)

type Point = (Float,Float)
type Segment = (Point,Point)

main = mainWidget $ do

  -- An event that fires every 0.05 seconds.
  dTick <- tickLossy 0.05 =<< liftIO getCurrentTime

  -- A dynamically updating counter.
  dCounter <- foldDyn (\_ c -> c+1) (0::Int) dTick

  let
      -- A dynamically updating angle.
      dAngle = fmap (\c -> fromIntegral c / 800.0) dCounter

      -- A dynamically updating spiral
      dSpiralMap = fmap toSpiralMap dAngle

      -- svg parameters
      width = 600
      height = 600

      boardAttrs =
         fromList [ ("width" , pack $ show width)
                  , ("height", pack $ show height)
                  , ("viewBox", pack $ show (-width/2) ++ " " ++ show (-height/2) ++ " " ++ show width ++ " " ++ show height)
                  ]

  elAttr "h1" ("style" =: "color:black") $ text "Polyspiral"
  elAttr "a" ("href" =: "http://rosettacode.org/wiki/Polyspiral#Haskell") $ text "Rosetta Code / Polyspiral / Haskell"

  el "br" $ return ()
  elSvgns "svg" (constDyn boardAttrs) (listWithKey dSpiralMap showLine)

  return ()

-- The svg attributes needed to display a line segment.
lineAttrs :: Segment -> Map Text Text
lineAttrs ((x1,y1), (x2,y2)) =
  fromList [ ( "x1",    pack $ show x1)
           , ( "y1",    pack $ show y1)
           , ( "x2",    pack $ show x2)
           , ( "y2",    pack $ show y2)
           , ( "style", "stroke:blue")
           ]

-- Use svg to display a line segment.
showLine :: MonadWidget t m => Int -> Dynamic t Segment -> m ()
showLine _ dSegment = elSvgns "line" (lineAttrs <$> dSegment) $ return ()

-- Given a point and distance/bearing , get the next point
advance :: Float -> (Point, Float, Float) -> (Point, Float, Float)
advance angle ((x,y), len, rot) =
  let new_x = x + len * cos rot
      new_y = y + len * sin rot
      new_len = len + 3.0
      new_rot = rot + angle
  in ((new_x, new_y), new_len, new_rot)

-- Given an angle, generate a map of segments that form a spiral.
toSpiralMap :: Float -> Map Int ((Float,Float),(Float,Float))
toSpiralMap angle =
      fromList                       -- changes list to map (for listWithKey)
  $   zip [0..]                      -- annotates segments with index
  $   (\pts -> zip pts $ tail pts)   -- from points to line segments
  $   take 80                        -- limit the number of points
  $   (\(pt,_,_) -> pt)              -- cull out the (x,y) values
  <$> iterate (advance angle) ((0, 0), 0, 0)  -- compute the spiral

-- Display an element in svg namespace
elSvgns :: MonadWidget t m => Text -> Dynamic t (Map Text Text) -> m a -> m a
elSvgns t m ma = do
    (el, val) <- elDynAttrNS' (Just "http://www.w3.org/2000/svg") t m ma
    return val
