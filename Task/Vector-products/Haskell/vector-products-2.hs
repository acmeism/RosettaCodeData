dotProduct
  :: Num a
  => [a] -> [a] -> Either String a
dotProduct xs ys
  | length xs /= length ys =
    Left "Dot product not defined - vectors differ in dimension."
  | otherwise = Right (sum $ zipWith (*) xs ys)

crossProduct
  :: Num a
  => [a] -> [a] -> Either String [a]
crossProduct xs ys
  | 3 /= length xs || 3 /= length ys =
    Left "crossProduct is defined only for 3d vectors."
  | otherwise = Right [x2 * y3 - x3 * y2, x3 * y1 - x1 * y3, x1 * y2 - x2 * y1]
  where
    [x1, x2, x3] = xs
    [y1, y2, y3] = ys

scalarTriple
  :: Num a
  => [a] -> [a] -> [a] -> Either String a
scalarTriple q r s = crossProduct r s >>= dotProduct q

vectorTriple
  :: Num a
  => [a] -> [a] -> [a] -> Either String [a]
vectorTriple q r s = crossProduct r s >>= crossProduct q

-- TEST ---------------------------------------------------
a = [3, 4, 5]

b = [4, 3, 5]

c = [-5, -12, -13]

d = [3, 4, 5, 6]

main :: IO ()
main =
  mapM_ putStrLn $
  zipWith
    (++)
    ["a . b", "a x b", "a . b x c", "a x b x c", "a . d", "a . (b x d)"]
    [ sh $ dotProduct a b
    , sh $ crossProduct a b
    , sh $ scalarTriple a b c
    , sh $ vectorTriple a b c
    , sh $ dotProduct a d
    , sh $ scalarTriple a b d
    ]

sh
  :: Show a
  => Either String a -> String
sh = either (" => " ++) ((" = " ++) . show)
