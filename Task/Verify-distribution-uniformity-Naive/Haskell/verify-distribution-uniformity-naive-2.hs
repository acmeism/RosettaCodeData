*Main> mapM_ print .sort =<< distribCheck (randomRIO(1,6)) 100000 3
(1,(16911,True))
(2,(16599,True))
(3,(16670,True))
(4,(16624,True))
(5,(16526,True))
(6,(16670,True))
