import qualified Data.Text as T
import qualified Data.Text.IO as TIO

main :: IO ()
main = TIO.interact $ T.unlines . reverse . T.lines
