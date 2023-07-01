require'stats'
digits=: 10&#.inv"0 :. ([: ".@; (<'x'),~":&.>)
summar=: (#/.~ ,@,. ~.)@\:~&.digits
sequen=: ~.@(, summar@{:)^:_
values=: ~. \:~&.digits i.1e6
allvar=: [:(#~(=&<.&(10&^.) >./))@~.({~ perm@#)&.(digits"1)
