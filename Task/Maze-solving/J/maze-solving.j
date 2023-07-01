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

NB. source Dijkstra_equal_weights graph
NB.
NB.        +   +---+---+
NB.        | 0   1   2 |  (sample cell numbers)
NB.        +---+   +   +
NB.        | 3   4 | 5
NB.        +---+---+---+
NB.
NB. graph =: 1;0 2 4;1 5;4;1 3;2
NB. The graph is a vector of boxed vectors of neighbors.

Dijkstra_equal_weights =: 4 : 0
 dist =. previous =. #&_ n =. # graph =. y [ source =. x
 dist =. 0 source } dist
 Q =. 0
 while. #Q do.
   u =. {.Q
   Q =. }.Q
   if. _ = u{dist do. break. end.
   for_v. >u{graph do.
     if. -. v e. previous do.
       alt =. >: u { dist
       if. alt < v { dist do.
         dist =. alt v } dist
         previous =. u v } previous
         if. v e. Q do.
           echo 'belch'
         else.
           Q =. Q,v
         end.
       end.
     end.
   end.
 end.
 dist;previous
)

path =: 3 : 0
  p =. <:#y
  while. _ > {:p do.
    p =. p,y{~{:p
  end.
  |.}:p
)

solve=:3 :0
  NB. convert walls to graph
  shape =. }.@$@:>
  ew =. (,.&0 ,: 0&,.)@>@{.  NB. east west doors
  ns =. (, &0 ,: 0&, )@>@{:
  cell_offsets =. 1 _1 1 _1 * 2 # 1 , {:@shape
  cell_numbers =. i.@shape
  neighbors =. (cell_numbers +"_ _1 cell_offsets *"_1 (ew , ns))y
  graph =. (|:@(,/"_1) <@-."1 0 ,@i.@shape)neighbors NB. list of boxed neighbors
  NB. solve it
  path , > {: 0 Dijkstra_equal_weights graph
)

display=:3 :0
  size=. >.&$&>/y
  text=. (}:1 3$~2*1+{:size)#"1":size$<' '
  'hdoor vdoor'=. 2 4&*&.>&.> (#&,{@;&i./@$)&.> y
  ' ' (a:-.~0 1;0 2; 0 3;(2 1-~$text);(1 4&+&.> hdoor),,vdoor+&.>"0/2 1;2 2;2 3)} text
:
  a=. display y
  size=. >.&$&>/y
  columns=. {: size
  cells =. <"1(1 2&p.@<.@(%&columns) ,.  2 4&p.@(columns&|))x
  'o' cells } a  NB. exercise, replace cells with a gerund to draw arrows on the path.
)
