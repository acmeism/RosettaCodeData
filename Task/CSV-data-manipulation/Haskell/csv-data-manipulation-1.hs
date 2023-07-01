import Data.Array (Array(..), (//), bounds, elems, listArray)
import Data.List (intercalate)
import Control.Monad (when)
import Data.Maybe (isJust)

delimiters :: String
delimiters = ",;:"

fields :: String -> [String]
fields [] = []
fields xs =
  let (item, rest) = break (`elem` delimiters) xs
      (_, next) = break (`notElem` delimiters) rest
  in item : fields next

unfields :: Maybe (Array (Int, Int) String) -> [String]
unfields Nothing = []
unfields (Just a) = every fieldNumber $ elems a
  where
    ((_, _), (_, fieldNumber)) = bounds a
    every _ [] = []
    every n xs =
      let (y, z) = splitAt n xs
      in intercalate "," y : every n z

fieldArray :: [[String]] -> Maybe (Array (Int, Int) String)
fieldArray [] = Nothing
fieldArray xs =
  Just $ listArray ((1, 1), (length xs, length $ head xs)) $ concat xs

fieldsFromFile :: FilePath -> IO (Maybe (Array (Int, Int) String))
fieldsFromFile = fmap (fieldArray . map fields . lines) . readFile

fieldsToFile :: FilePath -> Maybe (Array (Int, Int) String) -> IO ()
fieldsToFile f = writeFile f . unlines . unfields

someChanges :: Maybe (Array (Int, Int) String)
            -> Maybe (Array (Int, Int) String)
someChanges =
  fmap (// [((1, 1), "changed"), ((3, 4), "altered"), ((5, 2), "modified")])

main :: IO ()
main = do
  a <- fieldsFromFile "example.txt"
  when (isJust a) $ fieldsToFile "output.txt" $ someChanges a
