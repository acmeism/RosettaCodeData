type Stack a = [a]

create :: Stack a
create = []

push :: a -> Stack a -> Stack a
push = (:)

pop :: Stack a -> (a, Stack a)
pop []     = error "Stack empty"
pop (x:xs) = (x,xs)

empty :: Stack a -> Bool
empty = null

peek :: Stack a -> a
peek []    = error "Stack empty"
peek (x:_) = x
