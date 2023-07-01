import CLPFD
import Constraint (andC, anyC)
import Findall (unpack)
import Integer (abs)


hidato :: [[Int]] -> Success
hidato path =
    test path inner
  & domain inner 1 40
  & allDifferent inner
  & andFD [x `near` y | x <- cells, y <- cells]
  & labeling [] (concat path)
  where
    andFD = solve . foldr1 (#/\#)
    cells = enumerate path
    inner free

near :: (Int,Int,Int) -> (Int,Int,Int) -> Constraint
(x,rx,cx) `near` (y,ry,cy) =  x #<=# y  #/\#  dist (y -# x)
                        #\/#  x #>#  y  #/\#  dist (x -# y)
                        #\/#  x #=#  0
                        #\/#  y #=#  0
  where
    dist d =  abs (rx - ry) #<=# d
        #/\#  abs (cx - cy) #<=# d

enumerate :: [[Int]] -> [(Int,Int,Int)]
enumerate xss = [(x,row,col) | (xs,row) <- xss `zip` [1..]
                             , (x ,col) <- xs  `zip` [1..]
                ]

test [[ 0,  0,  0,  0,  0,  0,  0, 0, 0, 0]
     ,[ 0,  A, 33, 35,  B,  C,  0, 0, 0, 0]
     ,[ 0,  D,  E, 24, 22,  F,  0, 0, 0, 0]
     ,[ 0,  G,  H,  I, 21,  J,  K, 0, 0, 0]
     ,[ 0,  L, 26,  M, 13, 40, 11, 0, 0, 0]
     ,[ 0, 27,  N,  O,  P,  9,  Q, 1, 0, 0]
     ,[ 0,  0,  0,  R,  S, 18,  T, U, 0, 0]
     ,[ 0,  0,  0,  0,  0,  V,  7, W, X, 0]
     ,[ 0,  0,  0,  0,  0,  0,  0, 5, Y, 0]
     ,[ 0,  0,  0,  0,  0,  0,  0, 0, 0, 0]
     ]
     [ A, 33, 35,  B,  C
     , D,  E, 24, 22,  F
        , G,  H,  I, 21,  J,  K
        , L, 26,  M, 13, 40, 11
           , 27,  N,  O,  P,  9, Q, 1
           ,  R,  S, 18,  T,  U
               ,  V,  7,  W,  X
                       ,  5,  Y
     ] = success

main = unpack hidato
