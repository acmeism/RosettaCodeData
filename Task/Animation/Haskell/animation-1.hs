import Graphics.HGL.Units (Time, Point, Size, )
import Graphics.HGL.Draw.Monad (Graphic, )
import Graphics.HGL.Draw.Text
import Graphics.HGL.Draw.Font
import Graphics.HGL.Window
import Graphics.HGL.Run
import Graphics.HGL.Utils

import Control.Exception (bracket, )

runAnim = runGraphics $
 bracket
  (openWindowEx "Basic animation task" Nothing (250,50) DoubleBuffered (Just 110))
  closeWindow
  (\w -> do
    f <- createFont (64,28) 0 False False "courier"
    let loop t dir = do
	  e <- maybeGetWindowEvent w
	  let d = case e of
		  Just (Button _ True False)  -> -dir
		  _ -> dir
	      t' = if d == 1 then last t : init t else tail t ++ [head t]
	  setGraphic w (withFont f $ text (5,10) t') >> getWindowTick w
	  loop  t' d
	
    loop "Hello world ! " 1  )
