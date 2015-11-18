main = f 0 100
  where f x y = let g = div (x + y) 2 in
          putStrLn (show g ++ "? (l,h,c)") >>
          getLine >>= \a -> case a of
                              "l" -> f x g
                              "h" -> f g y
                              "c" -> putStrLn "Yay!"
