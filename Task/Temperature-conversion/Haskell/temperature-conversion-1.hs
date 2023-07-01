import System.Exit (die)
import Control.Monad (mapM_)

main = do
  putStrLn "Please enter temperature in kelvin: "
  input <- getLine
  let kelvin = read input
  if kelvin < 0.0
      then die "Temp cannot be negative"
      else mapM_ putStrLn $ convert kelvin

convert :: Double -> [String]
convert n = zipWith (++) labels nums
    where labels      = ["kelvin: ", "celcius: ", "farenheit: ", "rankine: "]
          conversions = [id, subtract 273, subtract 459.67 . (1.8 *), (*1.8)]
          nums        = (show . ($n)) <$> conversions
