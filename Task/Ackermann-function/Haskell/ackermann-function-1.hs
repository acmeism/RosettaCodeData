ack :: Int -> Int -> Int
ack 0 n = succ n
ack m 0 = ack (pred m) 1
ack m n = ack (pred m) (ack m (pred n))

main :: IO ()
main = mapM_ print $ uncurry ack <$> [(0, 0), (3, 4)]
