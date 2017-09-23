import Data.List (permutations, intercalate)

solution :: [Int]
solution@(a:b:c:d:e:f:g:h:_) = head $ filter isSolution (permutations [1 .. 8])
  where
    isSolution :: [Int] -> Bool
    isSolution (a:b:c:d:e:f:g:h:_) =
      all
        ((> 1) . abs)
        [ a - d
        , c - d
        , g - d
        , e - d
        , a - c
        , c - g
        , g - e
        , e - a
        , b - e
        , d - e
        , h - e
        , f - e
        , b - d
        , d - h
        , h - f
        , f - b
        ]

main :: IO ()
main =
  mapM_ putStrLn $
  let rightShift s
        | length s > 3 = s
        | otherwise = "  " ++ s
  in intercalate
       "\n"
       (zipWith ((. ((" = " ++) . show)) . (:)) ['A' .. 'H'] solution) :
     ((rightShift . unwords . (show <$>)) <$> [[], [a, b], [c, d, e, f], [g, h]])
