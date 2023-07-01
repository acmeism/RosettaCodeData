main = do print (do x <- Just 3
                    y <- return (x*2)
                    z <- return (y+1)
		    return z)
          print (do x <- Nothing
                    y <- return (x*2)
                    z <- return (y+1)
                    return z)
