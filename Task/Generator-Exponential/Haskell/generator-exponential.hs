import Data.List.Ordered

powers :: Int -> [Int]
powers m = map (^ m) [0..]

squares :: [Int]
squares = powers 2

cubes :: [Int]
cubes = powers 3

foo :: [Int]
foo = filter (not . has cubes) squares

main :: IO ()
main = print $ take 10 $ drop 20 foo
