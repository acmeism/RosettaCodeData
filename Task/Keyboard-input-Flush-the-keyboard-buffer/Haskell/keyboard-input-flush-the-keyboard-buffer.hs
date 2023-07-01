import Control.Concurrent (threadDelay)
import Control.Monad (when)
import System.IO (hFlush, stdout)
import System.Posix

-- If the file descriptor is associated with a terminal, then flush its input,
-- otherwise do nothing.
termFlush :: Fd -> IO ()
termFlush fd = do
  isTerm <- queryTerminal fd
  when isTerm $ discardData fd InputQueue

main :: IO ()
main = do
  putStrLn "Type some stuff...\n"
  threadDelay $ 3 * 1000000
  putStrLn "\n\nOk, stop typing!\n"
  threadDelay $ 2 * 1000000

  termFlush stdInput

  putStr "\n\nType a line of text, ending with a newline: "
  hFlush stdout
  line <- getLine
  putStrLn $ "You typed: " ++ line
  termFlush stdInput
