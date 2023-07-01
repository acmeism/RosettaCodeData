HEX
\ PC speaker hardware control (requires giveio or DOSBOX for windows operation)
 042 constant fctrl        061 constant sctrl
 0FC constant smask        043 constant tctrl
 0B6 constant spkr

: sing      ( -- ) sctrl pc@               03 or  sctrl pc! ;
: silence   ( -- ) sctrl pc@   smask and   01 or  sctrl pc! ;

: tone     ( divisor -- )
            ?dup                                         \ check for non-zero input
            if   spkr  tctrl pc!                         \ enable PC speaker
                 dup   fctrl pc!                         \ load low byte
                 8 rshift fctrl pc!                      \ load high byte
                 sing
            else silence
            then ;

DECIMAL
1193181. 2constant clock                                 \ internal oscillator freq. MHz x 10

: Hz ( freq -- divisor) clock rot um/mod nip  ;          \ convert Freq to osc. divisor

\ duration control variables and values
variable on_time
variable off_time
variable feel                                            \ controls the on/off time ratio

60 value tempo

4000 tempo um* 2constant timebase                        \ 1 whole note=4000 ms @ 60 Beats/min

: bpm>ms    ( bpm -- ms) timebase rot um/mod nip ;       \ convert beats per minute to milliseconds
: wholenote ( -- ms )  tempo bpm>ms ;                    \ using tempo set the BPM

: play      ( divisor -- )
            tone on_time @ ms   silence  off_time @ ms ;

: expression ( ms n --)                                  \ adjust the on:off ratio using n
           over swap -  tuck -   ( -- on-mS off-mS )
           off_time !  on_time ! ;                       \ store times in variables

: note      ( -- ms ) on_time @ off_time @ + ;           \ returns duration of current note

: duration!    ( ms -- )  feel @ expression ;

: 50%       ( n -- n/2)    2/ ;
: %         ( n n2  -- n%) 100 */ ;                      \ calculate n2% of n
: 50%+      ( n -- n+50%)  dup 50% + ;                   \ dotted notes have 50% more time

VOCABULARY MUSIC

MUSIC DEFINITIONS
: BPM       ( bpm -- )                                  \ set tempo in beats per minute
            to tempo
            wholenote duration! ;

: legato      0 feel ! ;
: staccatto   note 8 %  feel ! ;
: Marcato     note 3 %  feel ! ;

: 1/1      wholenote      duration! ;
: 1/2      wholenote 50%  duration! ;
: 1/2.     1/2  note 50%+ duration! ;
: 1/4      1/2  note 50%  duration! ;
: 1/4.     1/4  note 50%+ duration! ;
: 1/8      1/4  note 50%  duration! ;
: 1/8.     1/8  note 50%+ duration! ;
: 1/16     1/8  note 50%  duration! ;
: 1/32     1/16 note 50%  duration! ;
: rest     note ms ;

\ note object creator
: note:    create  hz ,                    \ compile time: compile divisor into the note
           does>  @ play ;                 \ run time: fetch the value and play the tone

\ freq  Natural    Freq  Accidental    En-harmonic
\ -------------    ----------------   ----------------
  131 note: C3     139 note: C#3       synonym Db3 C#3
  147 note: D3     156 note: D#3       synonym Eb3 D#3
  165 note: E3
  175 note: F3     185 note: F#3       synonym Gb3 F#3
  196 note: G3     208 note: G#3       synonym Ab3 G#3
  220 note: A3     233 note: A#3       synonym Bb3 A#3
  247 note: B3
  262 note: C4     277 note: C#4       synonym Db4 C#4

: Cmajor      1/8  C3 D3 E3  F3 G3 A3  B3  C4 ;
: Chromatic   1/8  C3 C#3 D3 D#3 E3 F3 F#3 G3 G#3 A3 A#3 B3 C4 ;
