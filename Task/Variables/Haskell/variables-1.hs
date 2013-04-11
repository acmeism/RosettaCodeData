foobar = 15

f x = x + foobar
  where foobar = 15

f x = let foobar = 15
      in  x + foobar

f x = do
    let foobar = 15
    return $ x + foobar
