import Data.Array
import Data.Maybe (isJust)
import Data.List (intercalate)
import Control.Monad (when)

delimiters = ",;:"

fields [] = []
fields xs = let (item, rest) = break (`elem` delimiters) xs
                (_,    next) = break (`notElem` delimiters) rest
    in item : fields next

unfields Nothing = []
unfields (Just a) = every fieldNumber $ elems a
    where
        ((_, _), (_, fieldNumber)) = bounds a
        every _ [] = []
        every n xs = let (y, z) = splitAt n xs
            in intercalate "," y : every n z

fieldArray [] = Nothing
fieldArray xs = Just $ listArray ((1,1), (length xs, length $ head xs))
    $ concat xs

fieldsFromFile = fmap (fieldArray . map fields . lines) . readFile

fieldsToFile f = writeFile f . unlines . unfields

someChanges = fmap  (// [((1,1), "changed"), ((3,4), "altered"),
    ((5,2), "modified")])

main = do
    a <- fieldsFromFile "example.txt"
    when (isJust a) $ fieldsToFile "output.txt" $ someChanges a
