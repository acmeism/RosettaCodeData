import Data.List
import Control.Monad
import Control.Arrow

leaptext x b | b = show x ++ " is a leap year"
	     | otherwise = show x ++  " is not a leap year"

isleapsf j | 0==j`mod`100 = 0 == j`mod`400
	   | otherwise    = 0 == j`mod`4
