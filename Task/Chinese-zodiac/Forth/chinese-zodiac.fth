: position ( n -- n ) 4 - 60 mod ;

s" Rat    Ox     Tiger  Rabbit Dragon Snake  Horse  Goat   Monkey RoosterDog    Pig    "
drop constant animals
: animal ( n -- a u ) 12 mod  7 * animals +  7 -trailing ;

s" Wood Fire EarthMetalWater" drop constant elements
: element ( n -- a u ) 2/ 5 mod  5 * elements +  5 -trailing ;

s" yangyin " drop constant aspects
: aspect ( n -- a u ) 2 mod  4 * aspects +  4 -trailing ;

next-arg s>number? drop d>s position
 dup element type space
 dup animal  type space
     aspect  '(' emit type ')' emit cr
bye
