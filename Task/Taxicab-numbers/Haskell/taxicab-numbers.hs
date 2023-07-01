import Data.List (groupBy, sortOn, tails, transpose)
import Data.Function (on)

--------------------- TAXICAB NUMBERS --------------------

taxis :: Int -> [[(Int, ((Int, Int), (Int, Int)))]]
taxis nCubes =
  filter ((> 1) . length) $
  groupBy (on (==) fst) $
  sortOn fst
    [ (fst x + fst y, (x, y))
    | (x:t) <- tails $ ((^ 3) >>= (,)) <$> [1 .. nCubes]
    , y <- t ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
  concat <$>
  transpose
    (((<$>) =<< flip justifyRight ' ' . maximum . (length <$>)) <$>
     transpose (taxiRow <$> (take 25 xs <> take 7 (drop 1999 xs))))
  where
    xs = zip [1 ..] (taxis 1200)
    justifyRight n c = (drop . length) <*> (replicate n c <>)

------------------------- DISPLAY ------------------------
taxiRow :: (Int, [(Int, ((Int, Int), (Int, Int)))]) -> [String]
taxiRow (n, [(a, ((axc, axr), (ayc, ayr))), (b, ((bxc, bxr), (byc, byr)))]) =
  concat
    [ [show n, ". ", show a, " = "]
    , term axr axc " + "
    , term ayr ayc "  or  "
    , term bxr bxc " + "
    , term byr byc []
    ]
  where
    term r c l = ["(", show r, "^3=", show c, ")", l]
