: mytask(s)
   while( true ) [
      s acquire "Semaphore acquired" .cr
      2000 sleep
      s release "Semaphore released" .cr
      ] ;

: test(n)
| s i |
   Semaphore new(n) ->s
   10 loop: i [ #[ s mytask ] & ] ;
