holes=:;:'A B C D E F G H'

connections=:".;._2]0 :0
 holes e.;:'C D E'          NB. A
 holes e.;:'D E F'          NB. B
 holes e.;:'A D G'          NB. C
 holes e.;:'A B C E G H'    NB. D
 holes e.;:'A B D F G H'    NB. E
 holes e.;:'B E H'          NB. F
 holes e.;:'C D E'          NB. G
 holes e.;:'D E F'          NB. H
)
assert (-:|:) connections NB. catch typos

pegs=: 1+(A.&i.~ !)8

attempt=: [: <./@(-.&0)@,@:| connections * -/~


box=:0 :0
        A   B
       /|\ /|\
      / | X | \
     /  |/ \|  \
    C - D - E - F
     \  |\ /|  /
      \ | X | /
       \|/ \|/
        G   H
)

disp=:verb define
  rplc&(,holes;&":&>y) box
)
