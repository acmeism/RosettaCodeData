\ Original code:  "Short phrases with BIG Characters by Wil Baden  2003-02-23
\ Modified BFox  for simple 3D presentation 2015-07-14

\ Forth is a very low level language but by using primitive operations
\ we create new words in the language to solve the problem.

\ This solution coverts an acsii string to big text characters

HEX
: toUpper ( char -- char ) 05F and ;


: w,  ( n -- )  CSWAP , ;                      \ compile 'n', a 16 bit integer, into memory in the correct order


CREATE Banner-Matrix
    0000 w, 0000 w, 0000 w, 0000 w, 2020 w, 2020 w, 2000 w, 2000 w,
    5050 w, 5000 w, 0000 w, 0000 w, 5050 w, F850 w, F850 w, 5000 w,
    2078 w, A070 w, 28F0 w, 2000 w, C0C8 w, 1020 w, 4098 w, 1800 w,
    40A0 w, A040 w, A890 w, 6800 w, 3030 w, 1020 w, 0000 w, 0000 w,
    2040 w, 8080 w, 8040 w, 2000 w, 2010 w, 0808 w, 0810 w, 2000 w,
    20A8 w, 7020 w, 70A8 w, 2000 w, 0020 w, 2070 w, 2020 w, 0000 w,
    0000 w, 0030 w, 3010 w, 2000 w, 0000 w, 0070 w, 0000 w, 0000 w,
    0000 w, 0000 w, 0030 w, 3000 w, 0008 w, 1020 w, 4080 w, 0000 w,

    7088 w, 98A8 w, C888 w, 7000 w, 2060 w, 2020 w, 2020 w, 7000 w,
    7088 w, 0830 w, 4080 w, F800 w, F810 w, 2030 w, 0888 w, 7000 w,
    1030 w, 5090 w, F810 w, 1000 w, F880 w, F008 w, 0888 w, 7000 w,
    3840 w, 80F0 w, 8888 w, 7000 w, F808 w, 1020 w, 4040 w, 4000 ,
    7088 w, 8870 w, 8888 w, 7000 w, 7088 w, 8878 w, 0810 w, E000 w,
    0060 w, 6000 w, 6060 w, 0000 w, 0060 w, 6000 w, 6060 w, 4000 w,
    1020 w, 4080 w, 4020 w, 1000 w, 0000 w, F800 w, F800 w, 0000 w,
    4020 w, 1008 w, 1020 w, 4000 w, 7088 w, 1020 w, 2000 w, 2000 w,

    7088 w, A8B8 w, B080 w, 7800 w, 2050 w, 8888 w, F888 w, 8800 w,
    F088 w, 88F0 w, 8888 w, F000 w, 7088 w, 8080 w, 8088 w, 7000 w,
    F048 w, 4848 w, 4848 w, F000 w, F880 w, 80F0 w, 8080 w, F800 w,
    F880 w, 80F0 w, 8080 w, 8000 w, 7880 w, 8080 w, 9888 w, 7800 w,
    8888 w, 88F8 w, 8888 w, 8800 w, 7020 w, 2020 w, 2020 w, 7000 w,
    0808 w, 0808 w, 0888 w, 7800 w, 8890 w, A0C0 w, A090 w, 8800 w,
    8080 w, 8080 w, 8080 w, F800 w, 88D8 w, A8A8 w, 8888 w, 8800 w,
    8888 w, C8A8 w, 9888 w, 8800 w, 7088 w, 8888 w, 8888 w, 7000 w,

    F088 w, 88F0 w, 8080 w, 8000 w, 7088 w, 8888 w, A890 w, 6800 w,
    F088 w, 88F0 w, A090 w, 8800 w, 7088 w, 8070 w, 0888 w, 7000 w,
    F820 w, 2020 w, 2020 w, 2000 w, 8888 w, 8888 w, 8888 w, 7000 w,
    8888 w, 8888 w, 8850 w, 2000 w, 8888 w, 88A8 w, A8D8 w, 8800 w,
    8888 w, 5020 w, 5088 w, 8800 w, 8888 w, 5020 w, 2020 w, 2000 w,
    F808 w, 1020 w, 4080 w, F800 w, 7840 w, 4040 w, 4040 w, 7800 w,
    0080 w, 4020 w, 1008 w, 0000 w, F010 w, 1010 w, 1010 w, F000 w,
    0000 w, 2050 w, 8800 w, 0000 w, 0000 w, 0000 w, 0000 w, 00F8 w,


: >col      ( char -- ndx )                      \ convert ascii char into column index in the matrix
             toupper BL -  0 MAX ;               \ Space char (BL) = 0.  Index is clipped to 0 as minimum value


: ]banner-matrix  (  row ascii -- addr )         \ convert Banner-matrix memory to a 2 dimensional matrix
               >col   8 * Banner-matrix +  +  ;


: PLACE        ( str len addr -- )               \ store a string with length at addr
               2DUP 2>R  1+  SWAP  MOVE  2R> C! ;

synonym len  c@                                  \ fetch the 1st char of a counted string to return the length

: BIT?          ( byte bit# -- -1 | 0)           \ given a byte and bit# on stack, return true or false flag
                 1 swap lshift AND ;

DECIMAL

variable bannerstr  5 allot                      \ memory for the character string

\ Font selection characters stored as counted strings
: STARFONT    S" *"  bannerstr PLACE ;
: HASHFONT    S" ##" bannerstr PLACE ;
: 3DFONT      S" _/" bannerstr PLACE ;


: .BIGCHAR ( matrix-byte -- )
         2 7                                     \ we use bits 7 to 2
         DO
             dup I bit?                          \ check bit I in the matrix-byte on stack
             IF   bannerstr count TYPE           \ if BIT=TRUE
             ELSE bannerstr len   SPACES         \ if BIT=false
             THEN
         -1 +LOOP                                \ loop backwards
         DROP ;                                  \ drop the matrix-byte

: BANNER ( str len -- )
        8 0
        DO  CR                                   \ str len
            2dup
            BOUNDS                               \ calc. begin & end addresses of string
            DO
               J I C@ ]Banner-Matrix C@ .BIGCHAR
            LOOP                                 \ str len
        LOOP
        2DROP ;                                  \ drop str & len

\ test the solution in the Forth console
