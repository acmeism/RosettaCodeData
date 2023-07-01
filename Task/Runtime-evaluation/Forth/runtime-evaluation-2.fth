unused .    \ show how much dictionary space is available
marker restore

create foo 30 allot
: my-def 30 0 do cr i . ." test" loop ;

unused .    \ lower than before

restore
unused .    \ same as first unused;  restore, foo, and my-def no longer defined
