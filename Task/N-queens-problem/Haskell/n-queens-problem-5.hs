import Control.Monad
import System.Environment

-- | data types for the puzzle
type Row    = Int
type State  = [Row]
type Thread = [Row]

-- | utility functions
empty = null

-- | Check for infeasible states
infeasible :: Int -> (State, Thread) -> Bool
infeasible n ([], _)    = False
infeasible n ((r:rs),t) = length rs >= n || attack r rs || infeasible n (rs, t)

feasible n st = not $ infeasible n st

-- | Check if a row is attacking another row of a state
attack :: Row -> [Row] -> Bool
attack r rs = r `elem` rs
            || r `elem` (upperDiag rs)
            || r `elem` (lowerDiag rs)
  where
    upperDiag xs = zipWith (-) xs [1..]
    lowerDiag xs = zipWith (+) xs [1..]

-- | Check if it is a goal state
isGoal :: Int -> (State, Thread) -> Bool
isGoal n (rs,t) = (feasible n (rs,t)) && (length rs == n)

-- | Perform a move
move :: Int -> (State, Thread) -> (State, Thread)
move x (s,t)  = (x:s, x:t)

choices n = [1..n]
moves n   = pure move <*> choices n

emptySt = ([],[])

-- | Breadth-first search
bfs :: Int -> [(State, Thread)] -> (State, Thread)
bfs n []                     = error "Could not find a feasible solution"
bfs n sts | (not.empty) goal = head goal
          | otherwise        = bfs n sts2
  where
    goal = filter (isGoal n) sts2
    sts2 = filter (feasible n) $ (moves n) <*> sts

-- | Depth-first search
dfs :: Int -> (State, Thread) -> [(State, Thread)]
dfs n st | isGoal n st     = [st]
         | infeasible n st = [emptySt]
         | otherwise       = do x   <- [1..n]
                                st2 <- dfs n $ move x st
                                guard $ st2 /= emptySt
                                return st2

main = do
  [narg] <- getArgs
  let n = read narg :: Int
  print (bfs n [emptySt])
  print (head $ dfs n emptySt)
