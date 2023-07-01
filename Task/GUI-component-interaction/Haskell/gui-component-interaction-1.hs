import Graphics.UI.WX
import System.Random

main :: IO ()
main = start $ do
    frm   <- frame [text := "Interact"]
    fld   <- textEntry frm [text := "0", on keyboard := checkKeys]
    inc   <- button frm [text := "increment", on command := increment fld]
    ran   <- button frm [text := "random", on command := (randReplace fld frm)]
    set frm [layout := margin 5 $ floatCentre $ column 2
            [centre $ widget fld, row 2 [widget inc, widget ran]]]

increment :: Textual w => w -> IO ()
increment field = do
    val <- get field text
    when ((not . null) val) $ set field [text := show $ 1 + read val]

checkKeys :: EventKey -> IO ()
checkKeys (EventKey key _ _) =
    when (elem (show key) $ "Backspace" : map show [0..9]) propagateEvent

randReplace :: Textual w => w -> Window a -> IO ()
randReplace field frame = do
    answer <- confirmDialog frame "Random" "Generate a random number?" True
    when answer $ getStdRandom (randomR (1,100)) >>= \num ->
                  set field [text := show (num :: Int)]
