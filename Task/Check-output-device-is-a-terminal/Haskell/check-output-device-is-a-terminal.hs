module Main where

-- requires the unix package
-- https://hackage.haskell.org/package/unix
import System.Posix.Terminal (queryTerminal)
import System.Posix.IO (stdOutput)

main :: IO ()
main = do
  istty <- queryTerminal stdOutput
  putStrLn
    (if istty
       then "stdout is tty"
       else "stdout is not tty")
