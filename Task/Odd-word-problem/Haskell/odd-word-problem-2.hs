isAlpha :: Char -> Bool
isAlpha = flip elem $ ['a'..'z'] ++ ['A'..'Z']

parse :: IO ()
parse = do
  x <- getChar
  putChar x
  case () of
   _ | x == '.'  -> return ()
     | isAlpha x -> parse
     | otherwise -> do
         c <- revParse
         putChar c
         if c == '.'
           then return ()
           else parse

revParse :: IO Char
revParse = do
  x <- getChar
  case () of
   _ | x == '.'  -> return x
     | isAlpha x -> do
         c <- revParse
         putChar x
         return c
     | otherwise -> return x

main :: IO ()
main = hSetBuffering stdin NoBuffering >> hSetBuffering stdout NoBuffering >>
       parse >> putStrLn ""
