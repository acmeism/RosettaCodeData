{-# LANGUAGE LambdaCase #-}

import System.Exit (die)
import Control.Monad (mapM_)
import Control.Error.Safe (tryAssert, tryRead)
import Control.Monad.Trans (liftIO)
import Control.Monad.Trans.Except

main = putStrLn "Please enter temperature in kelvin: " >>
       runExceptT getTemp >>=
       \case Right x  -> mapM_ putStrLn $ convert x
             Left err -> die err

convert :: Double -> [String]
convert n = zipWith (++) labels nums
    where labels      = ["kelvin: ", "celcius: ", "farenheit: ", "rankine: "]
          conversions = [id, subtract 273, subtract 459.67 . (1.8 *), (1.8 *)]
          nums        = (show . ($ n)) <$> conversions

getTemp :: ExceptT String IO Double
getTemp = do
    t <- liftIO getLine >>= tryRead "Could not read temp"
    tryAssert "Temp cannot be negative" (t>=0)
    return t
