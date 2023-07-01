variable                  cnt
: Int>Str                 s>d <# #s #>  ;
: firstDigit              C@  [char] 0 -   ;
: lastDigit               + 1- c@ [char] 0 - ;
: cnt++                   cnt dup  @ 1+ dup rot ! ;
: GapfulNumber?           dup dup Int>Str
                          2dup drop firstDigit 10 *
                          -rot lastDigit +
                          /mod drop  0= ;
: main                    0 cnt ! 2dup
                          cr ." First " . ." gapful numbers  >= " .
                          begin  dup cnt @ -
                          while swap GapfulNumber?
                                if dup cr cnt++  . ." : " . then
                                1+ swap
                          repeat 2drop ;

100        30 main cr
1000000    15 main cr
1000000000 10 main cr
