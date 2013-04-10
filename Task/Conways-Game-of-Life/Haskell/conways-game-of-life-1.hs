import Data.Array.Unboxed

type Grid = UArray (Int,Int) Bool
 -- The grid is indexed by (y, x).

life :: Int -> Int -> Grid -> Grid
{- Returns the given Grid advanced by one generation. -}
life w h old =
    listArray b (map f (range b))
  where b@((y1,x1),(y2,x2)) = bounds old
        f (y, x) = ( c && (n == 2 || n == 3) ) || ( not c && n == 3 )
          where c = get x y
                n = count [get (x + x') (y + y') |
                    x' <- [-1, 0, 1], y' <- [-1, 0, 1],
                    not (x' == 0 && y' == 0)]

        get x y | x < x1 || x > x2 = False
                | y < y1 || y > y2 = False
                | otherwise       = old ! (y, x)

count :: [Bool] -> Int
count = length . filter id
