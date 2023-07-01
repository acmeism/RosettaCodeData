: STRING,  ( caddr len -- ) \ Allocate space & compile string into memory
             HERE  OVER CHAR+  ALLOT  PLACE ;

: "     ( -- ) [CHAR] " PARSE  STRING, ; \ Parse input to " and compile to memory

\ Array delimiter words
: {  ALIGN 0 C, ;               \ Compile 0 byte start/end of array
: }  ALIGN 0 C,  ;

\ String array words
: {NEXT}    ( str -- next_str)       \ Iterate to next string
           COUNT + ;

: {NTH}    ( n array_addr -- str)   \ Returns address of the Nth item in the array
           SWAP 0 DO {NEXT} LOOP ;

: {LEN} ( array_addr -- n)  \ count strings in the array
          0 >R                      \ Counter on Rstack
          {NEXT}
          BEGIN
             DUP C@                 \ Fetch length byte
          WHILE                     \ While true
             R> 1+ >R               \ Inc. counter
             {NEXT}
          REPEAT
          DROP
          R> ;      \ return counter to data stack
