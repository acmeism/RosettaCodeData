: fizz ( n -- ) drop ." Fizz" ;
: buzz ( n -- ) drop ." Buzz" ;
: fb   ( n -- ) drop ." FizzBuzz" ;
: vector create does> ( n -- )
  over 15 mod cells + @ execute ;
vector .fizzbuzz
  ' fb   , ' . ,    ' . ,
  ' fizz , ' . ,    ' buzz ,
  ' fizz , ' . ,    ' . ,
  ' fizz , ' buzz , ' . ,
  ' fizz , ' . ,    ' . ,
