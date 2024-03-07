\ utility routine to increment a variable
: 1+! 1 swap +! ;

\ edge data
variable edge-count
0 edge-count !
create edges
  'a , 'b ,  7 , edge-count 1+!
  'a , 'c ,  9 , edge-count 1+!
  'a , 'f , 14 , edge-count 1+!
  'b , 'c , 10 , edge-count 1+!
  'b , 'd , 15 , edge-count 1+!
  'c , 'd , 11 , edge-count 1+!
  'c , 'f ,  2 , edge-count 1+!
  'd , 'e ,  6 , edge-count 1+!
  'e , 'f ,  9 , edge-count 1+!

\ with accessors
: edge 3 * cells edges + ;
: edge-from   edge ;
: edge-to     edge 1 cells + ;
: edge-weight edge 2 cells + ;

\ vertex data and acccessor
create vertex-names edge-count @ 2 * cells allot
: vertex-name cells vertex-names + ;

variable vertex-count
0 vertex-count !

\ routine to look up a vertex by name
: find-vertex
    -1 swap
    vertex-count @ 0 ?do
        dup i vertex-name @ = if swap drop i swap leave then
    loop
    drop
;

\ routine to add a new vertex name if not found
: add-vertex
    dup find-vertex dup -1 = if
        swap vertex-count @ vertex-name !
        vertex-count dup @ swap 1+!
        swap drop
    else
        swap
        drop
    then
;

\ routine to add vertices to name table and replace names with indices in edges
: get-vertices
    edge-count @ 0 ?do
        i edge-from @ add-vertex i edge-from !
        i edge-to   @ add-vertex i edge-to   !
    loop
;

\ call it
get-vertices

\ variables to hold state during algorithm run
create been-visited
vertex-count @ cells allot
: visited cells been-visited + ;

create prior-vertices
vertex-count @ cells allot
: prior-vertex cells prior-vertices + ;

create distances
vertex-count @ cells allot
: distance cells distances + ;

variable origin
variable current-vertex
variable neighbor
variable current-distance
variable tentative
variable closest-vertex
variable minimum-distance
variable vertex

\ call with origin vertex name on stack
: dijkstra ( origin -- )

    find-vertex origin !

    been-visited vertex-count @ cells 0 fill
    prior-vertices vertex-count @ cells -1 fill
    distances vertex-count @ cells -1 fill

    0 origin @ distance !  \ distance to origin is 0

    origin @ current-vertex ! \ current vertex is the origin

    begin

    edge-count @ 0 ?do
        i edge-from @ current-vertex @ = if \ if edge is from current
            i edge-to @ neighbor !          \ neighbor vertex
            neighbor @ distance @ current-distance !
            current-vertex @ distance @ i edge-weight @ + tentative !
            current-distance @ -1 = tentative @ current-distance @ < or if
                tentative @ neighbor @ distance !
                current-vertex @ neighbor @ prior-vertex !
            then
        else
        then
    loop

    1 current-vertex @ visited ! \ current vertex has now been visited
    -1 closest-vertex !

    vertex-count @ 0 ?do
        i visited @ 0= if
            -1 minimum-distance !
            closest-vertex @ dup -1 <> if
                distance @ minimum-distance !
            else
                drop
            then
            i distance @ -1 <>
                minimum-distance @ -1 = i distance @ minimum-distance @ < or
              and if
                i closest-vertex !
            then
        then
    loop

    closest-vertex @ current-vertex !
    current-vertex @ -1 = until

    cr
    ." Shortest path to each vertex from " origin @ vertex-name @ emit ': emit cr
    vertex-count @ 0 ?do
        i origin @ <> if
            i vertex-name @ emit ." : " i distance @ dup
            -1 = if
                drop
                ." ∞ (unreachable)"
            else
                .
                '( emit
                i vertex !
                begin
                    vertex @ vertex-name @ emit
                    vertex @ origin @ <> while
                        ." ←"
                        vertex @ prior-vertex @ vertex !
                repeat
                ') emit
            then
            cr
        then
    loop
;
