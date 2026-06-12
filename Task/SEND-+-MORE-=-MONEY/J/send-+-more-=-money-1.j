SEND=.  10 #.   0 1 2 3&{
MORE=.  10 #.   4 5 6 1&{
MONEY=. 10 #. 4 5 2 1 7&{
M=.                   4&{

entry=. 0&{::
try=.   1&{::

sample=. (10 ?~ 8:) ; 1 + try NB. counting tries to avoid a premature convergence

good=. (not=. -.) (o=.@:) (0 = M) (and=. *.) (SEND + MORE) = MONEY

answer=. (": o SEND , ' + ' , ": o MORE , ' = ' , ": o MONEY) o entry
tries=.  ', random tries ' , ": o try

while=. ^: (^:_)

solve=.  (answer , tries) o (sample while (not o good o entry)) o ( 0 ;~ i.) o 8: f.
