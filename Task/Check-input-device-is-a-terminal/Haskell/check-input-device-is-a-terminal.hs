module Main (main) where

import           System.Posix.IO (stdInput)
import           System.Posix.Terminal (queryTerminal)

main :: IO ()
main = do
    isTTY <- queryTerminal stdInput
    putStrLn $ if isTTY
                then "stdin is TTY"
                else "stdin is not TTY"
