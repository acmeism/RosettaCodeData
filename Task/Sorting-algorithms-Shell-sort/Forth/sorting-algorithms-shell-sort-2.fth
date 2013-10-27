defer precedes ' < is precedes

: (shell)                              ( a n h -- a n h)
  over >r tuck                         ( a h n h)
  ?do                                  ( a h)
    i swap >r                          ( a j        R: h)
    2dup cells + @ -rot                ( k a j      R: h)
    begin                              ( k a j      R: h)
      dup r@ - dup >r 0< 0=            ( k a j f    R: h j-h)
    while                              ( k a j      R: h j-h)
      -rot over over r@ cells + @      ( j k a k v  R: h j-h)
      precedes >r rot r>               ( k a j f    R: h j-h)
    while                              ( k a j      R: h j-h)
      over r@ cells + @ >r             ( k a j      R: h j-h a[j-h])
      2dup cells + r> swap !           ( k a j      R: h j-h)
      drop r>                          ( k a j'     R: h)
    repeat then                        ( k a j      R: h j-h)
    rot >r 2dup cells +                ( a j a[j]   R: h j-h k)
    r> swap ! r> drop drop r>          ( a h)
  loop r> swap
;
                                       ( a n --)
: shell dup begin dup 2 = if 2/ else 5 11 */ then dup while (shell) repeat drop 2drop ;

create array 8 , 1 , 4 , 2 , 10 , 3 , 7 , 9 , 6 , 5 ,

array 10 shell
array 10 cells dump
