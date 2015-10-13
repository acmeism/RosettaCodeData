\ Rosetta Code Binary Strings Demo in Forth
\ Portions of this code are found at http://forth.sourceforge.net/mirror/toolbelt-ext/index.html

\ String words created in this code:
\       STR<    STR>    STR=    COMPARESTR      SUBSTR  STRPAD  CLEARSTR
\       =""     ="      STRING: MAXLEN  REPLACE-CHAR    COPYSTR WRITESTR
\       ,"      APPEND-CHAR     STRING, PLACE   CONCAT  APPEND  C+!  ENDSTR
\       COUNT   STRLEN

: STRLEN  ( addr -- length)  c@ ;        \ alias the "character fetch" operator

: COUNT   ( addr --  addr+1 length)      \ returns the address+1 and the length byte on the stack
          dup  strlen swap 1+ swap ;

: ENDSTR  ( str -- addr)                 \ calculate the address at the end of a string
          COUNT + ;

: C+!     ( n addr -- )                  \ primitive: increment a byte at addr by n
          DUP C@ ROT + SWAP C! ;

: APPEND  ( addr1 length addr2 -- )      \ Append addr1 length to addr2
          2dup 2>r  endstr swap move 2r> c+! ;

: CONCAT  ( string1 string2 -- )          \ concatenate counted string1 to counted string2
           >r  COUNT  R> APPEND ;

: PLACE  ( addr1 len addr2 -- )           \ addr1 and length, placed at addr2 as counted string
           2dup 2>r  1+  swap  move  2r> c! ;

: STRING, ( addr len -- )                 \ compile a string at the next available memory (called 'HERE')
            here  over 1+  allot  place ;

: APPEND-CHAR  ( char string -- )         \ append char to string
           dup >r  count dup 1+ r> c! + c! ;

: ,"       [CHAR] " PARSE  STRING, ;      \ Parse input stream until '"' and compile into memory


: WRITESTR ( string -- )                  \ output a counted string with a carriage return
           count  type CR ;

: COPYSTR  ( string1 string3 -- )         \ String cloning and copying COPYSTR
           >r  count  r> PLACE ;

: REPLACE-CHAR ( char1 char2 string -- )  \ replace all char2 with char1 in string
          count                           \ get string's address and length
          BOUNDS                          \ calc start and end addr of string for do-loop
          DO                              \ do a loop from start address to end address
             I C@ OVER =                  \ fetch the char at loop index compare to CHAR2
             IF
                OVER I C!                 \ if its equal, store CHAR1 into the index address
             THEN
          LOOP
          2drop ;                         \ drop the chars off the stack


 256 constant maxlen                      \ max size of byte counted string in this example

: string:   CREATE    maxlen ALLOT ;      \ simple string variable constructor


: ="      ( string -- )                   \ String variable assignment operator (compile time only)
          [char] " PARSE  ROT  PLACE ;

: =""     ( string -- )  0 swap c! ;      \ empty a string, set count to zero


: clearstr ( string -- )                  \ erase a string variables contents, fill with 0
           maxlen erase ;


  string: strpad                           \ general purpose storage buffer

: substr  ( string1 start length -- strpad) \ Extract a substring of string and return an output string
         strpad =""                        \ clear strpad
         >r                                \ push the length
         +                                 \ calc the new start addr
         r> strpad append                  \ pop the length and append to strpad
         strpad ;                          \ return the address of strpad.


\ COMPARE takes the 4 inputs from the stack (addr1 len1  addr2 len2 )
\ and returns a flag for equal (0) , less-than (1)  or greater-than (-1) on the stack

  : comparestr ( string1 string2 -- flag)  \ adapt for use with counted strings
              count rot count compare ;

\ now it's simple to make new operators
  : STR=   ( string1 string2 -- flag)
             comparestr  0= ;

  : STR>   ( string1 string2 -- flag)
             comparestr -1 = ;

  : STR<   ( string1 string2 -- flag)
             comparestr 1 = ;
