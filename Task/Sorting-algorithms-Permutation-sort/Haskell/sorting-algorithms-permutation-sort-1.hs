import Control.Monad

permutationSort l = head [p | p <- permute l, sorted p]

sorted (e1 : e2 : r) = e1 <= e2 && sorted (e2 : r)
sorted _             = True

permute              = foldM (flip insert) []

insert e []          = return [e]
insert e l@(h : t)   = return (e : l) `mplus`
                       do { t' <- insert e t ; return (h : t') }
