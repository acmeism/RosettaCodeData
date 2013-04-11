maze=:4 :0
  assert.0<:n=.<:x*y
  horiz=. 0$~x,y-1
  verti=. 0$~(x-1),y
  path=.,:here=. ?x,y
  unvisited=.0 (<here+1)} 0,0,~|:0,0,~1$~y,x
  while.n do.
    neighbors=. here+"1 (,-)=0 1
    neighbors=. neighbors #~ (<"1 neighbors+1) {unvisited
    if.#neighbors do.
      n=.n-1
      next=. ({~ ?@#) neighbors
      unvisited=.0 (<next+1)} unvisited
      if.{.next=here
      do. horiz=.1 (<-:here+next-0 1)} horiz
      else. verti=. 1 (<-:here+next-1 0)} verti end.
      path=.path,here=.next
    else.
      here=.{:path
      path=.}:path
    end.
  end.
  horiz;verti
)

display=:3 :0
  size=. >.&$&>/y
  text=. (}:1 3$~2*1+{:size)#"1":size$<' '
  'hdoor vdoor'=. 2 4&*&.>&.> (#&,{@;&i./@$)&.> y
  ' ' (a:-.~0 1;0 2; 0 3;(2 1-~$text);(1 4&+&.> hdoor),,vdoor+&.>"0/2 1;2 2;2 3)} text
)
