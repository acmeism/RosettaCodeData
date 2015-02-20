import Control.Monad.ST
import qualified Data.Array.Base as AB
import qualified Data.Array.ST as AST
import qualified Data.Array.Unboxed as AU
import qualified Data.List as List

type Position = (Int, Int)
type KnightBoard = AU.UArray Position Int

toSlot :: Char -> Int
toSlot '0' = 0
toSlot '1' = 1
toSlot _   = -1

toString :: Int -> String
toString (-1) = replicate 3 ' '
toString n    = replicate (3 - length nn) ' ' ++ nn
  where
    nn = show n

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs = take n xs : (chunksOf n $ drop n xs)

showBoard :: KnightBoard -> String
showBoard board =
  List.intercalate "\n" . map concat . List.transpose
  . chunksOf (height + 1) . map toString $ AU.elems board
  where
    (_, (_, height)) = AU.bounds board

toBoard :: [String] -> KnightBoard
toBoard strs = board
  where
    height = length strs
    width  = minimum $ map length strs
    board  = AU.listArray ((0, 0), (width - 1, height - 1))
             . map toSlot . concat . List.transpose $ map (take width) strs

add :: Num a => (a, a) -> (a, a) -> (a, a)
add (a, b) (x, y) = (a + x, b + y)

within :: Ord a => ((a, a), (a, a)) -> (a, a) -> Bool
within ((a, b), (c, d)) (x, y) =
  a <= x && x <= c &&
  b <= y && y <= d

-- Solve the knight's tour with a simple Depth First Search.
solveKnightTour :: KnightBoard -> Maybe KnightBoard
solveKnightTour board =
  runST $ do
    let
      assocs = AU.assocs board
      bounds = AU.bounds board

    array <- (AST.newListArray bounds (AU.elems board))
             :: ST s (AST.STUArray s Position Int)

    let
      initPosition = fst $ head $ filter ((== 1) . snd) assocs
      maxDepth     = fromIntegral $ 1 + (length $ filter ((== 0) . snd) assocs)
      offsets      =
          [(1, 2), (2, 1), (2, -1), (-1, 2),
           (-2, 1), (1, -2), (-1, -2), (-2, -1)]

      solve depth position = do
        if within bounds position
        then do
          oldValue <- AST.readArray array position
          if oldValue == 0
          then do
            AST.writeArray array position depth
            if depth == maxDepth
            then return True
            else do
              -- This mapM-any combo can be reduced to a string of ||'s
              -- with the goal of removing the allocation overhead due to consing
              -- which the compiler may not be able to optimize out.
              results <- mapM ((solve $ depth + 1) . add position) offsets
              if any (== True) results
              then return True
              else do
                AST.writeArray array position oldValue
                return False
          else return False
        else return False

    AST.writeArray array initPosition 0
    result <- solve 1 initPosition
    farray <- AB.unsafeFreeze array
    return $ if result
      then Just farray
      else Nothing

tourExA :: [String]
tourExA =
  [" 000    "
  ," 0 00   "
  ," 0000000"
  ,"000  0 0"
  ,"0 0  000"
  ,"1000000 "
  ,"  00 0  "
  ,"   000  "]

tourExB :: [String]
tourExB =
  ["-----1-0-----"
  ,"-----0-0-----"
  ,"----00000----"
  ,"-----000-----"
  ,"--0--0-0--0--"
  ,"00000---00000"
  ,"--00-----00--"
  ,"00000---00000"
  ,"--0--0-0--0--"
  ,"-----000-----"
  ,"----00000----"
  ,"-----0-0-----"
  ,"-----0-0-----"]

main :: IO ()
main =
  flip mapM_ [tourExA, tourExB]
  (\board ->
    case solveKnightTour $ toBoard board of
    Nothing       -> putStrLn "No solution.\n"
    Just solution -> putStrLn $ showBoard solution ++ "\n")
