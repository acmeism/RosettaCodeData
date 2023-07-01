import Data.Array (Array, listArray)

square :: Int -> Int
square x = x * x

values :: Array Int Int
values = listArray (1, 10) [1 .. 10]

main :: IO ()
main = print $ fmap square values
