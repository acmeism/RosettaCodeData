\ rosetta Code strip chars from a string
\ Forth is a low level language that is extended to solve your problem
\ Using the Forth parser, primitive memory operations and the stack
\ for data transfer between functions, we create high level functionality
\ STRIPCHARS here has 1st Argument as the chars. If you don't like it
\ reverse the arguments with SWAP. :)

create buffer1  256 allot                  \ temp buffer, returns its address to the stack

\ extend the language a little
: STRING,  ( addr len -- )                 \ compile a string at the next available memory (called 'HERE')
           here  over 1+  allot  place ;

: APPEND-CHAR  ( char string -- )          \ append char to a counted string
           dup >r  count dup 1+ r> c! + c! ;

: ,"       [CHAR] " PARSE  STRING, ;       \ Parse input stream until '"' and compile into memory

: =""      ( cstring -- )  0 swap c! ;     \ empty a counted string by setting count to zero

: writestr ( cstring -- )                  \ print a counted string from the stack with new line
           count type cr ;


\ use our language extensions
create "aei" ," aei"
create input ," She was a soul stripper. She took my heart!"

: stripchars ( str1 str2 -- str3 )         \ chars are 1st argument, str2 is the input string
        buffer1 =""                        \ clear the buffer
        count bounds                       \ calc loop limits for str2
        DO
           dup count I C@ scan 0=          \ scan for char in str1, test for zero
           IF                              \ if NOT found
              I c@ buffer1 append-char     \ append the str2 char to buffer1
           THEN                            \ ... and then ... continue the loop
        LOOP
        drop                               \ we don't need str1 now
        buffer1 ;                          \ addr of buffer1 put on stack as the output
