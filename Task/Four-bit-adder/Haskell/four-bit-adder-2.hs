nand, xor :: Int -> Int -> Int
nand = (bnot.).band
xor a b = uncurry nand. (nand a &&& nand b) $ nand a b
