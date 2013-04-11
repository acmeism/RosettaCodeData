import System.IO
import Text.Printf
import Control.Monad

writeDat filename x y xprec yprec =
  withFile filename WriteMode $ \h ->
     -- Haskell's printf doesn't support a precision given as an argument for some reason, so we insert it into the format manually:
     let writeLine = hPrintf h $ "%." ++ show xprec ++ "g\t%." ++ show yprec ++ "g\n" in
       zipWithM_ writeLine x y
