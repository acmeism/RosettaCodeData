import Data.List
import Data.Char

runLengthEncode = concatMap (\xs@(x:_) -> (show.length $ xs) ++ [x]).group
runLengthDecode = concat.uncurry (zipWith (\[x] ns -> replicate (read ns) x))
                 .foldr (\z (x,y) -> (y,z:x)) ([],[]).groupBy (\x y -> all isDigit [x,y])

main = do
 let text = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
 let encode = runLengthEncode text
 let decode = runLengthDecode encode
 mapM_ putStrLn [text,encode,decode]
 putStrLn $ "test: text == decode => " ++ (show $ text == decode)
