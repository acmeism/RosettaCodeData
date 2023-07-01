import Data.List (findIndex, isPrefixOf, tails)
import Data.Maybe (fromJust)

----------------------- EKG SEQUENCE ---------------------

seqEKGRec :: Int -> Int -> [Int] -> [Int]
seqEKGRec _ 0 l = l
seqEKGRec k n [] = seqEKGRec k (n - 2) [k, 1]
seqEKGRec k n l@(h : t) =
  seqEKGRec
    k
    (pred n)
    ( head
        ( filter
            (((&&) . flip notElem l) <*> ((1 <) . gcd h))
            [2 ..]
        ) :
      l
    )

seqEKG :: Int -> Int -> [Int]
seqEKG k n = reverse (seqEKGRec k n [])


--------------------- CONVERGENCE TEST -------------------
main :: IO ()
main =
  mapM_
    ( \x ->
        putStr "EKG ("
          >> (putStr . show $ x)
          >> putStr ") is "
          >> print (seqEKG x 20)
    )
    [2, 5, 7, 9, 10]
    >> putStr "EKG(5) and EKG(7) converge at "
    >> print
      ( succ $
          fromJust $
            findIndex
              (isPrefixOf (replicate 20 True))
              ( tails
                  ( zipWith
                      (==)
                      (seqEKG 7 80)
                      (seqEKG 5 80)
                  )
              )
      )
