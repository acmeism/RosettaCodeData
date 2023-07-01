-- stack runhaskell --package=pipes-safe --package=pipes-interleave

import Pipes              (runEffect, (>->))
import Pipes.Interleave   (interleave)
import Pipes.Prelude      (stdoutLn)
import Pipes.Safe         (runSafeT)
import Pipes.Safe.Prelude (readFile)
import Prelude            hiding (readFile)
import System.Environment (getArgs)

main :: IO ()
main = do
    sourceFileNames <- getArgs
    let sources = map readFile sourceFileNames
    runSafeT . runEffect $ interleave compare sources >-> stdoutLn
