import Data.Array

values = listArray (1,10) [1..10]

s = sum . elems $ values
p = product . elems $ values
