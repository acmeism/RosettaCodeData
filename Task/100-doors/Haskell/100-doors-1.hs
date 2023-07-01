data Door
  = Open
  | Closed
  deriving (Eq, Show)

toggle :: Door -> Door
toggle Open = Closed
toggle Closed = Open

toggleEvery :: Int -> [Door] -> [Door]
toggleEvery k = zipWith toggleK [1 ..]
  where
    toggleK n door
      | n `mod` k == 0 = toggle door
      | otherwise = door

run :: Int -> [Door]
run n = foldr toggleEvery (replicate n Closed) [1 .. n]

main :: IO ()
main = print $ filter ((== Open) . snd) $ zip [1 ..] (run 100)
