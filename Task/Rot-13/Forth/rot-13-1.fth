: r13 ( c -- o )
  dup 32 or                                    \ tolower
  dup [char] a [char] z 1+ within if
    [char] m > if -13 else 13 then +
  else drop then ;
