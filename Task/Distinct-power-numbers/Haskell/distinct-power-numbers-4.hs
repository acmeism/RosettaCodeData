import qualified Data.Set as S

main :: IO ()
main =
  (print . S.elems . S.fromList) $
      (\xs -> (^) <$> xs <*> xs)
      [2 .. 5]
