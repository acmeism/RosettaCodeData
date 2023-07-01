import Control.Concurrent (threadDelay)
import Control.Exception (bracket_)
import Control.Monad (forM_)
import System.Console.Terminfo
import System.IO (hFlush, stdout)

-- Use the terminfo database to write the terminal-specific characters
-- for the given capability.
runCapability :: Terminal -> String -> IO ()
runCapability term cap =
  forM_ (getCapability term (tiGetOutput1 cap)) (runTermOutput term)

-- Control the visibility of the cursor.
cursorOff, cursorOn :: Terminal -> IO ()
cursorOff term = runCapability term "civis"
cursorOn  term = runCapability term "cnorm"

-- Print the spinning cursor.
spin :: IO ()
spin = forM_ (cycle "|/-\\") $ \c ->
  putChar c >> putChar '\r' >>
  hFlush stdout >> threadDelay 250000

main :: IO ()
main = do
  putStrLn "Spinning rod demo.  Hit ^C to stop it.\n"
  term <- setupTermFromEnv
  bracket_ (cursorOff term) (cursorOn term) spin
