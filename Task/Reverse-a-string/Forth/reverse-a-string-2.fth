\ reverse a counted string using the stack
\ Method: Read the input string character by character onto the parameter stack
\         Then write the character back into the same string from the stack

create mystring ," ABCDEFGHIJKLMNOPQRSTUVWXYZ987654321"     \ this is a counted string

: pushstr ( str -- char[1].. char[n])    \ read the contents of STR onto the stack
            count bounds  do  I c@  loop ;

: popstr   ( char[1].. char[n] str -- )  \ read chars off stack into str
            count bounds  do  I c!  loop ;

: reverse ( str -- )         \ create the reverse function with the factored words
          dup >r             \ put a copy of the string addr on return stack
          pushstr            \ push the characters onto the parameter stack
          r> popstr ;        \ get back our copy of the string addr and pop the characters into it

\ test in the Forth console
