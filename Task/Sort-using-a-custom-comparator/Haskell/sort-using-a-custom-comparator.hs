import Data.Ord (comparing)
import Data.Char (toLower)
import Data.List (sortBy)

lengthThenAZ :: String -> String -> Ordering
lengthThenAZ = comparing length `mappend` comparing (fmap toLower)

descLengthThenAZ :: String -> String -> Ordering
descLengthThenAZ = flip (comparing length) `mappend` comparing (fmap toLower)

main :: IO ()
main =
  mapM_
    putStrLn
    (fmap
       unlines
       ([sortBy] <*> [lengthThenAZ, descLengthThenAZ] <*>
        [["Here", "are", "some", "sample", "strings", "to", "be", "sorted"]]))
