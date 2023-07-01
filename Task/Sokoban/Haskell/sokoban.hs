import Control.Monad (liftM)
import Data.Array
import Data.List (transpose)
import Data.Maybe (mapMaybe)
import qualified Data.Sequence as Seq
import qualified Data.Set as Set
import Prelude hiding (Left, Right)

data Field = Space | Wall | Goal
           deriving (Eq)

data Action = Up | Down | Left | Right | PushUp | PushDown | PushLeft | PushRight

instance Show Action where
  show Up        = "u"
  show Down      = "d"
  show Left      = "l"
  show Right     = "r"
  show PushUp    = "U"
  show PushDown  = "D"
  show PushLeft  = "L"
  show PushRight = "R"

type Index = (Int, Int)
type FieldArray = Array Index Field
type BoxArray = Array Index Bool
type PlayerPos = Index
type GameState = (BoxArray, PlayerPos)
type Game = (FieldArray, GameState)

toField :: Char -> Field
toField '#' = Wall
toField ' ' = Space
toField '@' = Space
toField '$' = Space
toField '.' = Goal
toField '+' = Goal
toField '*' = Goal

toPush :: Action -> Action
toPush Up    = PushUp
toPush Down  = PushDown
toPush Left  = PushLeft
toPush Right = PushRight
toPush n     = n

toMove :: Action -> Index
toMove PushUp    = ( 0, -1)
toMove PushDown  = ( 0,  1)
toMove PushLeft  = (-1,  0)
toMove PushRight = ( 1,  0)
toMove n = toMove $ toPush n

-- Parse the string-based game board into an easier-to-use format.
-- Assume that the board is valid (rectangular, one player, etc).
parseGame :: [String] -> Game
parseGame fieldStrs = (field, (boxes, player))
  where
    width     = length $ head fieldStrs
    height    = length fieldStrs
    bound     = ((0, 0), (width - 1, height - 1))
    flatField = concat $ transpose fieldStrs
    charField = listArray bound flatField
    field     = fmap toField charField
    boxes     = fmap (`elem` "$*") charField
    player    = fst $ head $ filter (flip elem "@+" . snd) $ assocs charField

add :: (Num a, Num b) => (a, b) -> (a, b) -> (a, b)
add (a, b) (x, y) = (a + x, b + y)

-- Attempt to perform an action, returning the updated game and adjusted
-- action if the action was legal.
tryAction :: Game -> Action -> Maybe (Game, Action)
tryAction (field, (boxes, player)) action
  | field ! vec == Wall = Nothing
  | boxes ! vec =
     if boxes ! vecB || field ! vecB == Wall
     then Nothing
     else Just ((field, (boxes // [(vec, False), (vecB, True)], vec)),
               toPush action)
  | otherwise = Just ((field, (boxes, vec)), action)
  where
    actionVec = toMove action
    vec       = player `add` actionVec
    vecB      = vec `add` actionVec

-- Search the game for a solution.
solveGame :: Game -> Maybe [Action]
solveGame (field, initState) =
  liftM reverse $ bfs (Seq.singleton (initState, [])) (Set.singleton initState)
  where
    goals           = map fst $ filter ((== Goal) . snd) $ assocs field
    isSolved st     = all (st !) goals
    possibleActions = [Up, Down, Left, Right]

    -- Breadth First Search of the game tree.
    bfs :: Seq.Seq (GameState, [Action]) -> Set.Set GameState -> Maybe [Action]
    bfs queue visited =
      case Seq.viewl queue of
        Seq.EmptyL -> Nothing
        (game@(boxes, _), actions) Seq.:< queueB ->
          if isSolved boxes
          then Just actions
          else
            let newMoves = filter (flip Set.notMember visited . fst) $
                           map (\((_, g), a) -> (g, a)) $
                           mapMaybe (tryAction (field, game)) possibleActions
                visitedB = foldl (flip Set.insert) visited $
                           map fst newMoves
                queueC   = foldl (Seq.|>) queueB $
                           map (\(g, a) -> (g, a:actions)) newMoves
            in bfs queueC visitedB

exampleA :: [String]
exampleA =
  ["#######"
  ,"#     #"
  ,"#     #"
  ,"#. #  #"
  ,"#. $$ #"
  ,"#.$$  #"
  ,"#.#  @#"
  ,"#######"]

main :: IO ()
main =
  case solveGame $ parseGame exampleA of
    Nothing       -> putStrLn "Unsolvable"
    Just solution -> do
      mapM_ putStrLn exampleA
      putStrLn ""
      putStrLn $ concatMap show solution
