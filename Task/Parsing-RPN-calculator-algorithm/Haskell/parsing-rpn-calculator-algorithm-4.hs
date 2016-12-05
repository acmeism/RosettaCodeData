class Monad m => Logger m where
  write :: String -> m ()

instance Logger IO where write = putStr
instance a ~ String => Logger (Writer a) where write = tell

verbose2 f x y = write (show x ++ " " ++
                        show y ++ " ==> " ++
                        show res ++ "\n") >> return res
  where res = f x y
