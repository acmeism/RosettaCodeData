import Control.Applicative (liftA2)

strip, strip2 :: String -> String
strip = filter (liftA2 (&&) (> 31) (< 126) . fromEnum)

-- or
strip2 = filter (((&&) <$> (> 31) <*> (< 126)) . fromEnum)

main :: IO ()
main =
  (putStrLn . unlines) $
  [strip, strip2] <*> ["alphabetic 字母 with some less parochial parts"]
