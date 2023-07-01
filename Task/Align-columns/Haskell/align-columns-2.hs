import Prelude as P
import Data.Text as T
       (Text, pack, unpack, splitOn, unlines, unwords, length,
        justifyLeft, justifyRight, center)
import Data.List (transpose, zip, maximumBy)
import Data.Ord (comparing)

rows :: [[Text]]
rows =
  (splitOn (pack "$") . pack) <$>
  [ "Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
  , "are$delineated$by$a$single$'dollar'$character,$write$a$program"
  , "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
  , "column$are$separated$by$at$least$one$space."
  , "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
  , "justified,$right$justified,$or$center$justified$within$its$column."
  ]

cols :: [[Text]]
cols =
  transpose $
  ((++) <*>
   (flip P.replicate (pack []) .
    (-) (maximum (P.length <$> rows)) . P.length)) <$>
  rows

main :: IO ()
main =
  mapM_ putStrLn $
  [ (\cols f ->
        (unpack . T.unlines) $
        T.unwords <$> transpose ((\(xs, n) -> f (n + 1) ' ' <$> xs) <$> cols))
      (zip cols ((T.length . maximumBy (comparing T.length)) <$> cols))
  ] <*>
  [justifyLeft, justifyRight, center]
