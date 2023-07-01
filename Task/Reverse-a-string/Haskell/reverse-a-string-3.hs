import Data.Char (isMark)
import Data.List (groupBy)
myReverse = concat . reverse . groupBy (const isMark)
