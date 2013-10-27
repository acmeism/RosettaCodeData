module Philosophers where

import Control.Monad
import Control.Concurrent
import Control.Concurrent.STM
import System.Random

-- TMVars are transactional references. They can only be used in transactional actions.
-- They are either empty or contain one value. Taking an empty reference fails and
-- putting a value in a full reference fails. A transactional action only succeeds
-- when all the component actions succeed, else it rolls back and retries until it
-- succeeds.
-- The Int is just for display purposes.
type Fork = TMVar Int

newFork :: Int -> IO Fork
newFork i = newTMVarIO i

-- The basic transactional operations on forks
takeFork :: Fork -> STM Int
takeFork fork = takeTMVar fork

releaseFork :: Int -> Fork -> STM ()
releaseFork i fork = putTMVar fork i

type Name = String

runPhilosopher :: Name -> (Fork, Fork) -> IO ()
runPhilosopher name (left, right) = forever $ do
  putStrLn (name ++ " is hungry.")

  -- Run the transactional action atomically.
  -- The type system ensures this is the only way to run transactional actions.
  (leftNum, rightNum) <- atomically $ do
    leftNum <- takeFork left
    rightNum <- takeFork right
    return (leftNum, rightNum)

  putStrLn (name ++ " got forks " ++ show leftNum ++ " and " ++ show rightNum ++ " and is now eating.")
  delay <- randomRIO (1,10)
  threadDelay (delay * 1000000) -- 1, 10 seconds. threadDelay uses nanoseconds.
  putStrLn (name ++ " is done eating. Going back to thinking.")

  atomically $ do
    releaseFork leftNum left
    releaseFork rightNum right

  delay <- randomRIO (1, 10)
  threadDelay (delay * 1000000)

philosophers :: [String]
philosophers = ["Aristotle", "Kant", "Spinoza", "Marx", "Russel"]

main = do
  forks <- mapM newFork [1..5]
  let namedPhilosophers  = map runPhilosopher philosophers
      forkPairs          = zip forks (tail . cycle $ forks)
      philosophersWithForks = zipWith ($) namedPhilosophers forkPairs

  putStrLn "Running the philosophers. Press enter to quit."

  mapM_ forkIO philosophersWithForks

  -- All threads exit when the main thread exits.
  getLine
