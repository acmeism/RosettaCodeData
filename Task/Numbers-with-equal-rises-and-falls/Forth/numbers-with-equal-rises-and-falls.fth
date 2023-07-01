: in-seq? ( n -- is N in the sequence? )
  0 swap            \ height
  10 /mod           \  digit and rest of number
  begin dup while   \ as long as the number isn't zero...
    10 /mod         \ get next digit and quotient
    -rot swap       \ retrieve previous digit
    over - sgn      \ see if higher, lower or equal (-1, 0, 1)
    >r rot r> +     \ add to height
    -rot swap       \ quotient on top of stack
  repeat
  drop drop         \ drop number and last digit
  0=                \ is height equal to zero?
;

: next-val ( n -- n: retrieve first element of sequence higher than N )
  begin 1+ dup in-seq? until
;

: two-hundred
  begin over 200 < while
    next-val dup .
    swap 1+ swap
  repeat
;

: ten-million
  begin over 10000000 < while
    next-val
    swap 1+ swap
  repeat
;

0 0 \ top of stack: current index and number
." The first 200 numbers are: " two-hundred cr cr
." The 10,000,000th number is: " ten-million . cr
bye
