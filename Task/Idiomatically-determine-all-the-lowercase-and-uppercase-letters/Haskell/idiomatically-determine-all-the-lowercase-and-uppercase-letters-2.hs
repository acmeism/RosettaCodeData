import Control.Monad (join)
import Data.Bifunctor (bimap, second)
import Data.Bool (bool)
import Data.Char (chr, isLower, isPrint, isUpper)
import Data.List (partition)
import Data.List.Split (chunksOf)

----------- ALL LOWERCASE AND UPPERCASE LETTERS ----------

uppersAndLowers :: (String, String)
uppersAndLowers =
  second
    (filter isLower)
    ( partition
        isUpper
        ( ((bool [] . pure) <*> isPrint) . chr
            =<< [1 .. 0x10ffff]
        )
    )

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines . uncurry (<>)) $
    bimap
      ("Upper:" :)
      ("\nLower:" :)
      $ join bimap (chunksOf 70) uppersAndLowers
