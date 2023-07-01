import System.IO
import Control.Monad
import Numeric

writeDat filename x y xprec yprec =
  withFile filename WriteMode $ \h ->
     let writeLine a b = hPutStrLn h $ showGFloat (Just xprec) a "" ++ "\t" ++ showGFloat (Just yprec) b "" in
       zipWithM_ writeLine x y
