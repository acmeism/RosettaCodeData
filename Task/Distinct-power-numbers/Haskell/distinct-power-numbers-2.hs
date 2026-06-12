import qualified Data.Set as S

main :: IO ()
main =
  (print . S.elems . S.fromList) $
    (\xs -> [x ^ y | x <- xs, y <- xs]) [2 .. 5]
