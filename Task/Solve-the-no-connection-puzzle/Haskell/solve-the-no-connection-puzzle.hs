import Data.List (permutations)

solution :: [Int]
solution@(a : b : c : d : e : f : g : h : _) =
  head $
    filter isSolution (permutations [1 .. 8])
  where
    isSolution :: [Int] -> Bool
    isSolution (a : b : c : d : e : f : g : h : _) =
      all ((> 1) . abs) $
        zipWith
          (-)
          [a, c, g, e, a, c, g, e, b, d, h, f, b, d, h, f]
          [d, d, d, d, c, g, e, a, e, e, e, e, d, h, f, b]

main :: IO ()
main =
  (putStrLn . unlines) $
    unlines
      ( zipWith
          (\x y -> x : (" = " <> show y))
          ['A' .. 'H']
          solution
      ) :
    ( rightShift . unwords . fmap show
        <$> [[], [a, b], [c, d, e, f], [g, h]]
    )
  where
    rightShift s
      | length s > 3 = s
      | otherwise = "  " <> s
