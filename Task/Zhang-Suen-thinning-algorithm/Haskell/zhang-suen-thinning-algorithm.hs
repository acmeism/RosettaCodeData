import Data.Array
import qualified Data.List as List

data BW = Black | White
        deriving (Eq, Show)

type Index = (Int, Int)
type BWArray = Array Index BW

toBW :: Char -> BW
toBW '0' = White
toBW '1' = Black
toBW ' ' = White
toBW '#' = Black
toBW _   = error "toBW: illegal char"

toBWArray :: [String] -> BWArray
toBWArray strings = arr
  where
    height = length strings
    width  = minimum $ map length strings
    arr    = listArray ((0, 0), (width - 1, height - 1))
             . map toBW . concat . List.transpose $ map (take width) strings

toChar :: BW -> Char
toChar White = ' '
toChar Black = '#'

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : (chunksOf n $ drop n xs)

showBWArray :: BWArray -> String
showBWArray arr =
  List.intercalate "\n" . List.transpose
  . chunksOf (height + 1) . map toChar $ elems arr
  where
    (_, (_, height)) = bounds arr

add :: Num a => (a, a) -> (a, a) -> (a, a)
add (a, b) (x, y) = (a + x, b + y)

within :: Ord a => ((a, a), (a, a)) -> (a, a) -> Bool
within ((a, b), (c, d)) (x, y) =
  a <= x && x <= c &&
  b <= y && y <= d

p2, p3, p4, p5, p6, p7, p8, p9 :: Index
p2 = ( 0, -1)
p3 = ( 1, -1)
p4 = ( 1,  0)
p5 = ( 1,  1)
p6 = ( 0,  1)
p7 = (-1,  1)
p8 = (-1,  0)
p9 = (-1, -1)

ixamap :: Ix i => ((i, a) -> b) -> Array i a -> Array i b
ixamap f a = listArray (bounds a) $ map f $ assocs a

thin :: BWArray -> BWArray
thin arr =
  if pass2 == arr then pass2 else thin pass2
  where
    (low, high)     = bounds arr
    lowB            = low `add` (1, 1)
    highB           = high `add` (-1, -1)
    isInner         = within (lowB, highB)
    offs p          = map (add p) [p2, p3, p4, p5, p6, p7, p8, p9]
    trans c (a, b)  = if a == White && b == Black then c + 1 else c
    zipshift xs     = zip xs (drop 1 xs ++ xs)
    transitions a   = (== (1 :: Int)) . foldl trans 0 . zipshift . map (a !) . offs
    within2to6 n    = 2 <= n && n <= 6
    blacks a p      = within2to6 . length . filter ((== Black) . (a !)) $ offs p
    oneWhite xs a p = any ((== White) . (a !) . add p) xs
    oneRight        = oneWhite [p2, p4, p6]
    oneDown         = oneWhite [p4, p6, p8]
    oneUp           = oneWhite [p2, p4, p8]
    oneLeft         = oneWhite [p2, p6, p8]
    precond a p     = (a ! p == Black) && isInner p && blacks a p && transitions a p
    stage1 a p      = precond a p && oneRight a p && oneDown a p
    stage2 a p      = precond a p && oneUp a p && oneLeft a p
    stager f (p, d) = if f p then White else d
    pass1           = ixamap (stager $ stage1 arr) arr
    pass2           = ixamap (stager $ stage2 pass1) pass1

sampleExA :: [String]
sampleExA =
  ["00000000000000000000000000000000"
  ,"01111111110000000111111110000000"
  ,"01110001111000001111001111000000"
  ,"01110000111000001110000111000000"
  ,"01110001111000001110000000000000"
  ,"01111111110000001110000000000000"
  ,"01110111100000001110000111000000"
  ,"01110011110011101111001111011100"
  ,"01110001111011100111111110011100"
  ,"00000000000000000000000000000000"]

sampleExB :: [String]
sampleExB =
  ["                                                          "
  ," #################                   #############        "
  ," ##################               ################        "
  ," ###################            ##################        "
  ," ########     #######          ###################        "
  ,"   ######     #######         #######       ######        "
  ,"   ######     #######        #######                      "
  ,"   #################         #######                      "
  ,"   ################          #######                      "
  ,"   #################         #######                      "
  ,"   ######     #######        #######                      "
  ,"   ######     #######        #######                      "
  ,"   ######     #######         #######       ######        "
  ," ########     #######          ###################        "
  ," ########     ####### ######    ################## ###### "
  ," ########     ####### ######      ################ ###### "
  ," ########     ####### ######         ############# ###### "
  ,"                                                          "]

main :: IO ()
main = mapM_ (putStrLn . showBWArray . thin . toBWArray) [sampleExA, sampleExB]
