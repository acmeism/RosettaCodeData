reqthreads=: {{ 0&T.@''^:(0>.y-1 T.'')0 }}
dispatchwith=: (t.'')every
newmutex=: (; 10&T.@0)@>
lock=: 11&T.@{:
unlock=: 13&T.@{:
dl=: 6!:3

dine=: {{
  'forkA forkB'=. <"1 /:~ n
  announce=. m {{ echo m,' ',y }}
  announce 'will use fork ',(":;{.forkA),' first and put it down last'
  announce 'will use fork ',(":;{.forkB),' second and put it down first'
  dl 1
  while. do.
    announce 'is hungry'
    lock forkA
    announce 'picked up fork ',":;{.forkA
    lock forkB
    announce 'picked up fork ',":;{.forkB
    announce 'is eating'
    dl 2+(?3e3)%1e3
    announce 'has finished eating'
    unlock forkB
    announce 'has put down fork ',":;{.forkB
    unlock forkA
    announce 'has put down fork ',":;{.forkA
    announce 'has left the room'
    dl 4+(?1e4)%1e3
  end.
  y
}}

start=: {{
  echo 'Hit enter to exit'
  dl 1
  reqthreads 5
  forks=. newmutex i.5
  for_philosopher.;:' Aristotle Kant Spinoza Marx Russell' do.
    forks=. 1|.forks
    (;philosopher) dine (2{.forks) dispatchwith EMPTY
  end.
  exit 1!:1]1
}}
