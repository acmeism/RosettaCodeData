main = print $ [3,4,5] >>= (return . (+1)) >>= (return . (*2)) -- prints [8,10,12]
