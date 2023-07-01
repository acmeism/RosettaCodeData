import CLPFD
import Constraint (allC)
import List (transpose)


sudoku :: [[Int]] -> Success
sudoku rows =
    domain (concat rows) 1 9
  & different rows
  & different (transpose rows)
  & different blocks
  & labeling [] (concat rows)
  where
    different = allC allDifferent

    blocks = [concat ys | xs <- each3 rows
                        , ys <- transpose $ map each3 xs
             ]
    each3 xs = case xs of
        (x:y:z:rest) -> [x,y,z] : each3 rest
        rest         -> [rest]


test = [ [_,_,3,_,_,_,_,_,_]
       , [4,_,_,_,8,_,_,3,6]
       , [_,_,8,_,_,_,1,_,_]
       , [_,4,_,_,6,_,_,7,3]
       , [_,_,_,9,_,_,_,_,_]
       , [_,_,_,_,_,2,_,_,5]
       , [_,_,4,_,7,_,_,6,8]
       , [6,_,_,_,_,_,_,_,_]
       , [7,_,_,6,_,_,5,_,_]
       ]
main | sudoku xs = xs where xs = test
