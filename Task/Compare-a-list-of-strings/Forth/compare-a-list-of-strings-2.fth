: test-equality ( string node -- new-string bad? )
    over count                          \ -- string node adr cnt
    rot .line @ count   compare ;

: test-ascending ( string node -- new-string bad? )
    .line @ >r
    count  r@ count     compare -1 <>   \ -- bad?
    r> swap ;

: test-seq { seq 'test -- flag }        \ 'TEST picture: string node -- new-string bad?
     seq length 2 < if  true exit then
     seq .line @  seq 2nd  'test  find-node
     nip  0= ;
