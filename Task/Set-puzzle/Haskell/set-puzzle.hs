import Control.Monad.State
       (State, evalState, replicateM, runState, state)
import System.Random (StdGen, newStdGen, randomR)
import Data.List (find, nub, sort)

combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations _ [] = []
combinations k (y:ys) = map (y :) (combinations (k - 1) ys) ++ combinations k ys

data Color
  = Red
  | Green
  | Purple
  deriving (Show, Enum, Bounded, Ord, Eq)

data Symbol
  = Oval
  | Squiggle
  | Diamond
  deriving (Show, Enum, Bounded, Ord, Eq)

data Count
  = One
  | Two
  | Three
  deriving (Show, Enum, Bounded, Ord, Eq)

data Shading
  = Solid
  | Open
  | Striped
  deriving (Show, Enum, Bounded, Ord, Eq)

data Card = Card
  { color :: Color
  , symbol :: Symbol
  , count :: Count
  , shading :: Shading
  } deriving (Show)

-- Identify a set of three cards by counting all attribute types.
-- if each count is 3 or 1 ( not 2 ) the the cards compose a set.
isSet :: [Card] -> Bool
isSet cs =
  let total = length . nub . sort . flip map cs
  in notElem 2 [total color, total symbol, total count, total shading]

-- Get a random card from a deck. Returns the card and removes it from the deck.
getCard :: State (StdGen, [Card]) Card
getCard =
  state $
  \(gen, cs) ->
     let (i, newGen) = randomR (0, length cs - 1) gen
         (a, b) = splitAt i cs
     in (head b, (newGen, a ++ tail b))

-- Get a hand of cards.  Starts with new deck and then removes the
-- appropriate number of cards from that deck.
getHand :: Int -> State StdGen [Card]
getHand n =
  state $
  \gen ->
     let az = [minBound .. maxBound]
         deck =
           [ Card co sy ct sh
           | co <- az
           , sy <- az
           , ct <- az
           , sh <- az ]
         (a, (newGen, _)) = runState (replicateM n getCard) (gen, deck)
     in (a, newGen)

-- Get an unbounded number of hands of the appropriate number of cards.
getManyHands :: Int -> State StdGen [[Card]]
getManyHands n = (sequence . repeat) (getHand n)

-- Deal out hands of the appropriate size until one with the desired number
-- of sets is found.  then print the hand and the sets.
showSolutions :: Int -> Int -> IO ()
showSolutions cardCount solutionCount = do
  putStrLn $
    "Showing hand of " ++
    show cardCount ++ " cards with " ++ show solutionCount ++ " solutions."
  gen <- newStdGen
  let Just z =
        find ((solutionCount ==) . length . filter isSet . combinations 3) $
        evalState (getManyHands cardCount) gen
  mapM_ print z
  putStrLn ""
  putStrLn "Solutions:"
  mapM_ putSet $ filter isSet $ combinations 3 z
  where
    putSet st = do
      mapM_ print st
      putStrLn ""

-- Show a hand of 9 cards with 4 solutions
-- and a hand of 12 cards with 6 solutions.
main :: IO ()
main = do
  showSolutions 9 4
  showSolutions 12 6
