import Data.List (sort)
import System.Random (randomRIO)
import System.IO.Unsafe (unsafePerformIO)

data Color = Red | White | Blue deriving (Show, Eq, Ord, Enum)

dutch :: [Color] -> [Color]
dutch = sort

isDutch :: [Color] -> Bool
isDutch x = x == dutch x

randomBalls :: Int -> [Color]
randomBalls 0 = []
randomBalls n = toEnum (unsafePerformIO (randomRIO (fromEnum Red,
    fromEnum Blue))) : randomBalls (n - 1)

main :: IO ()
main = do
    let a = randomBalls 20
    case isDutch a of
        True -> putStrLn $ "The random sequence " ++ show a ++
            " is already in the order of the Dutch national flag!"
        False -> do
            putStrLn $ "The starting random sequence is " ++ show a ++ "\n"
            putStrLn $ "The ordered sequence is " ++ show (dutch a)
