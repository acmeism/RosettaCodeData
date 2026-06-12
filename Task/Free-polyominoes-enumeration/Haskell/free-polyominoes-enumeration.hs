import System.Environment (getArgs)
import Control.Arrow ((***), first)
import Data.Set (toList, fromList)
import Data.List (sort)
import Data.Bool (bool)

type Coord = Int

type Point = (Coord, Coord)

type Polyomino = [Point]

-- Finds the min x and y coordiate of a Polyomino.
minima :: Polyomino -> Point
minima (p:ps) = foldr (\(x, y) (mx, my) -> (min x mx, min y my)) p ps

translateToOrigin :: Polyomino -> Polyomino
translateToOrigin p =
  let (minx, miny) = minima p
  in (subtract minx *** subtract miny) <$> p

rotate90, rotate180, rotate270, reflect :: Point -> Point
rotate90 = uncurry (flip (,) . negate)

rotate180 = negate *** negate

rotate270 = uncurry (flip ((,) . negate))

reflect = first negate

-- All the plane symmetries of a rectangular region.
rotationsAndReflections :: Polyomino -> [Polyomino]
rotationsAndReflections =
  (<*>)
    (fmap <$>
     [ id
     , rotate90
     , rotate180
     , rotate270
     , reflect
     , rotate90 . reflect
     , rotate180 . reflect
     , rotate270 . reflect
     ]) .
  return

canonical :: Polyomino -> Polyomino
canonical = minimum . map (sort . translateToOrigin) . rotationsAndReflections

unique
  :: (Ord a)
  => [a] -> [a]
unique = toList . fromList

-- All four points in Von Neumann neighborhood.
contiguous :: Point -> [Point]
contiguous (x, y) = [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]

-- Finds all distinct points that can be added to a Polyomino.
newPoints :: Polyomino -> [Point]
newPoints p =
  let notInP = filter (not . flip elem p)
  in unique . notInP . concatMap contiguous $ p

newPolys :: Polyomino -> [Polyomino]
newPolys p = unique . map (canonical . flip (:) p) $ newPoints p

monomino = [(0, 0)]

monominoes = [monomino]

-- Generates polyominoes of rank n recursively.
rank :: Int -> [Polyomino]
rank 0 = []
rank 1 = monominoes
rank n = unique . concatMap newPolys $ rank (n - 1)

-- Generates a textual representation of a Polyomino.
textRepresentation :: Polyomino -> String
textRepresentation p =
  unlines
    [ [ bool ' ' '#' ((x, y) `elem` p)
      | x <- [0 .. maxx - minx] ]
    | y <- [0 .. maxy - miny] ]
  where
    maxima :: Polyomino -> Point
    maxima (p:ps) = foldr (\(x, y) (mx, my) -> (max x mx, max y my)) p ps
    (minx, miny) = minima p
    (maxx, maxy) = maxima p

main :: IO ()
main = do
  print $ map (length . rank) [1 .. 10]
  args <- getArgs
  let n = bool (read $ head args :: Int) 5 (null args)
  putStrLn ("\nAll free polyominoes of rank " ++ show n ++ ":")
  mapM_ (putStrLn . textRepresentation) (rank n)
