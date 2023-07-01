main = mapM_ (putStrLn . beer) [99, 98 .. 0]
beer 1 = "1 bottle of beer on the wall\n1 bottle of beer\nTake one down, pass it around"
beer 0 = "better go to the store and buy some more."
beer v = show v ++ " bottles of beer on the wall\n"
                ++ show v
                ++" bottles of beer\nTake one down, pass it around\n"
                ++ head (lines $ beer $ v-1) ++ "\n"
