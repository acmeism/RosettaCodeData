import Control.Applicative
import Control.Monad.Trans.Maybe

gcdFProg2 = forever mainLoop <|> putStrLn "Exiting"
  where
    mainLoop = putStrLn "Enter two integers, or zero to exit" >>
               runMaybeT process >>=
               maybe empty (\r -> putStrLn ("GCD: " ++ show r))

    process = gcd <$> (lift readLn >>= exitOn 0) <*> lift readLn

    exitOn n x = if x == n then empty else pure x
