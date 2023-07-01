{-# LANGUAGE OverloadedStrings, RankNTypes #-}
import Reflex
import Reflex.Dom
import Data.Text (Text, pack, unpack)
import Data.Map (Map, fromList, empty)
import Text.Read (readMaybe)

width = 600
height = 500

type Point = (Float,Float)
type Segment = (Point,Point)

data Ellipse = Ellipse {a :: Float, b :: Float, n :: Float}

toFloat :: Text -> Maybe Float
toFloat  = readMaybe.unpack

toEllipse :: Maybe Float -> Maybe Float -> Maybe Float -> Maybe Ellipse
toEllipse (Just a) (Just b) (Just n) =
    if a < 1.0 || b <= 1.0 || n <= 0.0  -- not all floats are valid
    then Nothing
    else Just $ Ellipse a b n

toEllipse _ _ _ = Nothing

showError :: Maybe a -> String
showError Nothing = "invalid input"
showError _ = ""

reflect45 pts  =  pts ++ fmap (\(x,y) -> ( y,  x)) (reverse pts)
rotate90  pts  =  pts ++ fmap (\(x,y) -> ( y, -x)) pts
rotate180 pts  =  pts ++ fmap (\(x,y) -> (-x, -y)) pts
scale a b      =  fmap (\(x,y) -> ( a*x, b*y ))
segments  pts  =  zip pts $ tail pts

toLineMap :: Maybe Ellipse -> Map Int ((Float,Float),(Float,Float))
toLineMap (Just (Ellipse a b n)) =
    let f p = (1 - p**n)**(1/n)
        dp = iterate (*0.9) 1.0
        ip = map (\p -> 1.0 -p) dp
        points s =
            if n > 1.0
            then (\p -> zip p (map f p)) ip
            else (\p -> zip (map f p) p) dp

    in fromList $  -- changes list to map (for listWithKey)
       zip [0..] $ -- annotates segments with index
       segments $  -- changes points to line segments
       scale a b $
       rotate180 $ -- doubles the point count
       rotate90 $  -- doubles the point count
       reflect45 $ -- doubles the point count
       takeWhile (\(x,y) -> x < y ) $ -- stop at 45 degree line
       points 0.9

toLineMap Nothing = empty

lineAttrs :: Segment -> Map Text Text
lineAttrs ((x1,y1), (x2,y2)) =
    fromList [ ( "x1",    pack $ show (width/2+x1))
             , ( "y1",    pack $ show (height/2+y1))
             , ( "x2",    pack $ show (width/2+x2))
             , ( "y2",    pack $ show (height/2+y2))
             , ( "style", "stroke:brown;stroke-width:2")
             ]

showLine :: MonadWidget t m => Int -> Dynamic t Segment -> m ()
showLine _ dSegment = do
    elSvgns "line" (lineAttrs <$> dSegment) $ return ()
    return ()

main = mainWidget $ do
    elAttr "h1" ("style" =: "color:brown") $ text "Superellipse"
    ta <- el "div" $ do
        text "a: "
        textInput def { _textInputConfig_initialValue = "200"}

    tb <- el "div" $ do
        text "b: "
        textInput def { _textInputConfig_initialValue = "200"}

    tn <- el "div" $ do
        text "n: "
        textInput def { _textInputConfig_initialValue = "2.5"}
    let
        ab = zipDynWith toEllipse (toFloat <$> value ta) (toFloat <$> value tb)
        dEllipse = zipDynWith ($) ab (toFloat <$> value tn)
        dLines = fmap toLineMap dEllipse

        dAttrs = constDyn $ fromList
                     [ ("width" , pack $ show width)
                     , ("height", pack $ show height)
                     ]
    elAttr "div" ("style" =: "color:red") $ dynText $ fmap (pack.showError) dEllipse
    el "div" $ elSvgns "svg" dAttrs $ listWithKey dLines showLine
    return ()

-- At end to avoid Rosetta Code unmatched quotes problem.
elSvgns :: forall t m a. MonadWidget t m => Text -> Dynamic t (Map Text Text) -> m a -> m (El t, a)
elSvgns = elDynAttrNS' (Just "http://www.w3.org/2000/svg")
