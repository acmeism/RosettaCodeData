import Data.Array
       (Array, (//), (!), assocs, elems, bounds, listArray)
import Data.Foldable (forM_)
import Data.List (intercalate, transpose)
import Data.Maybe

type Position = (Int, Int)

type KnightBoard = Array Position (Maybe Int)

toSlot :: Char -> Maybe Int
toSlot '0' = Just 0
toSlot '1' = Just 1
toSlot _ = Nothing

toString :: Maybe Int -> String
toString Nothing = replicate 3 ' '
toString (Just n) = replicate (3 - length nn) ' ' ++ nn
  where
    nn = show n

chunksOf :: Int -> [a] -> [[a]]
chunksOf _ [] = []
chunksOf n xs =
  let (chunk, rest) = splitAt n xs
  in chunk : chunksOf n rest

showBoard :: KnightBoard -> String
showBoard board =
  intercalate "\n" . map concat . transpose . chunksOf (height + 1) . map toString $
  elems board
  where
    (_, (_, height)) = bounds board

toBoard :: [String] -> KnightBoard
toBoard strs = board
  where
    height = length strs
    width = minimum (length <$> strs)
    board =
      listArray ((0, 0), (width - 1, height - 1)) . map toSlot . concat . transpose $
      take width <$> strs

add
  :: Num a
  => (a, a) -> (a, a) -> (a, a)
add (a, b) (x, y) = (a + x, b + y)

within
  :: Ord a
  => ((a, a), (a, a)) -> (a, a) -> Bool
within ((a, b), (c, d)) (x, y) = a <= x && x <= c && b <= y && y <= d

-- Enumerate valid moves given a board and a knight's position.
validMoves :: KnightBoard -> Position -> [Position]
validMoves board position = filter isValid plausible
  where
    bound = bounds board
    plausible =
      add position <$>
      [(1, 2), (2, 1), (2, -1), (-1, 2), (-2, 1), (1, -2), (-1, -2), (-2, -1)]
    isValid pos = within bound pos && maybe False (== 0) (board ! pos)

isSolved :: KnightBoard -> Bool
isSolved = all (maybe True (0 /=))

-- Solve the knight's tour with a simple Depth First Search.
solveKnightTour :: KnightBoard -> Maybe KnightBoard
solveKnightTour board = solve board 1 initPosition
  where
    initPosition = fst $ head $ filter ((== Just 1) . snd) $ assocs board
    solve boardA depth position =
      let boardB = boardA // [(position, Just depth)]
      in if isSolved boardB
           then Just boardB
           else listToMaybe $
                mapMaybe (solve boardB $ depth + 1) $ validMoves boardB position

tourExA :: [String]
tourExA =
  [ " 000    "
  , " 0 00   "
  , " 0000000"
  , "000  0 0"
  , "0 0  000"
  , "1000000 "
  , "  00 0  "
  , "   000  "
  ]

tourExB :: [String]
tourExB =
  [ "-----1-0-----"
  , "-----0-0-----"
  , "----00000----"
  , "-----000-----"
  , "--0--0-0--0--"
  , "00000---00000"
  , "--00-----00--"
  , "00000---00000"
  , "--0--0-0--0--"
  , "-----000-----"
  , "----00000----"
  , "-----0-0-----"
  , "-----0-0-----"
  ]

main :: IO ()
main =
  forM_
    [tourExA, tourExB]
    (\board ->
        case solveKnightTour $ toBoard board of
          Nothing -> putStrLn "No solution.\n"
          Just solution -> putStrLn $ showBoard solution ++ "\n")
