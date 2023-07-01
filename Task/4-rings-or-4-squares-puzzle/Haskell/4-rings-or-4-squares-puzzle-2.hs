import Data.List (delete, sortBy, (\\))

--------------- 4 RINGS OR 4 SQUARES PUZZLE --------------

type Rings = [(Int, Int, Int, Int, Int, Int, Int)]

rings :: Bool -> [Int] -> Rings
rings u digits =
  ((>>=) <*> (queen u =<< head))
    (sortBy (flip compare) digits)

queen :: Bool -> Int -> [Int] -> Int -> Rings
queen u h ds q = xs >>= leftBishop u q h ts ds
  where
    ts = filter ((<= h) . (q +)) ds
    xs
      | u = delete q ts
      | otherwise = ds

leftBishop ::
  Bool ->
  Int ->
  Int ->
  [Int] ->
  [Int] ->
  Int ->
  Rings
leftBishop u q h ts ds lb
  | lRook <= h = xs >>= rightBishop u q h lb ds lRook
  | otherwise = []
  where
    lRook = lb + q
    xs
      | u = ts \\ [q, lb, lRook]
      | otherwise = ds

rightBishop ::
  Bool ->
  Int ->
  Int ->
  Int ->
  [Int] ->
  Int ->
  Int ->
  Rings
rightBishop u q h lb ds lRook rb
  | (rRook <= h) && (not u || (rRook /= lb)) =
    let ks
          | u = (ds \\ [q, lb, rb, rRook, lRook])
          | otherwise = ds
     in ks
          >>= knights
            u
            (lRook - rRook)
            lRook
            lb
            q
            rb
            rRook
            ks
  | otherwise = []
  where
    rRook = q + rb

knights ::
  Bool ->
  Int ->
  Int ->
  Int ->
  Int ->
  Int ->
  Int ->
  [Int] ->
  Int ->
  Rings
knights u rookDelta lRook lb q rb rRook ks k =
  [ (lRook, k, lb, q, rb, k2, rRook)
    | (k2 `elem` ks)
        && ( not u
               || notElem
                 k2
                 [lRook, k, lb, q, rb, rRook]
           )
  ]
  where
    k2 = k + rookDelta

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let f (k, xs) = putStrLn k >> nl >> mapM_ print xs >> nl
      nl = putStrLn []
  mapM_
    f
    [ ("rings True [1 .. 7]", rings True [1 .. 7]),
      ("rings True [3 .. 9]", rings True [3 .. 9])
    ]
  f
    ( "length (rings False [0 .. 9])",
      [length (rings False [0 .. 9])]
    )
