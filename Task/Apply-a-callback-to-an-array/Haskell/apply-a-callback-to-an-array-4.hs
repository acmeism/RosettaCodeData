import Data.Array.IArray
let square x = x*x
let values = array (1,10) [(i,i)|i <- [1..10]] :: Array Int Int
amap square values
