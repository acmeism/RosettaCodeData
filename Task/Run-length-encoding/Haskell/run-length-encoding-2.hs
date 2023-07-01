import Data.Char (isDigit)
import Data.List (group, groupBy)

runLengthEncode :: String -> String
runLengthEncode =
  concatMap
    ( \xs@(x : _) ->
        ( show . length $ xs
        )
          <> [x]
    )
    . group

runLengthDecode :: String -> String
runLengthDecode =
  concat . uncurry (zipWith (\[x] ns -> replicate (read ns) x))
    . foldr (\z (x, y) -> (y, z : x)) ([], [])
    . groupBy (\x y -> all isDigit [x, y])

main :: IO ()
main = do
  let text = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
      encode = runLengthEncode text
      decode = runLengthDecode encode
  mapM_ putStrLn [text, encode, decode]
  putStrLn $ "test: text == decode => " <> show (text == decode)
