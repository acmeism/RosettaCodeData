: n     ( n -- n+1 )    dup .         1+ ;
: f     ( n -- n+1 )    ." Fizz "     1+ ;
: b     ( n -- n+1 )    ." Buzz "     1+ ;
: fb    ( n -- n+1 )    ." FizzBuzz " 1+ ;
: fb10  ( n -- n+10 )   n n f n b f n n f b ;
: fb15  ( n -- n+15 )   fb10 n f n n fb ;
: fb100 ( n -- n+100 )  fb15 fb15 fb15 fb15 fb15 fb15 fb10 ;
: .fizzbuzz ( -- )      1 fb100 drop ;
