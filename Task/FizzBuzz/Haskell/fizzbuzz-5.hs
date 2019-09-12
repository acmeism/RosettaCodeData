import Data.List (zipWith3)
import Data.Bool (bool)

fizzBuzz :: [String]
fizzBuzz =
  zipWith3
    (\f b n ->
        let fb = f ++ b
        in bool fb n (null fb))
    (cycle $ replicate 2 [] ++ ["fizz"])
    (cycle $ replicate 4 [] ++ ["buzz"])
    (show <$> [1 ..])

main :: IO ()
main = mapM_ putStrLn $ take 100 fizzBuzz
