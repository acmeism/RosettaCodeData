:: bernoulli-numbers ( n -- )
  n 1 + 0 <array> :> tab
  1 1 tab set-nth
  2 n [a,b] [| k |
    k 1 - dup
    tab nth *
    k tab set-nth
  ] each
  2 n [a,b] [| k |
    k n [a,b] [| j |
      j tab nth
      j k - 2 + *
      j 1 - tab nth
      j k - * +
      j tab set-nth
    ] each
  ] each
  1 :> s!
  1 n [a,b] [| k |
    k 2 * dup
    2^ dup 1 - *
    k tab nth
    swap / *
    s * k tab set-nth
    s -1 * s!
  ] each

  0  1 1 "%2d : %d / %d\n" printf
  1 -1 2 "%2d : %d / %d\n" printf
  1 n [a,b] [| k |
    k 2 * k tab nth
    [ numerator ] [ denominator ] bi
    "%2d : %d / %d\n" printf
  ] each
;
