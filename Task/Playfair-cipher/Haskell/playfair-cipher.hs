import Control.Monad     (guard)
import Data.Array        (Array, assocs, elems, listArray, (!))
import Data.Char         (toUpper)
import Data.List         (nub, (\\))
import Data.List.Split   (chunksOf)
import Data.Maybe        (listToMaybe)
import Data.String.Utils (replace)

type Square a = Array (Int, Int) a

-- | Turns a list into an n*m-array.
array2D ::
       (Int, Int) -- ^ n * m
    -> [e] -> Square e
array2D maxCoord = listArray ((1, 1), maxCoord)

-- | Generates a playfair table starting with the specified string.
--
-- >>> makeTable "hello"
-- "HELOABCDFGIKMNPQRSTUVWXYZ"
makeTable :: String -> String
makeTable k = nub key ++ (alpha \\ key)
    where
      alpha = ['A' .. 'Z'] \\ "J"
      key = map toUpper =<< words k

-- | Turns a playfair table into a 5*5 alphabet square.
makeSquare :: [a] -> Square a
makeSquare = array2D (5, 5)

-- | Displays a playfair square, formatted as a square.
showSquare :: Square Char -> String
showSquare d = unlines $ chunksOf 5 (elems d)

-- | Given a value and an association list of x-coordinate * y-coordinate * value, returns the coordinates
getIndex' :: (Eq a) => a -> [((Int, Int), a)] -> Maybe (Int, Int)
getIndex' el = fmap fst . listToMaybe . filter ((== el) . snd)

encodePair, decodePair :: Eq a => Square a -> (a, a) -> Maybe (a, a)
encodePair = pairHelper (\x -> if x == 5 then 1 else x + 1)
decodePair = pairHelper (\x -> if x == 1 then 5 else x - 1)

pairHelper :: (Eq t)
    => (Int -> Int) -- ^ a function used for wrapping around the square
    -> Square t -- ^ a playfair square
    -> (t, t) -- ^ two characters
    -> Maybe (t, t) -- ^ the two resulting/encoded characters
pairHelper adjust sqr (c1, c2) =
    do let ps = assocs sqr
       -- assigns an association list of (x-coord * y-coord) * value to ps
       (x1, y1) <- getIndex' c1 ps
       (x2, y2) <- getIndex' c2 ps
       -- returns the coordinates of two values in the square
       -- these will later be swapped
       guard $ c1 /= c2
       -- the characters (and coordinates) cannot be the same
       let get x = sqr ! x
       -- a small utility function for extracting a value from the square
       Just $
           -- wrap the coordinates around and find the encrypted characters
           case () of
             () | y1 == y2 ->
                    (get (adjust x1, y1), get (adjust x2, y2))
                | x1 == x2 ->
                    (get (x1, adjust y1), get (x2, adjust y2))
                | otherwise ->
                    (get (x1, y2), get (x2, y1))

-- | Turns two characters into a tuple.
parsePair :: String -> [(Char, Char)]
parsePair = fmap (\[x, y] -> (x, y)) . words . fmap toUpper

-- | Turns a tuple of two characters into a string.
unparsePair :: [(Char, Char)] -> String
unparsePair = unwords . fmap (\(x, y) -> [x, y])

codeHelper :: (Square Char -> (Char, Char) -> Maybe (Char, Char))
    -> String -> String -> Maybe String
codeHelper subs key =
    fmap unparsePair .
    mapM (subs (makeSquare $ makeTable key)) .
    parsePair

playfair, unplayfair :: String -> String -> Maybe String
playfair key = codeHelper encodePair key . formatEncode
unplayfair = codeHelper decodePair

formatEncode :: String -> String
formatEncode =
    map toUpper .
    unwords .
    map (\[x, y] -> if x == y then [x, 'x'] else [x, y]) .
    chunksOf 2 .
    replace "j" "i" .
    concatMap adjustLength .
    words .
    filter (\n -> n `elem` (['A'..'Z'] ++ ['a'..'z']))
    where
      adjustLength str
          | odd (length str) = str ++ "x"
          | otherwise = str
