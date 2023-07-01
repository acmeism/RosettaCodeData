import Control.Monad.State

type Stack a b = State [a] b

push :: a -> Stack a ()
push = modify . (:)

pop :: Stack a a
pop = do
    nonEmpty
    x <- peek
    modify tail
    return x

empty :: Stack a Bool
empty = gets null

peek :: Stack a a
peek = nonEmpty >> gets head

nonEmpty :: Stack a ()
nonEmpty = empty >>= flip when (fail "Stack empty")
