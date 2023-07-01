import Data.Bool (bool)

main :: IO ()
main = do
  let raining = False

  putStrLn $ bool "No need" "UMBRELLA !" raining
  putStrLn $ flip bool "No need" "UMBRELLA !" raining

  putStrLn "\n--------\n"

  mapM_ putStrLn $
    [bool, flip bool]
      <*> ["No need"]
      <*> ["UMBRELLA !"]
      <*> [raining, not raining]
