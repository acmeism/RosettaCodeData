-- Before you can install the SFML Haskell library, you need to install
-- the CSFML C library.  (For example, "brew install csfml" on OS X.)

-- This program runs in fullscreen mode.
-- Press any key or mouse button to exit.

import Control.Exception
import SFML.Graphics
import SFML.SFResource
import SFML.Window hiding (width, height)

withResource :: SFResource a => IO a -> (a -> IO b) -> IO b
withResource acquire = bracket acquire destroy

withResources :: SFResource a => IO [a] -> ([a] -> IO b) -> IO b
withResources acquire = bracket acquire (mapM_ destroy)

colors :: [Color]
colors = [black, red, green, magenta, cyan, yellow, white]

makeBar :: (Float, Float) -> (Color, Int) -> IO RectangleShape
makeBar (barWidth, height) (c, i) = do
  bar <- err $ createRectangleShape
  setPosition  bar $ Vec2f (fromIntegral i * barWidth) 0
  setSize      bar $ Vec2f barWidth height
  setFillColor bar c
  return bar

barSize :: VideoMode -> (Float, Float)
barSize (VideoMode w h _ ) = ( fromIntegral w / fromIntegral (length colors)
                             , fromIntegral h )

loop :: RenderWindow -> [RectangleShape] -> IO ()
loop wnd bars = do
  mapM_ (\x -> drawRectangle wnd x Nothing) bars
  display wnd
  evt <- waitEvent wnd
  case evt of
    Nothing -> return ()
    Just SFEvtClosed -> return ()
    Just (SFEvtKeyPressed {}) -> return ()
    Just (SFEvtMouseButtonPressed {}) -> return ()
    _ -> loop wnd bars

main :: IO ()
main = do
  vMode <- getDesktopMode
  let wStyle = [SFFullscreen]
  withResource (createRenderWindow vMode "color bars" wStyle Nothing) $
     \wnd -> withResources (mapM (makeBar $ barSize vMode) $ zip colors [0..]) $
     \bars -> loop wnd bars
