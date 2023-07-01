require'strings files'

family=:3 :0 M.
  if. 2>y do.
    i.0   NB. no primes less than 2
  else.
    p=. i.&.(p:inv) y
    (y#~1 p:y),~.;p (* family)&.>y-p
  end.
)

familytree=: +/@q:^:a: ::(''"_)

descendants=: family -. ]
ancestors=: 1 }. familytree
level=: #@ancestors"0

taskfmt=:'None'"_^:(0=#)@rplc&(' ';', ')@":

task1=:3 :0
  text=. '[',(":y),'] Level: ',(":level y),LF
  text=. text,'Ancestors: ',(taskfmt /:~ancestors y),LF
  if. #descendants y do.
    text=. text,'Descendants: ',(":#descendants y),LF
    text=. text,(taskfmt /:~descendants y),LF
  else.
    text=. text,'Descendants: None',LF
  end.
  text=. text,LF
)

task=:3 :0
  tot=. 'Total descendants ',(":#@; descendants&.> 1+i.y),LF
  ((;task1&.>1+i.y),tot) fwrite jpath '~user/temp/Ancestors.txt'
)

task 99
