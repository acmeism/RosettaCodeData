repString :: String -> Int -> String
repString s n =
  let rep x = xs
        where
          xs = mappend x xs
  in take (n * length s) (rep s)

main :: IO ()
main = print $ repString "ha" 5
