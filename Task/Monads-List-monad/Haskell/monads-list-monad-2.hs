main = print $ do x <- [3,4,5]
                  y <- return (x+1)
                  z <- return (y*2)
                  return z
