stack=: ''
push=: monad def '0$stack=:stack,y'
pop=: monad def 'r[ stack=:}:stack[ r=.{:stack'
empty=: monad def '0=#stack'
