\ Gforth 0.7.9_20211014

: fusc ( n -- n)                     \  input n -- output fusc(n)
  dup  dup  0= swap  1 = or          \  n = 0 or 1
  if  exit                           \  return n
  else dup 2 mod 0=                  \  test even
       if 2/ recurse                 \  even fusc(n)= fusc(n/2)
       else dup  1- 2/ recurse       \  odd  fusc(n) = fusc((n-1)/2) +
            swap 1+ 2/ recurse  +    \                 fusc((n+1)/2)
       then
  then
;

: cntDigits ( n -- n )               \ returns the numbers of digits
  0 begin 1+ swap
        10 /
        swap  over
  0= until
  swap drop
;

: fuscLen ( n -- )                    \ count until end index
  cr 1   swap  0
  do
    i fusc cntDigits
    over > if 1+
                  ." fusc( " i . ." ) : "
                  i fusc  . cr
           then
  loop
;

: firstFusc ( n -- )                  \ show  fusc(i)   until  limit
   dup ." First " . ." fusc(n) : " cr
   0 do  I fusc .  loop cr
;

61 firstFusc

20 1000 1000 * * fuscLen

bye
