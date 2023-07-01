import Data.List (group, sort)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primeFactors)

-------------------- ZUMKELLER NUMBERS -------------------

isZumkeller :: Int -> Bool
isZumkeller n =
  let ds = divisors n
      m = sum ds
   in ( even m
          && let half = div m 2
              in elem half ds
                   || ( all (half >=) ds
                          && summable half ds
                      )
      )

summable :: Int -> [Int] -> Bool
summable _ [] = False
summable x xs@(h : t) =
  elem x xs
    || summable (x - h) t
    || summable x t

divisors :: Int -> [Int]
divisors x =
  sort
    ( foldr
        ( flip ((<*>) . fmap (*))
            . scanl (*) 1
        )
        [1]
        (group (primeFactors x))
    )

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    ( \(s, n, xs) ->
        putStrLn $
          s
            <> ( '\n' :
                 tabulated
                   10
                   (take n (filter isZumkeller xs))
               )
    )
    [ ("First 220 Zumkeller numbers:", 220, [1 ..]),
      ("First 40 odd Zumkeller numbers:", 40, [1, 3 ..])
    ]

------------------------- DISPLAY ------------------------
tabulated ::
  Show a =>
  Int ->
  [a] ->
  String
tabulated nCols = go
  where
    go xs =
      let ts = show <$> xs
          w = succ (maximum (length <$> ts))
       in unlines
            ( concat
                <$> chunksOf
                  nCols
                  (justifyRight w ' ' <$> ts)
            )

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
