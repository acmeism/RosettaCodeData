   primes=: i.&.(p:inv) 1000
   twinprimes=:  p:~.,0 1+/~/I.2=2 -~/\ primes
   doubletwinprimes=: _6 _4 0 2+/~(#~ 0,4=2-~/\])
