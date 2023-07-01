import Control.Monad (join)

------------------- SQUARE BUT NOT CUBE ------------------

cubeRoot :: Int -> Int
cubeRoot = round . (** (1 / 3)) . fromIntegral

isCube :: Int -> Bool
isCube = (==) <*> ((^ 3) . cubeRoot)

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    ((<>) . show <*> cubeNote)
      <$> take 33 (join (*) <$> [1 ..])

cubeNote :: Int -> String
cubeNote x
  | isCube x = " (also cube of " <> show (cubeRoot x) <> ")"
  | otherwise = []
