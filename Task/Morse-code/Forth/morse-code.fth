HEX
\ PC speaker hardware control (requires GIVEIO or DOSBOX for windows operation)
 042 constant fctrl
 043 constant tctrl
 061 constant sctrl
 0FC constant smask

\ PC@ is Port char fetch (Intel IN instruction).  PC! is port char store (Intel OUT instruction)
: speak     ( -- ) sctrl pc@               03 or  sctrl pc! ;
: silence   ( -- ) sctrl pc@   smask and   01 or  sctrl pc! ;

: tone     ( freq -- )                 \ freq is actually just a divisor value
            ?dup                       \ check for non-zero input
            if   0B6 tctrl pc!         \ enable PC speaker
                 dup fctrl pc!         \ set freq
                 8 rshift fctrl pc!
                 speak
            else
                 silence
            then ;

\ morse demonstration begins here
DECIMAL
1000 value freq                        \ arbitrary value that sounded ok
  90 value adit                        \ 1 dit will be 90 ms

: dit_dur      adit ms ;
: dah_dur      adit 3 * ms ;
: wordgap      adit 5 * ms ;
: off_dur      adit 2/ ms ;
: lettergap    dah_dur ;

: sound ( -- ) freq tone ;

: MORSE-EMIT  ( char -- )
        dup  bl =                      \ check for space character
        if
             wordgap drop              \ and delay if detected
        else
             pad C!                    \ write char to buffer
             pad 1 evaluate            \ evaluate 1 character
             lettergap                 \ pause for correct sounding morse code
        then ;

: TRANSMIT ( ADDR LEN -- )
           cr                          \ newline,
           bounds                      \ convert loop indices to address ranges
           do
              I C@ dup emit            \ dup and send char to console
              morse-emit               \ send the morse code
           loop ;

NAMESPACE MORSE                        \ prevent name conflicts with letters and numbers

MORSE DEFINITIONS                      \ the following definitions go into MORSE namespace

: .   ( -- ) sound  dit_dur  silence off_dur ;
: -   ( -- ) sound  dah_dur  silence off_dur ;

\ define morse letters as Forth words. They transmit when executed

: A  . -  ;     : B  - . . . ;   : C  - . - . ;    : D  - . . ;
: E  . ;        : F  . . - . ;   : G  - - . ;      : H  . . . . ;
: I  . . ;      : J  . - - - ;   : K  - . - ;      : L  . - . . ;
: M  - - ;      : N  - . ;       : O  - - - ;      : P  . - - . ;
: Q  - - . - ;  : R  . - . ;     : S  . . . ;      : T  - ;
: U  . . - ;    : V  . . . - ;   : W  . - - ;      : X  - . . - ;
: Y  - . - - ;  : Z  - - . . ;

: 0  - - - - - ;     : 1  . - - - - ;
: 2  . . - - - ;     : 3  . . . - - ;
: 4  . . . . - ;     : 5  . . . . . ;
: 6  - . . . . ;     : 7  - - . . . ;
: 8  - - - . . ;     : 9  - - - - . ;

: '  - . . - . ;
: \  . - - - . ;
: !  . - . - . ;
: ?  . . - - . . ;
: ,  - - . . - - ;
: /   _ . . - . ;
: .  . - . - . - ;

 PREVIOUS DEFINITIONS                   \ go back to previous namespace
: TRANSMIT   MORSE  TRANSMIT  PREVIOUS ;
