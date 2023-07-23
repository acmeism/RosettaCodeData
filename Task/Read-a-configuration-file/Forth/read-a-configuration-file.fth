\ declare the configuration variables in the FORTH app
FORTH DEFINITIONS

32 CONSTANT $SIZE

VARIABLE FULLNAME       $SIZE ALLOT
VARIABLE FAVOURITEFRUIT $SIZE ALLOT
VARIABLE NEEDSPEELING
VARIABLE SEEDSREMOVED
VARIABLE OTHERFAMILY(1) $SIZE ALLOT
VARIABLE OTHERFAMILY(2) $SIZE ALLOT

: -leading  ( addr len -- addr' len' )
            begin over c@ bl = while 1 /string repeat ;   \ remove leading blanks

: trim      ( addr len -- addr len) -leading -trailing ;  \ remove blanks both ends

\ create the config file interpreter -------
VOCABULARY CONFIG                                          \ create a namespace
CONFIG DEFINITIONS                                         \ put things in the namespace
: SET     ( addr --) true swap ! ;
: RESET   ( addr --) false swap ! ;
: #        ( -- )      1 PARSE 2DROP ;                     \ parse line and throw away
: =        ( addr --)  1 PARSE trim ROT PLACE ;            \ string assignment operator
' # alias ;                                                \ 2nd comment operator is simple

FORTH DEFINITIONS
\ this command reads and interprets the config.txt file
: CONFIGURE ( -- ) CONFIG  s" CONFIG.TXT" INCLUDED  FORTH ;
\ config file interpreter ends ------

\ tools to validate the CONFIG interpreter
: $.      ( str --)  count type ;
: BOOL.   ( ? --)    @ IF ." ON"  ELSE ." OFF" THEN ;

: .CONFIG       CR  ." Fullname       : " FULLNAME $.
                CR  ." Favourite fruit: " FAVOURITEFRUIT $.
                CR  ." Needs peeling  : " NEEDSPEELING bool.
                CR  ." Seeds removed  : " SEEDSREMOVED bool.
                CR  ." Family:"
                CR   otherfamily(1) $.
                CR   otherfamily(2) $.  ;
