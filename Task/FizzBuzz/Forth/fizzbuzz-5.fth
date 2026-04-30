: | >r >r dup r> mod 0= if r> count type drop then r> drop ;
: fizzbuzz1 15 c" FizzBuzz " | 3 c" Fizz " | 5 c" Buzz " | . ;
: fizzbuzz 101 1 do i fizzbuzz1 loop ;
fizzbuzz
