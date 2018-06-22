import qualified Graphics.UI.GLFW as GLFW -- cabal install GLFW-b
import Graphics.Win32.Key
import Control.Monad.RWS.Strict  (liftIO)

main = do
    liftIO $ do
          _ <- GLFW.init
          GLFW.pollEvents
          (jxrot, jyrot) <- liftIO $ getJoystickDirections GLFW.Joystick'1
          putStrLn $ (show jxrot) ++ " " ++ (show jyrot)
          w <- getAsyncKeyState 27 -- ESC pressed?
          if (w<1) then main else do
                     GLFW.terminate
                     return ()

getJoystickDirections :: GLFW.Joystick -> IO (Double, Double)

getJoystickDirections js = do
    maxes <- GLFW.getJoystickAxes js
    return $ case maxes of
      (Just (x:y:_)) -> (-y, x)
      _ -> ( 0, 0)
