import System.IO
       (BufferMode(..), getContents, hSetBuffering, stdin, stdout)
import Data.Char (isAlpha)

split :: String -> (String, String)
split = span isAlpha

parse :: String -> String
parse [] = []
parse l =
  let (a, w) = split l
      (b, x) = splitAt 1 w
      (c, y) = split x
      (d, z) = splitAt 1 y
  in a <> b <> reverse c <> d <> parse z

main :: IO ()
main =
  hSetBuffering stdin NoBuffering >> hSetBuffering stdout NoBuffering >> getContents >>=
  putStr . takeWhile (/= '.') . parse >>
  putStrLn "."
