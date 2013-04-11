data Fifo a = F [a] [a]

emptyFifo :: Fifo a
emptyFifo = F [] []

push :: Fifo a -> a -> Fifo a
push (F input output) item = F (item:input) output

pop :: Fifo a -> (Maybe a, Fifo a)
pop (F input (item:output)) = (Just item, F input output)
pop (F []    []           ) = (Nothing, F [] [])
pop (F input []           ) = pop (F [] (reverse input))

isEmpty :: Fifo a -> Bool
isEmpty (F [] []) = True
isEmpty _         = False
