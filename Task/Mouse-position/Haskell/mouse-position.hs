import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core

main :: IO ()
main = do
    startGUI defaultConfig setup         -- Start the Threepenny server

setup :: Window -> UI ()
setup window = do
    -- Set the window title
    pure window # set UI.title "Cursor Position Example"

    -- Create a display area
    displayArea <- UI.div # set UI.style [("width", "100%"), ("height", "100vh"), ("background", "#f0f0f0")]
    getBody window #+ [element displayArea]

    -- Event listener for mouse movements
    on UI.mousemove displayArea $ \(x, y) -> do
        -- This prints in terminal where threepenny-gui server was started, NOT in browser console
        liftIO $ putStrLn $ "Mouse cursor position relative to window: (" ++ show x ++ ", " ++ show y ++ ")"
