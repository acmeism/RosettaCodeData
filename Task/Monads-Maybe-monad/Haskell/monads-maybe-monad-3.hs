main = do print (do x <- Just 3
                    let y = x*2
                    let z = y+1
		    return z)
          print (do x <- Nothing
                    let y = x*2
                    let z = y+1
                    return z)
