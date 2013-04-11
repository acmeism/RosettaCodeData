hanoiM :: Integer -> IO ()
hanoiM n = hanoiM' n 1 2 3 where
  hanoiM' 0 _ _ _ = return ()
  hanoiM' n a b c = do
    hanoiM' (n-1) a c b
    putStrLn $ "Move " ++ show a ++ " to " ++ show b
    hanoiM' (n-1) c b a
