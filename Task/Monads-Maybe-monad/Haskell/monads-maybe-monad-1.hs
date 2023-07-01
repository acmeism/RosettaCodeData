main = do print $ Just 3 >>= (return . (*2)) >>= (return . (+1))  -- prints "Just 7"
          print $ Nothing >>= (return . (*2)) >>= (return . (+1)) -- prints "Nothing"
