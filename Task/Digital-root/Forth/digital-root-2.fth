[UNDEFINED] mu/mod [IF] : mu/mod >r 0 r@ um/mod r> swap >r um/mod r> ; [THEN]

: (Sdigit) 0. 2swap begin base @ mu/mod 2>r s>d d+ 2r> 2dup d0= until 2drop ;
: digiroot 0 -rot begin (Sdigit) 2>r 1+ 2r> 2dup base @ s>d d< until d>s ;
