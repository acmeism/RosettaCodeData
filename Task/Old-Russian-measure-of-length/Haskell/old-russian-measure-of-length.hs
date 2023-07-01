module Main where

import Text.Printf (printf)
import System.Environment (getArgs, getProgName)

tochka     = ("tochka"    , 0.000254)
liniya     = ("liniya"    , 0.00254)
centimeter = ("centimeter", 0.01)
diuym      = ("diuym"     , 0.0254)
vershok    = ("vershok"   , 0.04445)
piad       = ("piad"      , 0.1778)
fut        = ("fut"       , 0.3048)
arshin     = ("arshin"    , 0.7112)
meter      = ("meter"     , 1.0)
sazhen     = ("sazhen"    , 2.1336)
kilometer  = ("kilometer" , 1000.0)
versta     = ("versta"    , 1066.8)
milia      = ("milia"     , 7467.6)

units :: [(String, Double)]
units = [tochka, liniya, centimeter, diuym, vershok, piad, fut, arshin, meter, sazhen, kilometer, versta, milia]


convert :: Double -> Double -> IO ()
convert num factor = mapM_ (\(unit, fac) -> printf "| %-10s | %-22f|\n" unit  (num * factor / fac)) units

main :: IO ()
main = do
  args <- getArgs
  case args of
    [x,y] | [(num, "")]   <- reads x :: [(Double, String)]
          , (Just factor) <- lookup y units -> convert num factor
    (_) -> do
      name <- getProgName
      printf "Arguments were wrong - please use ./%s <number> <unit>\n" name
