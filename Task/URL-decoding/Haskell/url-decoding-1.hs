import qualified Data.Char as Char

urlDecode :: String -> Maybe String
urlDecode [] = Just []
urlDecode ('%':xs) =
  case xs of
    (a:b:xss) ->
      urlDecode xss
      >>= return . ((Char.chr . read $ "0x" ++ [a,b]) :)
    _ -> Nothing
urlDecode ('+':xs) = urlDecode xs >>= return . (' ' :)
urlDecode (x:xs) = urlDecode xs >>= return . (x :)

main :: IO ()
main = putStrLn . maybe "Bad decode" id $ urlDecode "http%3A%2F%2Ffoo%20bar%2F"
