-- 8-queens implementation with the Constrained Constructor pattern
-- Sergio Antoy
-- Fri Jul 13 07:05:32 PDT 2001

-- Place 8 queens on a chessboard so that no queen can capture
-- (and be captured by) any other queen.

-- Non-deterministic choice operator

infixl 0 !
X ! _ = X
_ ! Y = Y

-- A solution is represented by a list of integers.
-- The i-th integer in the list is the column of the board
-- in which the queen in the i-th row is placed.
-- Rows and columns are numbered from 1 to 8.
-- For example, [4,2,7,3,6,8,5,1] is a solution where the
-- the queen in row 1 is in column 4, etc.
-- Any solution must be a permutation of [1,2,...,8].

-- The state of a queen is its position, row and column, on the board.
-- Operation column is a particularly simple instance
-- of a Constrained Constructor pattern.
-- When it is invoked, it produces only valid states.

column = 1 ! 2 ! 3 ! 4 ! 5 ! 6 ! 7 ! 8

-- A path of the puzzle is a sequence of successive placements of
-- queens on the board.  It is not explicitly defined as a type.
-- A path is a potential solution in the making.

-- Constrained Constructor on a path
-- Any path must be valid, i.e., any column must be in the range 1..8
-- and different from any other column in the path.
-- Furthermore, the path must be safe for the queens.
-- No queen in a path may capture any other queen in the path.
-- Operation makePath add column n to path c or fails.

makePath c n | valid c && safe c 1 = n:c
    where valid c | n =:= column = uniq c
             where uniq [] = True
                   uniq (c:cs) = n /= c && uniq cs
          safe [] _ = True
          safe (c:cs) k = abs (n-c) /= k && safe cs (k+1)
             where abs x = if x < 0 then -x else x

-- extend the path argument till all the queens are on the board
-- see the Incremental Solution pattern

extend p = if (length p == 8)
             then p
             else extend (makePath p x)
      where x free

-- solve the puzzle

main = extend []
