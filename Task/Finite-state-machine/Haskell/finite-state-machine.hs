import System.Exit
import Data.Maybe
import Control.Monad
import Data.List
import System.IO

type Name = String
type Sequence = String
type State = String

data Trigger = Trigger { name :: Name
                       , tseq :: Sequence } deriving (Eq)

instance Show Trigger where
  show (Trigger name tseq) = name ++ "(" ++ tseq ++ ")"

data Transition = Implicit { start :: State
                            , end :: State }
                | Explicit { start :: State
                           , trigger :: Trigger
                           , end :: State }

findEndState :: Sequence -> [(Trigger, State)] -> Maybe State
findEndState sequence lst = if (isJust pair)
                               then snd <$> pair
                               else Nothing
  where
    pair = find (\t -> (tseq . fst) t == sequence) lst

findRelevantTransitions :: State -> [Transition] -> [Transition]
findRelevantTransitions state transitions = filter (\t -> state == start t) transitions

findImplicitTransition :: [Transition] -> Maybe Transition
findImplicitTransition [] = Nothing
findImplicitTransition (transition@(Implicit _ _):xs) = Just transition
findImplicitTransition (x:xs) = findImplicitTransition xs

runFSM :: State -> [Transition] -> [State] -> IO ()
runFSM state transitions finishStates = do
  putStrLn $ "State: " ++ state
  when (state `elem` finishStates) $ do
    putStrLn "Exiting.."
    exitWith ExitSuccess
  let relTransitions = findRelevantTransitions state transitions
  let implTransition = findImplicitTransition relTransitions
  when (isJust implTransition) $ do
    putStrLn "Implicit transition"
    runFSM (end $ fromJust implTransition) transitions finishStates
  let triggers = map (\t -> (trigger t, end t)) relTransitions
  handleExplicitTransition triggers
    where handleExplicitTransition triggers = do
          let prompt = (intercalate " or " (map (show . fst) triggers)) ++ ":"
          putStr prompt
          resp <- getLine
          let endState = findEndState resp triggers
          case endState of
            (Just e) -> runFSM e transitions finishStates
            Nothing -> putStrLn "invalid input" >> handleExplicitTransition triggers

main = do
  hSetBuffering stdout $ BlockBuffering $ Just 1
  runFSM initialState transitions finishStates

initialState = "Ready"
transitions = [ Explicit "Ready" (Trigger "Deposit" "d") "Waiting"
              , Explicit "Ready" (Trigger "Quit" "q") "Exit"
              , Explicit "Waiting" (Trigger "Select" "s") "Dispense"
              , Explicit "Waiting" (Trigger "Refund" "r") "Refunding"
              , Explicit "Dispense" (Trigger "Remove" "rm") "Ready"
              , Implicit "Refunding" "Ready" ]
finishStates = ["Exit"]
