import qualified Graphics.Rendering.OpenGL as GL
import qualified Graphics.UI.GLFW as GLFW
import qualified Foreign as F
import qualified System.Random as R

height = 240
width = 320
numbytes = height * width
imagesize = GL.Size (fromIntegral width) (fromIntegral height)

main :: IO ()
main = do
  isInit <- GLFW.init
  if isInit
  then do
    m <- GLFW.createWindow width height "" Nothing Nothing
    case m of
      Just win -> do
             GLFW.makeContextCurrent m
             GLFW.swapInterval 1
             GLFW.setKeyCallback win $ Just keyCallback
             glLoop win
             GLFW.destroyWindow win
      Nothing  -> return ()
    GLFW.terminate
  else return ()

glLoop :: GLFW.Window -> IO ()
glLoop win = do
  foreignPixels <- F.mallocForeignPtrArray numbytes
  F.withForeignPtr foreignPixels
       (\pixels -> do
          let pixelData = GL.PixelData GL.Luminance GL.UnsignedByte pixels
          loop pixelData pixels 0)
    where
      loop pixelData pixels frames = do
               close <- GLFW.windowShouldClose win
               if close
               then return ()
               else do
                   randomizePixels pixels
                   GL.drawPixels imagesize pixelData
                   GLFW.swapBuffers win
                   GLFW.pollEvents
                   time <- GLFW.getTime
                   let fps =
                           case time of
                             Just t  -> show $ (fromIntegral frames) / t
                             Nothing -> "???"
                   GLFW.setWindowTitle win $ "FPS: " ++ fps
                   loop pixelData pixels $ frames + 1

randomizePixels :: F.Ptr GL.GLubyte -> IO ()
randomizePixels ptr = iter 0 numbytes
    where
      iter index range
          | index == range = return ()
          | otherwise = do
        v <- R.randomRIO (0, 1)
        F.pokeElemOff ptr index $ v * 255
        iter (index + 1) range

keyCallback :: GLFW.Window -> GLFW.Key -> Int -> GLFW.KeyState ->
               GLFW.ModifierKeys -> IO ()
keyCallback win key _ action _ =
    case key of
      GLFW.Key'Q -> GLFW.setWindowShouldClose win True
      _          -> return ()
