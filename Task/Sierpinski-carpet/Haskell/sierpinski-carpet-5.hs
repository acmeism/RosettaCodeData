{-# LANGUAGE DoRec #-}
import Control.Monad.Trans (lift)
import Data.Colour (Colour)

import Diagrams.Prelude hiding (after)
import Diagrams.Backend.Cairo (Cairo)
import Diagrams.Backend.Cairo.Gtk (defaultRender)

import Graphics.Rendering.Diagrams.Points ()
import Graphics.UI.Gtk
import Graphics.UI.Gtk.Gdk.GC (gcNew)


main :: IO ()
main = do
  _ <- initGUI
  window <- windowNew
  _ <- window `onDestroy` mainQuit
  window `windowSetResizable` False

  area <- drawingAreaNew
  _ <- area `on` sizeRequest $ return (Requisition 500 500)
  _ <- window `containerAdd` area
  widgetShowAll window

  rec con <- area `on` exposeEvent $ do
                lift $ signalDisconnect con
                lift $ area `defaultRender` carpet 5
                switchToPixBuf area
  mainGUI


-- just workaround for slow redrawing
switchToPixBuf :: DrawingArea -> EventM EExpose Bool
switchToPixBuf area =
    eventArea >>= \ea -> lift $ do
        dw      <- widgetGetDrawWindow area
        (w,h)   <- drawableGetSize dw
        Just pb <- pixbufGetFromDrawable dw ea
        gc      <- gcNew dw
        _ <- area `on` exposeEvent $ lift $
              False <$ drawPixbuf dw gc pb 0 0 0 0 w h RgbDitherNone 0 0
        return False


carpet :: Int -> Diagram Cairo R2
carpet = (iterate next (cell white) !!)

-- of course, one can use hcat / vcat - combinators
next :: Diagram Cairo R2 -> Diagram Cairo R2
next block =
    scale (1/3) . centerXY  $

	(block ||| block ||| block)
    	            ===
    	(block ||| centr ||| block)
    	            ===
    	(block ||| block ||| block)
    where
      centr = cell black

cell :: Colour Float -> Diagram Cairo R2
cell color = square 1 # lineWidth 0 # fillColor color
